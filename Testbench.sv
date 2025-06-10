// UART Transmitter
// ==========================

module uart_tx #(
    parameter CLK_PER_BIT = 434
)(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] data_in,
    output reg tx = 1'b1,
    output reg busy = 1'b0
);

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0] state = IDLE;
    reg [7:0] data_reg;
    reg [2:0] bit_idx = 0;
    reg [15:0] clk_cnt = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1'b1;
            busy <= 0;
            bit_idx <= 0;
            clk_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    busy <= 0;
                    if (tx_start) begin
                        state <= START;
                        data_reg <= data_in;
                        busy <= 1;
                        clk_cnt <= 0;
                    end
                end
                START: begin
                    tx <= 1'b0;  // Start bit
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        state <= DATA;
                        bit_idx <= 0;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
                DATA: begin
                    tx <= data_reg[bit_idx];
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        if (bit_idx == 7)
                            state <= STOP;
                        else
                            bit_idx <= bit_idx + 1;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
                STOP: begin
                    tx <= 1'b1;  // Stop bit
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        state <= IDLE;
                        busy <= 0;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
            endcase
        end
    end
endmodule
