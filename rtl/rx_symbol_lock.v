`timescale 1ns/1ps
module rx_symbol_lock #(
    parameter VERIFY_SYMBOLS = 4,
    parameter ERROR_LIMIT = 4
) (
    input clk,
    input rst_n,
    input comma_found,
    input [3:0] comma_offset,
    input aligned_valid,
    input code_error,
    input disparity_error,
    input force_realign,
    output reg symbol_locked,
    output reg [3:0] alignment_offset,
    output reg alignment_enable,
    output reg lock_acquired,
    output reg lock_lost
);
    localparam IDLE = 0, SEARCHING = 1, VERIFY = 2, LOCKED = 3, LOST = 4;
    reg [2:0] state;
    integer good_count, error_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            symbol_locked <= 0;
            alignment_offset <= 0;
            alignment_enable <= 0;
            lock_acquired <= 0;
            lock_lost <= 0;
            good_count <= 0;
            error_count <= 0;
        end else begin
            lock_acquired <= 0;
            lock_lost <= 0;
            if (force_realign) begin
                state <= LOST;
                symbol_locked <= 0;
                alignment_enable <= 0;
                lock_lost <= symbol_locked;
            end else
            case (state)
                IDLE: state <= SEARCHING;
                SEARCHING: if (comma_found) begin
                    alignment_offset <= comma_offset;
                    alignment_enable <= 1;
                    good_count <= 0;
                    state <= VERIFY;
                end
                VERIFY: if (aligned_valid) begin
                    if (code_error || disparity_error) begin
                        state <= SEARCHING;
                        alignment_enable <= 0;
                        good_count <= 0;
                    end else if (good_count + 1 >= VERIFY_SYMBOLS) begin
                        state <= LOCKED;
                        symbol_locked <= 1;
                        lock_acquired <= 1;
                        error_count <= 0;
                    end else good_count <= good_count + 1;
                end
                LOCKED: if (aligned_valid) begin
                    if (code_error || disparity_error) begin
                        if (error_count + 1 >= ERROR_LIMIT) begin
                            state <= LOST;
                            symbol_locked <= 0;
                            alignment_enable <= 0;
                            lock_lost <= 1;
                        end else error_count <= error_count + 1;
                    end else error_count <= 0;
                end
                LOST: begin
                    state <= SEARCHING;
                    good_count <= 0;
                    error_count <= 0;
                end
                default: begin
                    state <= IDLE;
                    symbol_locked <= 0;
                    alignment_enable <= 0;
                end
            endcase
        end
    end
endmodule
