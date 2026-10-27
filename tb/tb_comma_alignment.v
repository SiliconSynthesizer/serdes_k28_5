`timescale 1ns/1ps
module tb_comma_alignment;
    reg clk = 0;

    always #5 clk = ~clk;
    reg rst_n = 0;

    initial begin
        #2000000;
        $fatal(1, "timeout");
    end
    reg [19:0] window_data = 0;
    reg window_valid = 0;
    wire found, pol;
    wire [3:0] off;
    reg [9:0] raw = 0;
    reg rv = 0, en = 0;
    reg [3:0] alignment = 0;
    wire [9:0] aligned;
    wire av;
    reg cf = 0, sv = 0, ce = 0, de = 0, force_realign = 0;
    reg [3:0] co = 0;
    wire locked, ae, acq, lost;
    wire [3:0] ao;
    k28_5_detector detector (
        .window_data    (window_data),
        .window_valid   (window_valid),
        .comma_found    (found),
        .comma_offset   (off),
        .comma_polarity (pol)
    );
    rx_word_aligner aligner (
        .clk              (clk),
        .rst_n            (rst_n),
        .raw_data         (raw),
        .raw_valid        (rv),
        .alignment_offset (alignment),
        .alignment_enable (en),
        .aligned_data     (aligned),
        .aligned_valid    (av)
    );
    rx_symbol_lock controller (
        .clk              (clk),
        .rst_n            (rst_n),
        .comma_found      (cf),
        .comma_offset     (co),
        .aligned_valid    (sv),
        .code_error       (ce),
        .disparity_error  (de),
        .force_realign    (force_realign),
        .symbol_locked    (locked),
        .alignment_offset (ao),
        .alignment_enable (ae),
        .lock_acquired    (acq),
        .lock_lost        (lost)
    );
    // Additional unit checks exercise bit-valid pauses and nondefault thresholds.
    reg serial_bit = 0, bit_valid = 0;
    wire [9:0] collected;
    wire collected_valid;
    rx_deserializer deserializer (
        .clk       (clk),
        .rst_n     (rst_n),
        .serial_in (serial_bit),
        .bit_valid (bit_valid),
        .raw_data  (collected),
        .raw_valid (collected_valid)
    );
    wire short_locked, short_enable, short_acquired, short_lost;
    wire [3:0] short_offset;
    rx_symbol_lock #(.VERIFY_SYMBOLS(3),.ERROR_LIMIT(2)) short_controller (
        .clk              (clk),
        .rst_n            (rst_n),
        .comma_found      (cf),
        .comma_offset     (co),
        .aligned_valid    (sv),
        .code_error       (ce),
        .disparity_error  (de),
        .force_realign    (force_realign),
        .symbol_locked    (short_locked),
        .alignment_offset (short_offset),
        .alignment_enable (short_enable),
        .lock_acquired    (short_acquired),
        .lock_lost        (short_lost)
    );
    integer o, b, n, checks = 0;
    reg [9:0] comma;
    reg [39:0] stream;
    task tick;
        begin
            @(posedge clk);
            #1;
            @(negedge clk);
        end
    endtask
    task reset;
        begin
            rst_n = 0;
            rv = 0;
            en = 0;
            cf = 0;
            sv = 0;
            ce = 0;
            de = 0;
            force_realign = 0;
            tick;
            rst_n = 1;
            tick;
        end
    endtask
    task acquire;
        begin
            cf = 1;
            co = 7;
            tick;
            cf = 0;
            if (controller.state !== 2 || !ae || ao != 7) $fatal(1, "VERIFY");
            sv = 1;
            repeat (3) begin
                tick;
                if (locked) $fatal(1, "premature lock");
            end
            if (!short_locked) $fatal(1, "nondefault verification threshold");
            tick;
            if (!locked || !acq) $fatal(1, "lock threshold");
        end
    endtask

    initial begin
        $dumpfile("build/tb_comma_alignment.vcd");
        $dumpvars(0, tb_comma_alignment);
        @(negedge clk);
        for (o = 0; o < 10; o = o + 1) begin
            for (b = 0; b < 2; b = b + 1) begin
                reset;
                comma = b ? 10'b1100000101 : 10'b0011111010;
                // A comma followed by two distinct complete words, prefixed by offset bits.
                stream = ({comma, 10'b1001110100, 10'b0111011001, 10'b0} >> o);
                window_data = stream[39:20];
                window_valid = 1;
                #1;
                if (!found || off != o || pol != b) $fatal(1, "detector offset%0d polarity%0d got%0d", o, b, off);
                alignment = o;
                en = 1;
                raw = stream[39:30];
                rv = 1;
                tick;
                if (av) $fatal(1, "aligner must prime previous word");
                raw = stream[29:20];
                tick;
                if (!av || aligned !== comma) $fatal(1, "comma reconstruction offset%0d got%b", o, aligned);
                raw = stream[19:10];
                tick;
                if (!av || aligned !== 10'b1001110100) $fatal(1, "payload1 offset%0d got%b", o, aligned);
                raw = stream[9:0];
                tick;
                if (!av || aligned !== 10'b0111011001) $fatal(1, "payload2 offset%0d", o);
                rv = 0;
                tick;
                if (av) $fatal(1, "valid gap");
                $display("[PASS] Comma offset=%0d polarity=%0d: detection, complete cross-word reconstruction and valid timing", o, b);
                checks = checks + 1;
            end
        end
        reset;
        comma = 10'b1001110100;
        for (n = 9; n >= 0; n = n - 1) begin
            bit_valid = 0;
            tick;
            if (collected_valid) $fatal(1, "bit-valid pause");
            serial_bit = comma[n];
            bit_valid = 1;
            tick;
            if (n != 0 && collected_valid) $fatal(1, "early raw word");
        end
        if (!collected_valid || collected !== comma) $fatal(1, "deserializer bit order/pause");
        bit_valid = 0;
        tick;
        if (collected_valid) $fatal(1, "raw valid width");
        $display("[PASS] Deserializer: MSB-first bit order, bit-valid pauses and raw-valid timing");
        window_data = 0;
        #1;
        if (found) $fatal(1, "false comma");
        window_valid = 0;
        window_data = {10'b0011111010, 10'b0};
        #1;
        if (found) $fatal(1, "invalid window");
        $display("[PASS] Comma rejection: no comma and invalid window");
        reset;
        repeat (20) tick;
        if (controller.state !== 1 || locked) $fatal(1, "SEARCHING");
        $display("[PASS] Lock FSM: SEARCHING without a comma");
        acquire;
        $display("[PASS] Lock acquisition: VERIFY and exact default/configurable thresholds");
        repeat (300) begin
            tick;
            if (!locked) $fatal(1, "no-comma payload lost lock");
        end
        $display("[PASS] Lock retention: 300 legal symbols without commas");
        ce = 1;
        tick;
        if (!locked || !short_locked) $fatal(1, "early nondefault loss");
        tick;
        if (!locked || short_locked || !short_lost) $fatal(1, "nondefault loss threshold");
        tick;
        if (!locked) $fatal(1, "early loss");
        ce = 0;
        tick;
        // legal symbol clears consecutive-error count
        de = 1;
        repeat (3) begin
            tick;
            if (!locked) $fatal(1, "early disparity loss");
        end
        tick;
        if (locked || !lost || controller.state !== 4) $fatal(1, "LOST");
        $display("[PASS] Lock loss: consecutive-error counting, legal-symbol streak reset, LOST and configurable threshold");
        de = 0;
        sv = 0;
        tick;
        if (controller.state !== 1) $fatal(1, "automatic search");
        acquire;
        $display("[PASS] Automatic realignment: LOST -> SEARCHING -> VERIFY -> LOCKED");
        force_realign = 1;
        tick;
        if (locked || !lost) $fatal(1, "force realign");
        $display("[PASS] Forced realignment: lock cleared and loss pulse asserted");
        force_realign = 0;
        sv = 0;
        tick;
        acquire;
        reset;
        cf = 1;
        tick;
        cf = 0;
        ce = 1;
        sv = 1;
        tick;
        if (controller.state !== 1 || ae) $fatal(1, "VERIFY rejection");
        $display("[PASS] VERIFY rejects decoding errors");
        reset;
        cf = 1;
        tick;
        reset;
        if (locked || ae || controller.state !== 1) $fatal(1, "reset during verify");
        $display("[PASS] Reset during synchronization clears alignment and lock");
        $display("PASS tb_comma_alignment offsets/polarities=%0d; complete reconstruction; FSM thresholds/recovery/no-comma/reset", checks);
        $finish;
    end
endmodule
