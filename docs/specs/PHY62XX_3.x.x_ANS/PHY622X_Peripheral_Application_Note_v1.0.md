# PHY622X Peripheral Application Note v1.0 (English Summary)

**Applies to:** PHY6220, PHY6250, PHY6222, PHY6252  
**Date:** 2021.01  
**Author:** phyplusinc

---

## Revision History

| Revision | Author      | Date       | Description                  |
|----------|-------------|------------|------------------------------|
| V1.0     | phyplusinc  | 2021.01.25 | Initial release for 6220/6250/6222/6252 |

---

## Table of Contents

1. [WATCHDOG](#1-watchdog)  
2. [TIMER](#2-timer)  
3. [PWM](#3-pwm)  
4. [UART](#4-uart)  
5. [SPI](#5-spi)  
6. [I2C](#6-i2c)  
7. [KSCAN](#7-kscan)  

---

## 1. WATCHDOG

### 1.1 Overview

- The watchdog timer (WATCHDOG) is used to recover the system from unexpected faults, such as code bugs or hardware interference, which may cause the system to hang or enter an infinite loop.
- The watchdog is essentially a timer circuit with an input ("feeding" the dog) and an output (usually connected to a reset pin).
- If the watchdog is not "fed" within a set period, it will reset the system.

### 1.2 Hardware

- WATCHDOG clock: 32.768kHz (can select RC 32k or XTAL 32k).
- Feeding period options: 2s, 4s, 8s, 16s, 32s, 64s, 128s, 256s.
- Can be used in polling or interrupt mode:
  - **Polling:** If not fed in time, system resets.
  - **Interrupt:** If not fed, first triggers a WATCHDOG interrupt; if still not fed, triggers a reset.
- When the system sleeps, WATCHDOG info is lost and must be reconfigured after wakeup.
- 6220/6250 do not support interrupt mode feeding.

### 1.3 Example Code

- See SDK for code examples.

---

## 2. TIMER

### 2.1 Overview

- TIMER provides precise timing for applications.

### 2.2 Hardware

- 6 hardware TIMERs in total; 4 are used by protocol stack/OSAL, 2 are available for applications.
- Clock source: fixed 4MHz, not hardware-dividable; software divides by 4 for convenience.
- 32-bit width (max count: 0xFFFFFFFF).
- Supports interrupt and non-interrupt modes.
- Supports free-running and user-defined count modes.
  - Free-running: reloads 0xFFFFFFFF after reaching 0.
  - User-defined: reloads user-configured value after reaching 0 (used in driver).
- Timer interrupt does not stop timer; must be stopped manually if needed.
- TIMER info is lost during sleep and must be reconfigured after wakeup.

### 2.3 Example Code

- See SDK for code examples.

---

## 3. PWM

### 3.1 Overview

- PWM (Pulse Width Modulation) outputs a series of pulses (square wave).
- Parameters:
  - **Duty cycle:** On time / (On time + Off time)
  - **Frequency:** 1 / (On time + Off time)

### 3.2 Hardware

- 6 PWM channels supported.
- Clock source: 16MHz; each channel supports division by 1, 2, 4, 8, 16, 32, 64, 128.
- PWM info is lost during sleep and must be reconfigured after wakeup.
- All FMUX-capable IOs can be used as PWM.
- Supports UP mode and UP AND DOWN mode:
  - UP mode: duty cycle 0~100% (including 0% and 100%).
  - UP AND DOWN mode: duty cycle (0~100%), but not including 0% and 100% (requires GPIO for 0%/100%).

#### Duty Cycle Calculation

| Mode           | Polarity         | Formula                        |
|----------------|------------------|--------------------------------|
| UP             | Falling          | (CMP_VAL+1)/(TOP_VAL+1)        |
| UP             | Rising           | 1-((CMP_VAL+1)/(TOP_VAL+1))    |
| UP AND DOWN    | Falling/Rising   | CMP_VAL/TOP_VAL or 1-(CMP_VAL/TOP_VAL) |

#### Frequency Calculation

| Mode           | Formula                  |
|----------------|-------------------------|
| UP             | 16/N/(TOP_VAL+1)        |
| UP AND DOWN    | 8/N/TOP_VAL             |

- N: divider (1,2,4,8,16,32,64,128)

#### Notes

- UP mode: frequency 62.5kHz~8MHz, resolution 0 and 2/65536~65536/65536.
- UP AND DOWN mode: frequency 31.25kHz~4MHz, resolution 0/65535~65534/65535.

### 3.3 Example Code

- See SDK for code examples.

---

## 4. UART

### 4.1 Overview

- UART (Universal Asynchronous Receiver/Transmitter) is a serial communication protocol.
- Data is sent asynchronously (no clock signal), using start/stop bits for synchronization.
- Baud rate: bits per second (bps); both sides must use similar baud rates.
- Data packet: 1 start bit, 5-9 data bits, optional parity, 1-2 stop bits.

### 4.2 Hardware

- 2 UARTs supported.
- TX/RX FIFO depth: 16 bytes each.
- PCLK = HCLK, can be divided (not recommended).
- UART info is lost during sleep and must be reconfigured after wakeup.
- All FMUX-capable IOs can be used as UART.
- System log output defaults to UART0 (P9, P10); can be enabled/disabled via DEBUG_INFO.
- Baud rate divisor: divisor = hclk / (16 * baud).
  - If fractional error >2%, baud rate is not supported (e.g., 48MHz, 921600 baud not supported).

### 4.3 Example Code

- See SDK for code examples.

---

## 5. SPI

### 5.1 Overview

- SPI (Serial Peripheral Interface) is a synchronous, full-duplex, master-slave interface.
- Uses 4 lines: SCLK (clock), CS (chip select), MOSI (master out/slave in), MISO (master in/slave out).
- Clock polarity (CPOL) and phase (CPHA) are configurable.

### 5.2 Hardware

- 2 SPI channels, configurable as master or slave.
- TX/RX FIFO depth: 8 (configurable 4-16 bits).
- Clock = HCLK, can be divided (not recommended).
- SPI info is lost during sleep and must be reconfigured after wakeup.
- All FMUX-capable IOs can be used as SPI.
- CS can be controlled automatically or manually (via GPIO).
- Interrupt mode is available.

### 5.3 Supported Rates

- SPI Master: F_ssi_clk >= 2 × (max F_sclk_out)
- SPI Slave (receive only): F_ssi_clk >= 6 × (max F_sclk_in)
- SPI Slave: F_ssi_clk >= 8 × (max F_sclk_in)

### 5.4 Example Code

- See SDK for code examples.

---

## 6. I2C

### 6.1 Overview

- I2C (Inter-Integrated Circuit) is a two-wire serial bus for connecting MCUs and peripherals.
- Supports multi-master and multi-slave configurations.
- Requires pull-up resistors (e.g., 2.2kΩ or 4.7kΩ).

### 6.2 Hardware

- 2 I2C channels, configurable as master or slave.
- TX/RX FIFO depth: 8 bytes each.
- PCLK = HCLK, can be divided (not recommended).
- I2C info is lost during sleep and must be reconfigured after wakeup.
- All FMUX-capable IOs can be used as I2C.

### 6.3 Example Code

- See SDK for code examples.

---

## 7. KSCAN

### 7.1 Overview

- KSCAN (Key Scan) is used for matrix keypads, allowing more keys with fewer IOs.
- M rows × N columns = M×N keys.
- Rows are inputs, columns are outputs.
- When a key is pressed, the corresponding row/column bit is set and an interrupt is triggered.

### 7.2 Hardware

- 11 IOs can be configured as rows, 12 as columns (do not use P16/P17).
- See `kscan.h` for IO and index mapping.
- KSCAN info is lost during sleep and must be reconfigured after wakeup.

### 7.3 Example Code

- See SDK for code examples.

---

## Figures and Tables

- Figure 1: PWM Diagram
- Figure 2: UP MODE, UP AND DOWN MODE
- Table 1: PWM Duty Cycle Calculation
- Table 2: PWM Frequency Calculation
- Figure 3: UART Frame Format
- Figure 4: SPI Diagram
- Figures 5-8: SPI CPOL/CPHA Modes
- Figure 9: I2C Diagram

---

**For detailed register-level programming and code examples, refer to the SDK