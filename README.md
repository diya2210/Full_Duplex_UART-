# Full_Duplex_UART-
📡 Full-Duplex UART in Verilog



This project implements a simple UART (Universal Asynchronous Receiver/Transmitter) in Verilog, including a transmitter, receiver, and baud rate generator. A self-checking testbench is also included to validate the functionality of the UART through loopback testing. It is ideal for understanding serial communication design at the RTL level.

## 📁 Project Structure
├── transmitter.v # UART Transmitter module
├── receiver.v # UART Receiver module
├── baud_rate_gen.v # Baud rate generator module
├── uart.v # Top-level UART module connecting TX, RX, and baud logic
├── uart_tx_test.v # Testbench for simulating and verifying UART functionality
└── uart_waveform.vcd # (Generated) Waveform file for visualization
---

## 🚀 Features

- UART Transmitter and Receiver supporting 8N1 format (8 data bits, no parity, 1 stop bit)
- Baud rate generator supporting 115200 baud with a 50 MHz clock
- Loopback testbench that verifies transmission and reception of bytes from `0x00` to `0xFF`
- Generates a VCD waveform for visualization

---

📋 Description
# UART Transmitter
Waits for wr_en signal.

Sends a start bit (0), followed by 8 data bits, then a stop bit (1).

Indicates busy status via tx_busy.

# UART Receiver
Detects the falling edge of a start bit.

Samples data bits in the middle of each bit period.

Sets rdy when a byte is fully received.

# Baud Rate Generator
Generates txclk_en and rxclk_en enable pulses for transmitter and receiver.

Configured for 115200 baud with a 50 MHz system clock.

# Testbench
Loops back tx to rx.

Automatically transmits all bytes from 0x00 to 0xFF.

Verifies if received data matches transmitted data.

Prints SUCCESS if all bytes match; FAIL otherwise.

