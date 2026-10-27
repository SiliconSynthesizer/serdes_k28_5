`timescale 1ns/1ps
// Accept iff ready && valid_in at rising edge. First bit appears after that edge.
// ready goes high during the last bit, allowing gap-free next-word loading.
module tx_serializer (
    input clk,
    input rst_n,
    input [9:0] data_in,
    input valid_in,
    output reg serial_out,
    output reg ready,
    output reg busy
);
    reg [9:0] shift;
    reg [3:0] remaining;

    always @(*) begin
        ready = (remaining == 0);
        busy = (remaining != 0);
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift <= 0;
            remaining <= 0;
            serial_out <= 0;
        end else if (remaining == 0) begin
            if (valid_in) begin
                serial_out <= data_in[9];
                shift <= {data_in[8:0], 1'b0};
                remaining <= 9;
            end
        end else begin
            serial_out <= shift[9];
            shift <= {shift[8:0], 1'b0};
            remaining <= remaining - 1'b1;
        end
    end
endmodule
