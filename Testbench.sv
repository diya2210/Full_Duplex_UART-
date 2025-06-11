// Testbench for UART
// ==========================

module uart_tx_test();
reg [7:0] data = 0;          // Transmit data, starts from 0 and increments
reg clk = 0;                 // System clock (50 MHz simulated)
reg enable = 0;              // Write enable signal

wire tx_busy;                // UART transmitter busy status
wire rdy;                    // Receiver ready signal
wire [7:0] rxdata;           // Data received by UART
wire loopback;               // Wire connecting TX to RX (internal loopback)
reg rdy_clr = 0;             // Signal to clear rdy flag after receiving data
uart test_uart(
    .din(data),              // Data input
    .wr_en(enable),          // Write enable
    .clk_50m(clk),           // System clock
    .tx(loopback),           // TX connected to loopback
    .tx_busy(tx_busy),       // TX busy status
    .rx(loopback),           // RX connected to loopback
    .rdy(rdy),               // Receiver ready flag
    .rdy_clr(rdy_clr),       // Clear ready signal
    .dout(rxdata)            // Output received data
);
initial begin
    $dumpfile("uart_waveform.vcd");    // VCD file for waveform viewing
    $dumpvars(0, uart_tx_test);        // Dump all variables in scope
    enable <= 1'b1;                    // Start transmission of first byte
    #2 enable <= 1'b0;                 // Deassert write enable after 2 time units
end
always begin
    #1 clk = ~clk;                     // Toggle clock every 1 time unit (simulating 500 MHz for fast simulation)
end
always @(posedge rdy) begin           // When receiver indicates data is ready
    #2 rdy_clr <= 1;                  // Clear the ready flag (acknowledge reception)
    #2 rdy_clr <= 0;                  // Release the clear signal

    if (rxdata != data) begin         // Check if received data matches sent data
        $display("FAIL: rx data %x does not match tx %x", rxdata, data);
        $finish;                      // End simulation on mismatch
    end else begin
        if (rxdata == 8'hff) begin    // If last byte (0xFF) received
            $display("SUCCESS: all bytes verified");
            $finish;                  // End simulation successfully
        end
        data <= data + 1'b1;          // Increment data for next transmission
        enable <= 1'b1;               // Enable new transmission
        #2 enable <= 1'b0;            // Deassert write enable
    end
end
endmodule
