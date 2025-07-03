# PHY6252 Bluetooth 5.4 System on Chip  
**Product Specification v1.3**  
**Copyright © 2024 Phyplus Technologies (Shanghai) Co., Ltd**

---

## Key Features

- High-performance Low-power 32-bit Processor
- **Memory**
  - 512/256KB SPI NOR flash memory
  - 64KB SRAM, all programmable retention in sleep mode
  - 4-way instruction cache with 8KB Cache RAM
  - 96KB ROM
  - 256bit eFuse
- **19 General Purpose I/O Pins**
  - GPIO status retention in off/sleep mode
  - Configurable as serial interface and programmable IO MUX function mapping
  - All pins can be configured for wake-up and interrupt
  - 3 Quadrature Decoder (QDEC)
  - 6-channel PWM
  - 2-channel PDM/I2C/SPI/UART
  - 4-channel DMA
- DMIC/AMIC with microphone bias
- 5-channel 12bit ADC with low noise voice PGA
- 6-channel 32bit timer, one watchdog timer
- Real Timer Counter (RTC)
- Power, Clock, Reset Controller
- Flexible Power management
  - Operating Voltage range 1.8V to 3.6V
  - Battery monitor
- **Power consumption**
  - 0.3uA @ OFF Mode (IO wake up only)
  - 1uA @ Sleep Mode with 32KHz RTC
  - 2.7/3.6/4.6uA @ Sleep Mode with 32KHz RTC and 32/48/64KB SRAM retention
  - Receive mode: 8mA @3.3V power supply
  - Transmit mode: 8.6mA (0dBm output power) @3.3V power supply
  - MCU: <90uA/MHz
- RC Oscillator hardware calibrations
  - Internal High/Low frequency RC osc
  - 32KHz RC osc for RTC with +/-500ppm accuracy
  - 32MHz RC osc for HCLK with 3% accuracy
- **High Speed Throughput**
  - Support BLE 2Mbps Protocol
  - Support Data Length Extension
  - Throughput up to 1.6Mbps (DLE+2Mbps)
- BLE 5.4 Feature
- AoA/AoD Direction Finding
- Support SIG-Mesh Multi-Feature (Friend Node, Low Power Node, Proxy Node, Relay Node)
- **2.4 GHz transceiver**
  - Compliant to Bluetooth 5.4
  - Sensitivity: -99dBm@BLE 1Mbps, -105dBm@BLE 125Kbps
  - TX Power -20 to +10dBm in 3dB steps
  - Single-pin antenna: no RF matching or RX/TX switching required
  - RSSI (1dB resolution)
  - Antenna array and optional off-chip RF PA/LNA control interface
- AES-128 encryption hardware
- Link layer hardware (automatic packet assembly, detection, validation, auto retransmit, auto ACK, hardware address matching, random number generator)
- **Operating temperature:** -40˚C ~+85˚C (Consumer), -40˚C ~+105˚C (Industrial)
- **RoHS Package:** SSOP24/SOP16
- **Applications:** wearables, beacons, home/building, health/medical, industrial/manufacturing, retail/payment, data transmission, PC/mobile/TV peripherals, IoT

---

## Legal & Contact

- **Copyright:** © 2024 Phyplus Technologies (Shanghai) Co., Ltd. All rights reserved.
- **Disclaimer:** Product specifications subject to change without notice. Not for use in life support systems.
- **Contact:**  
  - Website: [www.phyplusinc.com](http://www.phyplusinc.com)  
  - Email: info@phyplusinc.com  
  - Shanghai: 3F&4F, Building 23, Lane 676, Wuxing Road, Pudong, Shanghai  
  - Shenzhen: Room 1205, No.10 Li Shan Road, Shenzhen, China

---

## Revision History

| Date      | Version | Description |
|-----------|---------|-------------|
| 2020.11   | 1.0     | Initial release |
| 2020.12   | 1.1     | Added package info, corrected GPIO notes, updated ordering info, etc. |
| 2021.2    | 1.1.5   | Various updates |
| 2021.4    | 1.2     | Updated SoC description, sensitivity, sleep current, etc. |
| 2021.6    | 1.3     | Corrected GPIO pad count, updated sleep current, MSL parameter |
| 2021.10   | 1.3     | Updated supply rise time |
| 2022.1    | 1.3     | Updated order code, operating temperature |
| 2022.5    | 1.3     | Added FLASH program/erase time table |
| 2022.7    | 1.3     | Updated memory address mapping |
| 2022.9    | 1.3     | Updated GPIO description |
| 2022.10   | 1.3     | Added SOP16 info |

---

## Table of Contents

1. Introduction  
2. Product Overview  
   - Block Diagram  
   - Pin Assignments and Functions  
3. System Block  
   - CPU  
   - Memory (ROM, SRAM, FLASH, eFuse, Address Mapping)  
   - Boot and Execution Modes  
   - Power, Clock and Reset (PCR)  
   - Power Management  
   - Low Power Features  
   - Interrupts  
   - Clock Management  
   - IOMUX  
   - GPIO  
4. Peripheral Blocks  
   - 2.4GHz Radio  
   - Timer/Counters (TIMER)  
   - Real Time Counter (RTC)  
   - AES-ECB Encryption (ECB)  
   - Watchdog Timer (WDT)  
   - SPI (SPI0, SPI1)  
   - I2C (I2C0, I2C1)  
   - UART (UART0, UART1)  
   - DMIC/AMIC Data Path  
   - PWM  
   - Quadrature Decoder (QDEC)  
   - Key Scan (KSCAN)  
   - ADC with PGA  
5. Absolute Maximum Ratings  
6. Operating Conditions  
7. Radio Transceiver  
   - Current Consumption  
   - Transmitter/Receiver Specs  
   - RSSI Specs  
8. Glossary  
9. Ordering Information  
10. Package Dimensions  
11. Sample Application and Layout Guide  

---

## 1. Introduction

PHY6252 is a System on Chip (SoC) for Bluetooth 5.4 applications. It features a high-performance, low-power 32-bit processor, 64K retention SRAM, 512/256KB flash, 96KB ROM, 256bit efuse, and a multi-mode radio. It supports BLE with security, application, and OTA update. Serial peripheral IO and integrated application IP enable minimal BOM cost.

---

## 2. Product Overview

### 2.1 Block Diagram

*(See Figure 1 in original document)*

### 2.2 Pin Assignments and Functions

#### 2.2.1 PHY6252 (SSOP24)

| Pin | Pin Name         | Description                        |
|-----|------------------|------------------------------------|
| 1   | P31              | GPIO 31                            |
| 2   | P32              | GPIO 32                            |
| 3   | P33              | GPIO 33                            |
| 4   | P34              | GPIO 34                            |
| 5   | P0               | GPIO 0                             |
| 6   | P2 / SWD_IO      | GPIO 2 / SWD debug data inout      |
| 7   | P3 / SWD_CLK     | GPIO 3 / SWD debug clock           |
| 8   | P7               | GPIO 7                             |
| 9   | P9               | GPIO 9                             |
| 10  | P10              | GPIO 10                            |
| 11  | P11 / AIO_0      | GPIO 11 / ADC input 0              |
| 12  | P14 / AIO_3      | GPIO 14 / ADC input 3              |
| 13  | P15 / AIO_4      | GPIO 15 / ADC input 4 / micbias    |
| 14  | XTAL16M_I        | 16MHz crystal input                |
| 15  | XTAL16M_O        | 16MHz crystal output               |
| 16  | P16 / XTAL32K_I  | GPIO16 / 32.768KHz crystal input   |
| 17  | P17 / XTAL32K_O  | GPIO17 / 32.768KHz crystal output  |
| 18  | P18 / AIO_7      | GPIO 18/ADC input 7 / PGA negative |
| 19  | P20 / AIO_9      | GPIO 20/ADC input 9 / PGA positive |
| 20  | VDD3             | 3.3V power supply                  |
| 21  | VSS              | GND                                |
| 22  | RF               | RF antenna                         |
| 23  | P23 / AIO_1      | GPIO 23 / ADC input 1 / micbias ref|
| 24  | P24 / AIO_2      | GPIO 24 / ADC input 2              |

*All GPIO support 1M/150kΩ pull up, 150kΩ pull down.*

#### 2.2.2 PHY6252 (SOP16)

| Pin | Pin Name         | Description                        |
|-----|------------------|------------------------------------|
| 1   | P34              | GPIO 34                            |
| 2   | P2 / SWD_IO      | GPIO 2 / SWD debug data inout      |
| 3   | P3 / SWD_CLK     | GPIO 3 / SWD debug clock           |
| 4   | P7               | GPIO 7                             |
| 5   | P9               | GPIO 9                             |
| 6   | P10 / SWS        | GPIO 10 / Single-Wire Serial       |
| 7   | P11              | GPIO 11                            |
| 8   | P14              | GPIO 14                            |
| 9   | P15              | GPIO 15                            |
| 10  | P18              | GPIO 18                            |
| 11  | P20              | GPIO 20                            |
| 12  | XTAL16M_O        | 16MHz crystal output               |
| 13  | XTAL16M_I        | 16MHz crystal input                |
| 14  | VDD3             | 3.3V power supply                  |
| 15  | VSS              | GND                                |
| 16  | RF               | RF antenna                         |

*All GPIO support 1M/150kΩ pull up, 150kΩ pull down.*

---

## 3. System Block

### 3.1 CPU

- High-performance, low-power 32-bit processor
- AMBA bus matrix connects CPU, memories, peripherals
- CPU controls BLE modem and runs user applications

### 3.2 Memory

- 96KB ROM, 64KB SRAM, 512/256KB FLASH, 256bit efuse

#### 3.2.1 ROM

| Name | Size | Content |
|------|------|---------|
| ROM  | 96KB | Boot ROM, protocol stack, drivers, AT command |

#### 3.2.2 SRAM

| Name      | Size  | Content                |
|-----------|-------|------------------------|
| SRAM0     | 32KB  | Program/data           |
| SRAM1     | 16KB  | Program/data           |
| SRAM2     | 16KB  | Program/data           |
| SRAM_BB   | 4KB   | Program/data           |
| SRAM_cache| 8KB   | Cache                  |

#### 3.2.3 FLASH

- 512KB or 256KB
- Supports single-wire and 2-wire reading
- See Table 5 in original for program/erase times

#### 3.2.4 eFuse

- 256bits internal nonvolatile OTP storage

#### 3.2.5 Memory Address Mapping

| Name   | Size (KB) | Physical Address           |
|--------|-----------|---------------------------|
| ROM    | 96        | 1000_0000~1001_7FFF       |
| RAM0   | 32        | 1FFF_0000~1FFF_7FFF       |
| RAM1   | 16        | 1FFF_8000~1FFF_BFFF       |
| RAM2   | 16        | 1FFF_C000~1FFF_FFFF       |
| FLASH  | 512       | 1100_0000~1107_FFFF       |
| SPIF   | 4M        | 6000_0000~6007_FFFF       |

### 3.3 Boot and Execution Modes

- ROM1 aliased to 0x0 at power-on
- Boot loader checks FLASH validity, enters normal or programming mode

### 3.4 Power, Clock and Reset (PCR)

- Flexible reset and clock gating for all blocks

### 3.5 Power Management

- Functional blocks have independent power state control
- Normal, Sleep, and Off modes

### 3.6 Low Power Features

- Normal, Clock Gate, Sleep, Off states
- Wake-up sources: IO, RTC, RESET, UVLO reset

### 3.7 Interrupts

| Interrupt Name         | MCU Interrupt Number |
|-----------------------|----------------------|
| MCU(coretime irq)     | 0                    |
| bb_irq                | 1                    |
| kscan_irq             | 2                    |
| rtc_irq               | 3                    |
| ...                   | ...                  |
| adcc_irq              | 29                   |
| qdec_irq              | 30                   |

### 3.8 Clock Management

- 16MHz crystal oscillator (XT16M)
- 32MHz and 32kHz RC oscillators
- On-chip DLL for higher frequencies (32/48/64/96MHz)

### 3.9 IOMUX

- Flexible I/O configuration for most peripherals
- 19 configurable pads

### 3.10 GPIO

- All pins bi-directional, support wake-up, debounce, interrupt
- Pull-up/pull-down supported

#### 3.10.1 DC Characteristics

| Parameter                  | Min | Typ | Max | Unit |
|----------------------------|-----|-----|-----|------|
| Logic-0 input voltage      |     |     | 0.5 | V    |
| Logic-1 input voltage      | 2.4 |     |     | V    |
| Logic-0 input current      | -50 |     | 50  | nA   |
| Logic-1 input current      | -50 |     | 50  | nA   |
| Logic-0 output voltage     |     |     | 0.5 | V    |
| Logic-1 output voltage     | 2.5 |     |     | V    |

---

## 4. Peripheral Blocks

### 4.1 2.4GHz Radio

- ISM band 2.4–2.4835 GHz
- FSK, OQPSK modulation
- Data rates: 125kbps–2Mbps
- TX power: -20dBm to +10dBm
- RX sensitivity: -105dBm@125Kbps, -99dBm@1Mbps

### 4.2 Timer/Counters (TIMER)

- 32-bit SysTick, general purpose timers, 4MHz input clock

### 4.3 Real Time Counter (RTC)

- 24-bit counter, 12-bit prescaler, tick event generator

### 4.4 AES-ECB Encryption (ECB)

- 128-bit AES encryption block

### 4.5 Watchdog Timer (WDT)

- Countdown timer, can be paused during sleep/debug

### 4.6 SPI (SPI0, SPI1)

- Supports SPI, SSP, Microwire protocols
- Master/slave mode, exclusive per block

### 4.7 I2C (I2C0, I2C1)

- 100kHz/400kHz, 7/10-bit addressing, spike suppression

### 4.8 UART (UART0, UART1)

- Full-duplex, up to 1Mbps, flow control, parity, flexible pin assignment

### 4.9 DMIC/AMIC Data Path

- Supports analog and digital mics, multiple sample rates, voice compression

### 4.10 PWM

- 6 channels, 16MHz master clock, prescaler, up/down mode, programmable duty/frequency

### 4.11 Quadrature Decoder (QDEC)

- Buffered decoding, debounce, 3-axis, index channel, 4x/2x/1x count mode

### 4.12 Key Scan (KSCAN)

- Up to 16x18 matrix, manual/auto mode, debounce, interrupt

### 4.13 ADC with PGA

- 12-bit SAR ADC, 10 inputs, PGA with 0–42dB gain, manual/auto sweep mode

---

## 5. Absolute Maximum Ratings

| Parameter            | Min   | Max   | Unit |
|----------------------|-------|-------|------|
| Supply voltages      | -0.3  | +3.6  | V    |
| DEC                  |       | 1.32  | V    |
| I/O pin voltage      | -0.3  | VDD+0.3 | V  |
| Storage temperature  | -40   | +125  | °C   |
| Moisture Sensitivity |       | 3     | MSL  |
| ESD HBM              |       | 2     | kV   |
| ESD CDM              |       | 500   | V    |
| Flash endurance      |       | 100,000 | cycles |
| Flash retention      |       | 10 years @ 40°C |    |

---

## 6. Operating Conditions

| Parameter                | Min | Typ | Max | Units |
|--------------------------|-----|-----|-----|-------|
| Supply voltage (VDD3)    | 1.8 | 3   | 3.6 | V     |
| Supply rise time (0–1.8V)| 2   |     |     | ms    |
| Operating temp (consumer)| -40 | 27  | 85  | °C    |
| Operating temp (industrial)| -40 | 27 | 105 | °C    |

---

## 7. Radio Transceiver

### 7.1 Radio Current Consumption

| Parameter         | Typ | Unit |
|-------------------|-----|------|
| Tx only @ 0dBm    | 8.6 | mA   |
| Rx only           | 8   | mA   |

### 7.2 Transmitter Specification

- RF Max Output Power: 10dBm
- RF Min Output Power: -20dBm
- OBW for BLE 1Mbps: 1100KHz
- OBW for BLE 2Mbps: 2300KHz
- Frequency deviation for GFSK: 160–500KHz

### 7.3 Receiver Specification

- RX Sensitivity: -99dBm@1Mbps, -105dBm@125Kbps, -100dBm@500Kbps, -96dBm@2Mbps
- Selectivity, co-channel rejection, intermodulation, etc.

### 7.4 RSSI Specifications

| Parameter           | Typ | Unit |
|---------------------|-----|------|
| RSSI Dynamic Range  | 70  | dB   |
| RSSI Accuracy       | ±2  | dB   |
| RSSI Resolution     | 1   | dB   |
| RSSI Period         | 8   | us   |

---

## 8. Glossary

| Term   | Description |
|--------|-------------|
| AHB    | Advanced High-performance Bus |
| AMBA   | Advanced Microcontroller Bus Architecture |
| AON    | Always-on power domain |
| APB    | Advanced Peripheral Bus |
| BROM   | Boot ROM |
| DAP    | Debug Access Port |
| FPU    | Floating Point Unit |
| I2C    | Inter-Integrated Circuit |
| I2S    | Inter-IC Sound |
| ITM    | Instrumentation Trace Macrocell Unit |
| JTAG   | Joint Test Access Group |
| MPU    | Memory Protection Unit |
| NVIC   | Nested vector Interrupt Controller |
| PCR    | Power Clock Reset controller |
| POR    | Power on reset |
| RFIF   | APB peripheral to interface RF block |
| SoC    | System on chip |
| SPI    | Serial Peripheral Interface |
| SRAM   | Static Random Access memory |
| TWI    | Two-Wire Interface |
| UART   | Universal Asynchronous Receiver and Transmitter |
| WDT    | Watchdog Timer |

---

## 9. Ordering Information

| Part No.           | Package | Supply Voltage | Temp (°C) | Flash | Packing | Quantity (PCS/R) | MOQ (PCS) |
|--------------------|---------|---------------|-----------|-------|---------|------------------|-----------|
| PHY6252SD-W02C     | SSOP24  | 1.8~3.6V      | -40~85    | 256KB | Tube    | 5000             | 5000      |
| PHY6252SD-W04C     | SSOP24  | 1.8~3.6V      | -40~85    | 512KB | Tube    | 5000             | 5000      |
| PHY6252AASD        | SSOP24  | 1.8~3.6V      | -40~85    | 256KB | Tube    | 5000             | 5000      |
| PHY6252SD-H04I     | SSOP24  | 2.7~3.6V      | -40~105   | 512KB | Tube    | 5000             | 5000      |
| PHY6252SC-W02C     | SOP16   | 1.8~3.6V      | -40~85    | 256KB | Tube    | 5000             | 5000      |
| PHY6252SC-H04I     | SOP16   | 2.7~3.6V      | -40~105   | 512KB | Tube    | 5000             | 5000      |
| PHY6252SC-W04I     | SOP16   | 1.8~3.6V      | -40~105   | 512KB | Tube    | 5000             | 5000      |

---

## 10. Package Dimensions

*(See Figures 21 and 22 in original document for SSOP24 and SOP16 dimensions)*

---

## 11. Sample Application and Layout Guide

### 11.1 Sample Application (SSOP24)

*(See Figure 23 in original document)*

### 11.2 Sample Application (SOP16)

*(See Figure 24 in original document)*

### 11.3 Layout Guide

- **Placement:** Isolate RF matching/loop filter, keep clock traces short, shield sensitive blocks.
- **RF traces:** 50Ω impedance, keep differential traces equal length, treat certain RF trace as part of matching.
- **Bypass Capacitor:** Place close to VDD pins, use one large and one small, keep ground via close.
- **Layer Definition:** 4-layer PCB recommended, RF trace on surface, ground on 2nd layer, power on 3rd, signals on bottom.
- **Reference clock and trace:** Keep on 1st layer, isolate, surround with GND via, no traces under oscillator.
- **Power line or plane:** Use line for RF, add via and capacitors as needed, avoid under RF/oscillator.
- **Ground Via:** Place close to ground pad, use many, shield RF trace with via trail.

---

**For more details, diagrams, and register-level programming, refer to the original