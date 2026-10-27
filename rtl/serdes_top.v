`timescale 1ns/1ps
module serdes_top (
    input clk,
    input rst_n,
    input [7:0] tx_data,
    input tx_k,
    input tx_valid,
    output tx_ready,
    output serial_tx,
    input serial_rx,
    input rx_bit_valid,
    input force_realign,
    output [7:0] rx_data,
    output rx_k,
    output rx_valid,
    output comma_detected,
    output [3:0] alignment_offset,
    output symbol_locked,
    output code_error,
    output disparity_error,
    output tx_invalid_k,
    output serial_tx_valid
);
    // Two-cycle encode-to-buffer path with one outstanding transaction.
    wire [9:0] encoded_word;
    wire encoded_valid, tx_rd, serializer_ready, serializer_busy;
    reg pending, buffer_valid;
    reg [9:0] buffer_word;
    assign tx_ready = !pending && !buffer_valid;
    wire accept = tx_valid && tx_ready;
    encoder_8b10b encoder (
        .clk               (clk),
        .rst_n             (rst_n),
        .data_in           (tx_data),
        .k_in              (tx_k),
        .valid_in          (accept),
        .encoded_out       (encoded_word),
        .valid_out         (encoded_valid),
        .invalid_k         (tx_invalid_k),
        .running_disparity (tx_rd)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pending <= 0;
            buffer_valid <= 0;
            buffer_word <= 0;
        end else begin
            if (accept) pending <= 1;
            if (encoded_valid) begin
                buffer_word <= encoded_word;
                buffer_valid <= 1;
                pending <= 0;
            end
            if (tx_invalid_k) pending <= 0;
            if (buffer_valid && serializer_ready) buffer_valid <= 0;
        end
    end
    tx_serializer serializer (
        .clk        (clk),
        .rst_n      (rst_n),
        .data_in    (buffer_word),
        .valid_in   (buffer_valid),
        .serial_out (serial_tx),
        .ready      (serializer_ready),
        .busy       (serializer_busy)
    );
    // Indicates the bit interval following the edge, including the final bit.
    reg bit_active;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) bit_active <= 0;
        else bit_active <= serializer_busy || (serializer_ready && buffer_valid);
    end
    assign serial_tx_valid = bit_active;
    wire [9:0] raw_data, aligned_data;
    wire raw_valid, aligned_valid, decoded_valid, alignment_enable;
    rx_deserializer deserializer (
        .clk       (clk),
        .rst_n     (rst_n),
        .serial_in (serial_rx),
        .bit_valid (rx_bit_valid),
        .raw_data  (raw_data),
        .raw_valid (raw_valid)
    );
    reg [9:0] previous_raw;
    reg have_raw;
    wire [19:0] window_data = {previous_raw, raw_data};
    wire window_valid = raw_valid && have_raw;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            previous_raw <= 0;
            have_raw <= 0;
        end else if (raw_valid) begin
            previous_raw <= raw_data;
            have_raw <= 1;
        end
    end
    wire [3:0] comma_offset;
    wire comma_polarity, lock_acquired, lock_lost;
    k28_5_detector detector (
        .window_data    (window_data),
        .window_valid   (window_valid),
        .comma_found    (comma_detected),
        .comma_offset   (comma_offset),
        .comma_polarity (comma_polarity)
    );
    rx_word_aligner aligner (
        .clk              (clk),
        .rst_n            (rst_n),
        .raw_data         (raw_data),
        .raw_valid        (raw_valid),
        .alignment_offset (alignment_offset),
        .alignment_enable (alignment_enable),
        .aligned_data     (aligned_data),
        .aligned_valid    (aligned_valid)
    );
    // Decode the acquisition comma to establish RD before the first aligned word.
    // Its initial disparity diagnostic is excluded from lock verification.
    wire seed_comma = comma_detected && !alignment_enable;
    wire [9:0] decoder_word = seed_comma ? (window_data >> (10 - comma_offset)) : aligned_data;
    reg decoder_payload;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) decoder_payload <= 0;
        else decoder_payload <= aligned_valid && !seed_comma;
    end
    wire payload_valid = decoded_valid && decoder_payload;
    decoder_8b10b decoder (
        .clk             (clk),
        .rst_n           (rst_n),
        .encoded_in      (decoder_word),
        .valid_in        (aligned_valid || seed_comma),
        .data_out        (rx_data),
        .k_out           (rx_k),
        .valid_out       (decoded_valid),
        .code_error      (code_error),
        .disparity_error (disparity_error)
    );
    rx_symbol_lock lock_controller (
        .clk              (clk),
        .rst_n            (rst_n),
        .comma_found      (comma_detected),
        .comma_offset     (comma_offset),
        .aligned_valid    (payload_valid),
        .code_error       (code_error),
        .disparity_error  (disparity_error),
        .force_realign    (force_realign),
        .symbol_locked    (symbol_locked),
        .alignment_offset (alignment_offset),
        .alignment_enable (alignment_enable),
        .lock_acquired    (lock_acquired),
        .lock_lost        (lock_lost)
    );
    assign rx_valid = payload_valid && symbol_locked;
endmodule
