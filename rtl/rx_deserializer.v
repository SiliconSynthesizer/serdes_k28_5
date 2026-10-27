`timescale 1ns/1ps
module rx_deserializer (
    input clk,
    input rst_n,
    input serial_in,
    input bit_valid,
    output reg [9:0] raw_data,
    output reg raw_valid
);
    reg [9:0] shift;
    reg [3:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift <= 0;
            count <= 0;
            raw_data <= 0;
            raw_valid <= 0;
        end else begin
            raw_valid <= 0;
            if (bit_valid) begin
                shift <= {shift[8:0], serial_in};
                if (count == 9) begin
                    raw_data <= {shift[8:0], serial_in};
                    raw_valid <= 1;
                    count <= 0;
                end else count <= count + 1'b1;
            end
        end
    end
endmodule
