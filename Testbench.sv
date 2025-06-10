// Testbench for UART
// ==========================

module tb_uart;
    reg clk = 0;
    reg rst = 0;
    reg tx_start = 0;
    reg [7:0] tx_data;
    wire tx, rx;
    wire [7:0] rx_data;
    wire rx_data_valid;
    wire tx_busy;

    // Instantiate full-duplex UART
    uart_full_duplex dut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .rx(tx),        // Loopback
        .rx_data(rx_data),
        .rx_data_valid(rx_data_valid),
        .tx_busy(tx_busy)
    );

    // Clock generation
    always #10 clk = ~clk;  // 50 MHz clock

    initial begin
        $dumpfile("uart_waveform.vcd");
        $dumpvars(0, tb_uart);

        $display("Starting UART testbench");
        rst = 1;
        #50;
        rst = 0;

        // Send byte 0x5A
        tx_data = 8'h5A;
        tx_start = 1;
        #20;
        tx_start = 0;

        // Wait for transmission and reception
        wait (rx_data_valid == 1);
        $display("Received byte: %h", rx_data);

        #100;
        $finish;
    end
endmodule
