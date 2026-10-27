`timescale 1ns/1ps
module rx_word_aligner (
    input clk,
    input rst_n,
    input [9:0] raw_data,
    input raw_valid,
    input [3:0] alignment_offset,
    input alignment_enable,
    output reg [9:0] aligned_data,
    output reg aligned_valid
);
    reg [9:0] previous;
    reg have_previous;
    wire [19:0] window_data = {previous, raw_data};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            previous <= 0;
            have_previous <= 0;
            aligned_data <= 0;
            aligned_valid <= 0;
        end else begin
            aligned_valid <= 0;
            if (raw_valid) begin
                previous <= raw_data;
                have_previous <= 1;
                if (have_previous && alignment_enable && alignment_offset < 10) begin
                    aligned_data <= window_data >> (10 - alignment_offset);
                    aligned_valid <= 1;
                end
            end
        end
    end
endmodule
