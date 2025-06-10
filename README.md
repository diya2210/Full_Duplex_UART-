# Full_Duplex_UART-
# 📡 Full-Duplex UART in Verilog

This project implements a **Full-Duplex UART (Universal Asynchronous Receiver/Transmitter)** in **Verilog HDL**, including a fully featured testbench and waveform generation. It is ideal for understanding serial communication design at the RTL level.

---

## 🚀 Features

- ✅ UART Transmitter
- ✅ UART Receiver
- ✅ Full-Duplex communication (Loopback Tested)
- ✅ Configurable baud rate via `CLK_PER_BIT`
- ✅ Testbench with automatic stimulus
- ✅ Waveform dump using `$dumpfile` / `$dumpvars` for GTKWave or EPWave

---

## 🧠 Block Overview
[TX Input] ---> [UART TX] ---> tx_line ---> [UART RX] ---> [RX Output]
                                  ^                          |
                                  |__________________________|
                               (loopback connection in testbench)

