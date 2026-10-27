`timescale 1ns/1ps
// Full-code legality table, including sub-block disparity and alternate .7 rules.
module decoder_8b10b (
    input clk,
    input rst_n,
    input [9:0] encoded_in,
    input valid_in,
    output reg [7:0] data_out,
    output reg k_out,
    output reg valid_out,
    output reg code_error,
    output reg disparity_error
);
    reg running_disparity;
    reg found;
    reg [7:0] decoded;
    reg control;
    reg [1:0] allowed, next_rd;

    always @(*) begin
        found = 1;
        decoded = 0;
        control = 0;
        allowed = 0;
        next_rd = 0;
        case (encoded_in)
            10'b0001010101: begin
                decoded = 8'h57;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001010110: begin
                decoded = 8'hd7;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001010111: begin
                decoded = 8'hf7;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001011001: begin
                decoded = 8'h37;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001011010: begin
                decoded = 8'hb7;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001011011: begin
                decoded = 8'h17;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001011100: begin
                decoded = 8'h77;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001011101: begin
                decoded = 8'h97;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001011110: begin
                decoded = 8'hf7;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001100101: begin
                decoded = 8'h48;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001100110: begin
                decoded = 8'hc8;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001101001: begin
                decoded = 8'h28;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001101010: begin
                decoded = 8'ha8;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001101011: begin
                decoded = 8'h08;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001101100: begin
                decoded = 8'h68;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001101101: begin
                decoded = 8'h88;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001101110: begin
                decoded = 8'he8;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001110001: begin
                decoded = 8'he7;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001110010: begin
                decoded = 8'h87;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001110011: begin
                decoded = 8'h67;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001110100: begin
                decoded = 8'h07;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0001110101: begin
                decoded = 8'h47;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001110110: begin
                decoded = 8'hc7;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001111001: begin
                decoded = 8'h27;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0001111010: begin
                decoded = 8'ha7;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0010010101: begin
                decoded = 8'h5b;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010010110: begin
                decoded = 8'hdb;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010010111: begin
                decoded = 8'hfb;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0010011001: begin
                decoded = 8'h3b;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010011010: begin
                decoded = 8'hbb;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010011011: begin
                decoded = 8'h1b;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0010011100: begin
                decoded = 8'h7b;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010011101: begin
                decoded = 8'h9b;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0010011110: begin
                decoded = 8'hfb;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0010100101: begin
                decoded = 8'h44;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010100110: begin
                decoded = 8'hc4;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010101001: begin
                decoded = 8'h24;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010101010: begin
                decoded = 8'ha4;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010101011: begin
                decoded = 8'h04;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0010101100: begin
                decoded = 8'h64;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010101101: begin
                decoded = 8'h84;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0010101110: begin
                decoded = 8'he4;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0010110001: begin
                decoded = 8'hf4;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010110010: begin
                decoded = 8'h94;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010110011: begin
                decoded = 8'h74;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0010110100: begin
                decoded = 8'h14;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0010110101: begin
                decoded = 8'h54;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0010110110: begin
                decoded = 8'hd4;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0010110111: begin
                decoded = 8'hf4;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0010111001: begin
                decoded = 8'h34;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0010111010: begin
                decoded = 8'hb4;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0010111011: begin
                decoded = 8'h14;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0010111100: begin
                decoded = 8'h74;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0010111101: begin
                decoded = 8'h94;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011000101: begin
                decoded = 8'h58;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011000110: begin
                decoded = 8'hd8;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011001001: begin
                decoded = 8'h38;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011001010: begin
                decoded = 8'hb8;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011001011: begin
                decoded = 8'h18;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0011001100: begin
                decoded = 8'h78;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011001101: begin
                decoded = 8'h98;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0011001110: begin
                decoded = 8'hf8;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0011010001: begin
                decoded = 8'hec;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011010010: begin
                decoded = 8'h8c;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011010011: begin
                decoded = 8'h6c;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0011010100: begin
                decoded = 8'h0c;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011010101: begin
                decoded = 8'h4c;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0011010110: begin
                decoded = 8'hcc;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0011011001: begin
                decoded = 8'h2c;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0011011010: begin
                decoded = 8'hac;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0011011011: begin
                decoded = 8'h0c;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011011100: begin
                decoded = 8'h6c;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0011011101: begin
                decoded = 8'h8c;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011011110: begin
                decoded = 8'hec;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011100001: begin
                decoded = 8'hfc;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011100010: begin
                decoded = 8'h9c;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011100011: begin
                decoded = 8'h7c;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0011100100: begin
                decoded = 8'h1c;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0011100101: begin
                decoded = 8'h5c;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0011100110: begin
                decoded = 8'hdc;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0011101001: begin
                decoded = 8'h3c;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0011101010: begin
                decoded = 8'hbc;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0011101011: begin
                decoded = 8'h1c;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011101100: begin
                decoded = 8'h7c;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0011101101: begin
                decoded = 8'h9c;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011101110: begin
                decoded = 8'hfc;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011110010: begin
                decoded = 8'h9c;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0011110011: begin
                decoded = 8'h7c;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011110100: begin
                decoded = 8'h1c;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0011110101: begin
                decoded = 8'h5c;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011110110: begin
                decoded = 8'hdc;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011111000: begin
                decoded = 8'hfc;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0011111001: begin
                decoded = 8'h3c;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0011111010: begin
                decoded = 8'hbc;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0100010101: begin
                decoded = 8'h5d;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100010110: begin
                decoded = 8'hdd;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100010111: begin
                decoded = 8'hfd;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0100011001: begin
                decoded = 8'h3d;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100011010: begin
                decoded = 8'hbd;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100011011: begin
                decoded = 8'h1d;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0100011100: begin
                decoded = 8'h7d;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100011101: begin
                decoded = 8'h9d;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0100011110: begin
                decoded = 8'hfd;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0100100101: begin
                decoded = 8'h42;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100100110: begin
                decoded = 8'hc2;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100101001: begin
                decoded = 8'h22;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100101010: begin
                decoded = 8'ha2;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100101011: begin
                decoded = 8'h02;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0100101100: begin
                decoded = 8'h62;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100101101: begin
                decoded = 8'h82;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0100101110: begin
                decoded = 8'he2;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0100110001: begin
                decoded = 8'hf2;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100110010: begin
                decoded = 8'h92;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100110011: begin
                decoded = 8'h72;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0100110100: begin
                decoded = 8'h12;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0100110101: begin
                decoded = 8'h52;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0100110110: begin
                decoded = 8'hd2;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0100110111: begin
                decoded = 8'hf2;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0100111001: begin
                decoded = 8'h32;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0100111010: begin
                decoded = 8'hb2;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0100111011: begin
                decoded = 8'h12;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0100111100: begin
                decoded = 8'h72;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0100111101: begin
                decoded = 8'h92;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101000101: begin
                decoded = 8'h5f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101000110: begin
                decoded = 8'hdf;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101001001: begin
                decoded = 8'h3f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101001010: begin
                decoded = 8'hbf;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101001011: begin
                decoded = 8'h1f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0101001100: begin
                decoded = 8'h7f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101001101: begin
                decoded = 8'h9f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0101001110: begin
                decoded = 8'hff;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0101010001: begin
                decoded = 8'hea;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101010010: begin
                decoded = 8'h8a;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101010011: begin
                decoded = 8'h6a;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0101010100: begin
                decoded = 8'h0a;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101010101: begin
                decoded = 8'h4a;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0101010110: begin
                decoded = 8'hca;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0101011001: begin
                decoded = 8'h2a;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0101011010: begin
                decoded = 8'haa;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0101011011: begin
                decoded = 8'h0a;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101011100: begin
                decoded = 8'h6a;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0101011101: begin
                decoded = 8'h8a;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101011110: begin
                decoded = 8'hea;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101100001: begin
                decoded = 8'hfa;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101100010: begin
                decoded = 8'h9a;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101100011: begin
                decoded = 8'h7a;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0101100100: begin
                decoded = 8'h1a;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0101100101: begin
                decoded = 8'h5a;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0101100110: begin
                decoded = 8'hda;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0101101001: begin
                decoded = 8'h3a;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0101101010: begin
                decoded = 8'hba;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0101101011: begin
                decoded = 8'h1a;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101101100: begin
                decoded = 8'h7a;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0101101101: begin
                decoded = 8'h9a;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101101110: begin
                decoded = 8'hfa;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101110001: begin
                decoded = 8'hef;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0101110010: begin
                decoded = 8'h8f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0101110011: begin
                decoded = 8'h6f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101110100: begin
                decoded = 8'h0f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0101110101: begin
                decoded = 8'h4f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101110110: begin
                decoded = 8'hcf;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101111001: begin
                decoded = 8'h2f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0101111010: begin
                decoded = 8'haf;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110000101: begin
                decoded = 8'h40;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110000110: begin
                decoded = 8'hc0;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110001001: begin
                decoded = 8'h20;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110001010: begin
                decoded = 8'ha0;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110001011: begin
                decoded = 8'h00;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0110001100: begin
                decoded = 8'h60;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110001101: begin
                decoded = 8'h80;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0110001110: begin
                decoded = 8'he0;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0110010001: begin
                decoded = 8'he6;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110010010: begin
                decoded = 8'h86;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110010011: begin
                decoded = 8'h66;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0110010100: begin
                decoded = 8'h06;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110010101: begin
                decoded = 8'h46;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0110010110: begin
                decoded = 8'hc6;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0110011001: begin
                decoded = 8'h26;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0110011010: begin
                decoded = 8'ha6;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0110011011: begin
                decoded = 8'h06;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110011100: begin
                decoded = 8'h66;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0110011101: begin
                decoded = 8'h86;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110011110: begin
                decoded = 8'he6;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110100001: begin
                decoded = 8'hf6;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110100010: begin
                decoded = 8'h96;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110100011: begin
                decoded = 8'h76;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0110100100: begin
                decoded = 8'h16;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0110100101: begin
                decoded = 8'h56;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0110100110: begin
                decoded = 8'hd6;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0110101001: begin
                decoded = 8'h36;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0110101010: begin
                decoded = 8'hb6;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0110101011: begin
                decoded = 8'h16;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110101100: begin
                decoded = 8'h76;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0110101101: begin
                decoded = 8'h96;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110101110: begin
                decoded = 8'hf6;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110110001: begin
                decoded = 8'hf0;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0110110010: begin
                decoded = 8'h90;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0110110011: begin
                decoded = 8'h70;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110110100: begin
                decoded = 8'h10;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0110110101: begin
                decoded = 8'h50;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110110110: begin
                decoded = 8'hd0;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110111001: begin
                decoded = 8'h30;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0110111010: begin
                decoded = 8'hb0;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111000010: begin
                decoded = 8'h8e;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0111000011: begin
                decoded = 8'h6e;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b0111000100: begin
                decoded = 8'h0e;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0111000101: begin
                decoded = 8'h4e;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0111000110: begin
                decoded = 8'hce;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0111001000: begin
                decoded = 8'hee;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b0111001001: begin
                decoded = 8'h2e;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0111001010: begin
                decoded = 8'hae;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b0111001011: begin
                decoded = 8'h0e;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111001100: begin
                decoded = 8'h6e;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0111001101: begin
                decoded = 8'h8e;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111001110: begin
                decoded = 8'hee;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111010001: begin
                decoded = 8'he1;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0111010010: begin
                decoded = 8'h81;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0111010011: begin
                decoded = 8'h61;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111010100: begin
                decoded = 8'h01;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0111010101: begin
                decoded = 8'h41;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111010110: begin
                decoded = 8'hc1;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111011001: begin
                decoded = 8'h21;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111011010: begin
                decoded = 8'ha1;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111100001: begin
                decoded = 8'hfe;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0111100010: begin
                decoded = 8'h9e;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0111100011: begin
                decoded = 8'h7e;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111100100: begin
                decoded = 8'h1e;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0111100101: begin
                decoded = 8'h5e;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111100110: begin
                decoded = 8'hde;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111101000: begin
                decoded = 8'hfe;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b0111101001: begin
                decoded = 8'h3e;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b0111101010: begin
                decoded = 8'hbe;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1000010101: begin
                decoded = 8'h5e;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000010110: begin
                decoded = 8'hde;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000010111: begin
                decoded = 8'hfe;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1000011001: begin
                decoded = 8'h3e;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000011010: begin
                decoded = 8'hbe;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000011011: begin
                decoded = 8'h1e;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1000011100: begin
                decoded = 8'h7e;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000011101: begin
                decoded = 8'h9e;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1000011110: begin
                decoded = 8'hfe;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1000100101: begin
                decoded = 8'h41;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000100110: begin
                decoded = 8'hc1;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000101001: begin
                decoded = 8'h21;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000101010: begin
                decoded = 8'ha1;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000101011: begin
                decoded = 8'h01;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1000101100: begin
                decoded = 8'h61;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000101101: begin
                decoded = 8'h81;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1000101110: begin
                decoded = 8'he1;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1000110001: begin
                decoded = 8'hf1;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000110010: begin
                decoded = 8'h91;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000110011: begin
                decoded = 8'h71;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1000110100: begin
                decoded = 8'h11;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1000110101: begin
                decoded = 8'h51;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1000110110: begin
                decoded = 8'hd1;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1000110111: begin
                decoded = 8'hf1;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1000111001: begin
                decoded = 8'h31;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1000111010: begin
                decoded = 8'hb1;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1000111011: begin
                decoded = 8'h11;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1000111100: begin
                decoded = 8'h71;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1000111101: begin
                decoded = 8'h91;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001000101: begin
                decoded = 8'h50;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001000110: begin
                decoded = 8'hd0;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001001001: begin
                decoded = 8'h30;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001001010: begin
                decoded = 8'hb0;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001001011: begin
                decoded = 8'h10;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1001001100: begin
                decoded = 8'h70;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001001101: begin
                decoded = 8'h90;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1001001110: begin
                decoded = 8'hf0;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1001010001: begin
                decoded = 8'he9;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001010010: begin
                decoded = 8'h89;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001010011: begin
                decoded = 8'h69;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1001010100: begin
                decoded = 8'h09;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001010101: begin
                decoded = 8'h49;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1001010110: begin
                decoded = 8'hc9;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1001011001: begin
                decoded = 8'h29;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1001011010: begin
                decoded = 8'ha9;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1001011011: begin
                decoded = 8'h09;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001011100: begin
                decoded = 8'h69;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1001011101: begin
                decoded = 8'h89;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001011110: begin
                decoded = 8'he9;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001100001: begin
                decoded = 8'hf9;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001100010: begin
                decoded = 8'h99;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001100011: begin
                decoded = 8'h79;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1001100100: begin
                decoded = 8'h19;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1001100101: begin
                decoded = 8'h59;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1001100110: begin
                decoded = 8'hd9;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1001101001: begin
                decoded = 8'h39;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1001101010: begin
                decoded = 8'hb9;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1001101011: begin
                decoded = 8'h19;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001101100: begin
                decoded = 8'h79;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1001101101: begin
                decoded = 8'h99;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001101110: begin
                decoded = 8'hf9;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001110001: begin
                decoded = 8'he0;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1001110010: begin
                decoded = 8'h80;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1001110011: begin
                decoded = 8'h60;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001110100: begin
                decoded = 8'h00;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1001110101: begin
                decoded = 8'h40;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001110110: begin
                decoded = 8'hc0;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001111001: begin
                decoded = 8'h20;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1001111010: begin
                decoded = 8'ha0;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010000101: begin
                decoded = 8'h4f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010000110: begin
                decoded = 8'hcf;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010001001: begin
                decoded = 8'h2f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010001010: begin
                decoded = 8'haf;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010001011: begin
                decoded = 8'h0f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1010001100: begin
                decoded = 8'h6f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010001101: begin
                decoded = 8'h8f;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1010001110: begin
                decoded = 8'hef;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1010010001: begin
                decoded = 8'he5;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010010010: begin
                decoded = 8'h85;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010010011: begin
                decoded = 8'h65;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1010010100: begin
                decoded = 8'h05;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010010101: begin
                decoded = 8'h45;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1010010110: begin
                decoded = 8'hc5;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1010011001: begin
                decoded = 8'h25;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1010011010: begin
                decoded = 8'ha5;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1010011011: begin
                decoded = 8'h05;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010011100: begin
                decoded = 8'h65;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1010011101: begin
                decoded = 8'h85;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010011110: begin
                decoded = 8'he5;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010100001: begin
                decoded = 8'hf5;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010100010: begin
                decoded = 8'h95;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010100011: begin
                decoded = 8'h75;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1010100100: begin
                decoded = 8'h15;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1010100101: begin
                decoded = 8'h55;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1010100110: begin
                decoded = 8'hd5;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1010101001: begin
                decoded = 8'h35;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1010101010: begin
                decoded = 8'hb5;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1010101011: begin
                decoded = 8'h15;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010101100: begin
                decoded = 8'h75;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1010101101: begin
                decoded = 8'h95;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010101110: begin
                decoded = 8'hf5;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010110001: begin
                decoded = 8'hff;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1010110010: begin
                decoded = 8'h9f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1010110011: begin
                decoded = 8'h7f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010110100: begin
                decoded = 8'h1f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1010110101: begin
                decoded = 8'h5f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010110110: begin
                decoded = 8'hdf;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010111001: begin
                decoded = 8'h3f;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1010111010: begin
                decoded = 8'hbf;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011000010: begin
                decoded = 8'h8d;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1011000011: begin
                decoded = 8'h6d;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1011000100: begin
                decoded = 8'h0d;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1011000101: begin
                decoded = 8'h4d;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1011000110: begin
                decoded = 8'hcd;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1011001000: begin
                decoded = 8'hed;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1011001001: begin
                decoded = 8'h2d;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1011001010: begin
                decoded = 8'had;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1011001011: begin
                decoded = 8'h0d;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011001100: begin
                decoded = 8'h6d;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1011001101: begin
                decoded = 8'h8d;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011001110: begin
                decoded = 8'hed;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011010001: begin
                decoded = 8'he2;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1011010010: begin
                decoded = 8'h82;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1011010011: begin
                decoded = 8'h62;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011010100: begin
                decoded = 8'h02;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1011010101: begin
                decoded = 8'h42;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011010110: begin
                decoded = 8'hc2;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011011001: begin
                decoded = 8'h22;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011011010: begin
                decoded = 8'ha2;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011100001: begin
                decoded = 8'hfd;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1011100010: begin
                decoded = 8'h9d;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1011100011: begin
                decoded = 8'h7d;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011100100: begin
                decoded = 8'h1d;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1011100101: begin
                decoded = 8'h5d;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011100110: begin
                decoded = 8'hdd;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011101000: begin
                decoded = 8'hfd;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1011101001: begin
                decoded = 8'h3d;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1011101010: begin
                decoded = 8'hbd;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100000101: begin
                decoded = 8'hbc;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100000110: begin
                decoded = 8'h3c;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100000111: begin
                decoded = 8'hfc;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1100001001: begin
                decoded = 8'hdc;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100001010: begin
                decoded = 8'h5c;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100001011: begin
                decoded = 8'h1c;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1100001100: begin
                decoded = 8'h7c;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100001101: begin
                decoded = 8'h9c;
                control = 1'b1;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1100010001: begin
                decoded = 8'he3;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100010010: begin
                decoded = 8'h83;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100010011: begin
                decoded = 8'h63;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1100010100: begin
                decoded = 8'h03;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100010101: begin
                decoded = 8'h43;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1100010110: begin
                decoded = 8'hc3;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1100011001: begin
                decoded = 8'h23;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1100011010: begin
                decoded = 8'ha3;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1100011011: begin
                decoded = 8'h03;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100011100: begin
                decoded = 8'h63;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1100011101: begin
                decoded = 8'h83;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100011110: begin
                decoded = 8'he3;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100100001: begin
                decoded = 8'hf3;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100100010: begin
                decoded = 8'h93;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100100011: begin
                decoded = 8'h73;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1100100100: begin
                decoded = 8'h13;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1100100101: begin
                decoded = 8'h53;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1100100110: begin
                decoded = 8'hd3;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1100101001: begin
                decoded = 8'h33;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1100101010: begin
                decoded = 8'hb3;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1100101011: begin
                decoded = 8'h13;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100101100: begin
                decoded = 8'h73;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1100101101: begin
                decoded = 8'h93;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100101110: begin
                decoded = 8'hf3;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100110001: begin
                decoded = 8'hf8;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1100110010: begin
                decoded = 8'h98;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1100110011: begin
                decoded = 8'h78;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100110100: begin
                decoded = 8'h18;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1100110101: begin
                decoded = 8'h58;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100110110: begin
                decoded = 8'hd8;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100111001: begin
                decoded = 8'h38;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1100111010: begin
                decoded = 8'hb8;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101000010: begin
                decoded = 8'h8b;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1101000011: begin
                decoded = 8'h6b;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b10;
            end
            10'b1101000100: begin
                decoded = 8'h0b;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1101000101: begin
                decoded = 8'h4b;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1101000110: begin
                decoded = 8'hcb;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1101001000: begin
                decoded = 8'heb;
                control = 1'b0;
                allowed = 2'b10;
                next_rd = 2'b00;
            end
            10'b1101001001: begin
                decoded = 8'h2b;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1101001010: begin
                decoded = 8'hab;
                control = 1'b0;
                allowed = 2'b11;
                next_rd = 2'b10;
            end
            10'b1101001011: begin
                decoded = 8'h0b;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101001100: begin
                decoded = 8'h6b;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1101001101: begin
                decoded = 8'h8b;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101001110: begin
                decoded = 8'heb;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101010001: begin
                decoded = 8'he4;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1101010010: begin
                decoded = 8'h84;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1101010011: begin
                decoded = 8'h64;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101010100: begin
                decoded = 8'h04;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1101010101: begin
                decoded = 8'h44;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101010110: begin
                decoded = 8'hc4;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101011001: begin
                decoded = 8'h24;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101011010: begin
                decoded = 8'ha4;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101100001: begin
                decoded = 8'hfb;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1101100010: begin
                decoded = 8'h9b;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1101100011: begin
                decoded = 8'h7b;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101100100: begin
                decoded = 8'h1b;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1101100101: begin
                decoded = 8'h5b;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101100110: begin
                decoded = 8'hdb;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101101000: begin
                decoded = 8'hfb;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1101101001: begin
                decoded = 8'h3b;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1101101010: begin
                decoded = 8'hbb;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110000101: begin
                decoded = 8'h47;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110000110: begin
                decoded = 8'hc7;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110001001: begin
                decoded = 8'h27;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110001010: begin
                decoded = 8'ha7;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110001011: begin
                decoded = 8'h07;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110001100: begin
                decoded = 8'h67;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110001101: begin
                decoded = 8'h87;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110001110: begin
                decoded = 8'he7;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110010001: begin
                decoded = 8'he8;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110010010: begin
                decoded = 8'h88;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110010011: begin
                decoded = 8'h68;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110010100: begin
                decoded = 8'h08;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110010101: begin
                decoded = 8'h48;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110010110: begin
                decoded = 8'hc8;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110011001: begin
                decoded = 8'h28;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110011010: begin
                decoded = 8'ha8;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110100001: begin
                decoded = 8'hf7;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110100010: begin
                decoded = 8'h97;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110100011: begin
                decoded = 8'h77;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110100100: begin
                decoded = 8'h17;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110100101: begin
                decoded = 8'h57;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110100110: begin
                decoded = 8'hd7;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110101000: begin
                decoded = 8'hf7;
                control = 1'b1;
                allowed = 2'b01;
                next_rd = 2'b00;
            end
            10'b1110101001: begin
                decoded = 8'h37;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            10'b1110101010: begin
                decoded = 8'hb7;
                control = 1'b0;
                allowed = 2'b01;
                next_rd = 2'b01;
            end
            default: found = 0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            k_out <= 0;
            valid_out <= 0;
            code_error <= 0;
            disparity_error <= 0;
            running_disparity <= 0;
        end else begin
            valid_out <= valid_in;
            code_error <= valid_in && !found;
            disparity_error <= valid_in && found && !allowed[running_disparity];
            if (valid_in) begin
                data_out <= decoded;
                k_out <= control;
                if (found) begin
                    if (allowed[running_disparity]) running_disparity <= next_rd[running_disparity];
                    else running_disparity <= next_rd[!running_disparity];
                end
            end
        end
    end
endmodule
