// Full-Duplex UART Module
// ==========================

module uart(
    input wire [7:0] din,        // Input data to transmit
    input wire wr_en,            // Write enable
    input wire clk_50m,          // 50 MHz clock
    output wire tx,              // UART transmit line
    output wire tx_busy,         // Transmitter busy flag

    input wire rx,               // UART receive line
    input wire rdy_clr,          // Clear receive ready
    output wire rdy,             // Receive ready flag
    output wire [7:0] dout       // Received data output
);
wire rxclk_en, txclk_en;        // Baud clock enables for RX and TX
// Baud rate generator instance
baud_rate_gen uart_baud(
    .clk_50m(clk_50m),
    .rxclk_en(rxclk_en),
    .txclk_en(txclk_en)
);
// UART transmitter instance
transmitter uart_tx(
    .tx(tx),
    .din(din),
    .clk_50m(clk_50m),
    .clken(txclk_en),
    .wr_en(wr_en),
    .tx_busy(tx_busy)
);
// UART receiver instance
receiver uart_rx(
    .rx(rx),
    .data(dout),
    .clk_50m(clk_50m),
    .clken(rxclk_en),
    .rdy(rdy),
    .rdy_clr(rdy_clr)
);

endmodule
module baud_rate_gen(input wire clk_50m,
    output wire rxclk_en,       // Enable signal for receiver
    output wire txclk_en        // Enable signal for transmitter
);
// Parameters for baud rate generation
parameter RX_ACC_MAX = 50000000 / (115200 * 16); // 16x oversampling for RX
parameter TX_ACC_MAX = 50000000 / 115200;        // Normal baud clock for TX

// Compute required width of accumulator
parameter RX_ACC_WIDTH = $clog2(RX_ACC_MAX);
parameter TX_ACC_WIDTH = $clog2(TX_ACC_MAX);
reg [RX_ACC_WIDTH - 1:0] rx_acc = 0; // RX clock divider counter
reg [TX_ACC_WIDTH - 1:0] tx_acc = 0; // TX clock divider counter
assign rxclk_en = (rx_acc == 5'd0); // RX enable when counter resets
assign txclk_en = (tx_acc == 9'd0); // TX enable when counter resets
// RX baud clock generator (16x faster for oversampling)
always @(posedge clk_50m) begin
    if (rx_acc == RX_ACC_MAX[RX_ACC_WIDTH - 1:0])
        rx_acc <= 0;
    else
        rx_acc <= rx_acc + 5'b1;
end

// TX baud clock generator
always @(posedge clk_50m) begin
    if (tx_acc == TX_ACC_MAX[TX_ACC_WIDTH - 1:0])
        tx_acc <= 0;
    else
        tx_acc <= tx_acc + 9'b1;
end

endmodule
