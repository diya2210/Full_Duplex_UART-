// UART Receiver
// ==========================

module uart_rx #(
    parameter CLK_PER_BIT = 434
)(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_valid = 0
);

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg [1:0] state = IDLE;
    reg [15:0] clk_cnt = 0;
    reg [2:0] bit_idx = 0;
    reg [7:0] data_buf;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            clk_cnt <= 0;
            bit_idx <= 0;
            data_valid <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    data_valid <= 0;
                    if (rx == 0) begin  // Start bit detected
                        state <= START;
                        clk_cnt <= 0;
                    end
                end
                START: begin
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        state <= DATA;
                        bit_idx <= 0;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
                DATA: begin
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        data_buf[bit_idx] <= rx;
                        if (bit_idx == 7)
                            state <= STOP;
                        else
                            bit_idx <= bit_idx + 1;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
                STOP: begin
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        data_out <= data_buf;
                        data_valid <= 1;
                        state <= IDLE;
                        clk_cnt <= 0;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end
            endcase
        end
    end
endmodule
