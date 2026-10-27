`timescale 1ns/1ps
module tb_serdes_loopback;
    reg clk = 0;

    always #5 clk = ~clk;
    reg rst_n = 0;
    reg [7:0] tx_data = 0;
    reg tx_k = 0, tx_valid = 0, force_realign = 0;
    wire tx_ready, serial_tx, bit_active;
    reg [9:0] delay_line = 0;
    integer phase = 0;
    reg corrupt = 0;
    wire serial_rx = corrupt ? 1'b0 :((phase == 0) ? serial_tx : delay_line[phase - 1]);
    wire [7:0] rx_data;
    wire rx_k, rx_valid, comma, locked, ce, de, invalid_k;
    wire [3:0] offset;
    serdes_top dut (
        .clk              (clk),
        .rst_n            (rst_n),
        .tx_data          (tx_data),
        .tx_k             (tx_k),
        .tx_valid         (tx_valid),
        .tx_ready         (tx_ready),
        .serial_tx        (serial_tx),
        .serial_rx        (serial_rx),
        .rx_bit_valid     (1'b1),
        .force_realign    (force_realign),
        .rx_data          (rx_data),
        .rx_k             (rx_k),
        .rx_valid         (rx_valid),
        .comma_detected   (comma),
        .alignment_offset (offset),
        .symbol_locked    (locked),
        .code_error       (ce),
        .disparity_error  (de),
        .tx_invalid_k     (invalid_k),
        .serial_tx_valid  (bit_active)
    );

    always @(posedge clk) delay_line <= {delay_line[8:0], serial_tx};
    reg [8:0] queue[0:4095];
    integer wr = 0, rd = 0, total = 0, p, i, seed = 12345;
    reg checking = 0, started = 0;
    integer error_seen = 0, lost_seen = 0, acquired_seen = 0;
    reg continuous_check = 0;
    integer last_launch = 0, cycles = 0;

    always @(posedge clk) begin
        cycles = cycles + 1;
        if (rst_n && dut.buffer_valid && dut.serializer_ready) begin
            if (continuous_check && last_launch != 0 && cycles - last_launch != 10) $fatal(1, "TX stream gap: %0d cycles", cycles - last_launch);
            last_launch = cycles;
        end
        #2;
        if (rst_n) begin
            if (ce || de) error_seen = error_seen + 1;
            if (dut.lock_lost) lost_seen = lost_seen + 1;
            if (dut.lock_acquired) acquired_seen = acquired_seen + 1;
            if (checking && rx_valid) begin
                if (!started && {rx_k, rx_data} == 9'h1f7) started = 1;
                if (started && rd < wr) begin
                    if (ce || de || {rx_k, rx_data} !== queue[rd]) $fatal(1, "scoreboard phase%0d index%0d got K%b %h expected %h ce%b de%b", p, rd, rx_k, rx_data, queue[rd], ce, de);
                    rd = rd + 1;
                    total = total + 1;
                end
            end
        end
    end
    task send;
        input [7:0] data;
        input control;
        input score;
        begin
            @(negedge clk);
            while (!tx_ready) @(negedge clk);
            tx_data = data;
            tx_k = control;
            tx_valid = 1;
            if (score) begin
                queue[wr] = {control, data};
                wr = wr + 1;
            end
            @(negedge clk);
            tx_valid = 0;
        end
    endtask
    task drain;
        begin
            repeat (8) send(8'hbc, 1, 0);
            if (rd != wr || !started) $fatal(1, "missing payload %0d/%0d phase%0d", rd, wr, p);
            checking = 0;
        end
    endtask

    initial begin
        $dumpfile("build/tb_serdes_loopback.vcd");
        $dumpvars(0, tb_serdes_loopback);
        for (p = 0; p < 10; p = p + 1) begin
            @(negedge clk);
            rst_n = 0;
            tx_valid = 0;
            corrupt = 0;
            phase = p;
            checking = 0;
            continuous_check = 0;
            wr = 0;
            rd = 0;
            started = 0;
            last_launch = 0;
            error_seen = 0;
            lost_seen = 0;
            acquired_seen = 0;
            repeat (3) @(negedge clk);
            rst_n = 1;
            repeat (30) send(8'hbc, 1, 0);
            if (!locked) $fatal(1, "initial lock phase%0d", p);
            continuous_check = 1;
            checking = 1;
            send(8'hf7, 1, 1);
            for (i = 0; i < 256; i = i + 1) send(i[7:0], 0, 1);
            for (i = 0; i < 200; i = i + 1) send($random(seed), 0, 1);
            send(8'h1c, 1, 1);
            send(8'h3c, 1, 1);
            send(8'h5c, 1, 1);
            send(8'h7c, 1, 1);
            send(8'h9c, 1, 1);
            send(8'hbc, 1, 1);
            send(8'hdc, 1, 1);
            send(8'hfc, 1, 1);
            send(8'hfb, 1, 1);
            send(8'hfd, 1, 1);
            send(8'hfe, 1, 1);
            repeat (8) send(8'hbc, 1, 0);
            continuous_check = 0;
            drain;
            if (!locked) $fatal(1, "long payload lost lock");
            $display("[PASS] Loopback phase=%0d: K28.5 training, lock, all 256 bytes, 200 random bytes, mixed K/D, continuous TX and scoreboard", p);
            // Corrupt more than four consecutive symbols and change bit phase.
            error_seen = 0;
            lost_seen = 0;
            acquired_seen = 0;
            fork
                begin
                    @(negedge clk);
                    corrupt = 1;
                    repeat (85) @(negedge clk);
                    phase = (p + 3) % 10;
                    corrupt = 0;
                end
                begin
                    repeat (40) send(8'hbc, 1, 0);
                end
            join
            if (error_seen < 4 || lost_seen < 1 || acquired_seen < 1 || !locked) $fatal(1, "recovery phase%0d errors%0d lost%0d acquired%0d", p, error_seen, lost_seen, acquired_seen);
            $display("[PASS] Loopback phase=%0d: serial corruption detected, lock lost, bit phase changed and lock reacquired", p);
            wr = 0;
            rd = 0;
            started = 0;
            checking = 1;
            send(8'hf7, 1, 1);
            for (i = 0; i < 32; i = i + 1) send(i[7:0] ^ 8'ha5, 0, 1);
            drain;
            $display("[PASS] Loopback phase %0d: payload=%0d recovery_errors=%0d losses=%0d acquisitions=%0d", p, 468 + 33, error_seen, lost_seen, acquired_seen);
        end
        $display("PASS tb_serdes_loopback matched_symbols=%0d phases=10 corruption/rephase/recovery=10", total);
        $finish;
    end

    initial begin
        #2000000;
        $fatal(1, "loopback timeout");
    end
endmodule
