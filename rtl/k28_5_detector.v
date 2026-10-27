`timescale 1ns/1ps
// Window={older,newer}. Offset counts bits skipped from older[9].
module k28_5_detector (
    input [19:0] window_data,
    input window_valid,
    output reg comma_found,
    output reg [3:0] comma_offset,
    output reg comma_polarity
);
    integer i;
    reg [9:0] candidate;

    always @(*) begin
        comma_found = 0;
        comma_offset = 0;
        comma_polarity = 0;
        candidate = 0;
        for (i = 0; i < 10; i = i + 1) begin
            candidate = (window_data >> (10 - i));
            if (window_valid && !comma_found && (candidate == 10'b0011111010 || candidate == 10'b1100000101)) begin
                comma_found = 1;
                comma_offset = i;
                comma_polarity = (candidate == 10'b1100000101);
            end
        end
    end
endmodule
