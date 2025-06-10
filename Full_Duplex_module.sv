// Full-Duplex UART Module
// ==========================

module uart_full_duplex(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    output wire tx,
    input wire rx,
    output wire [7:0] rx_data,
    output wire rx_data_valid,
    output wire tx_busy
);

    wire tx_line;
    assign tx = tx_line;

    uart_tx #(.CLK_PER_BIT(434)) transmitter (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(tx_data),
        .tx(tx_line),
        .busy(tx_busy)
    );

    uart_rx #(.CLK_PER_BIT(434)) receiver (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(rx_data),
        .data_valid(rx_data_valid)
    );

endmodule



