# FR801xH Technical Datasheet  
Low Power Bluetooth SoC Supporting SIG MESH

**Version:** v1.1.5  
**Release Date:** 2023.07  
**Company:** Shanghai Freqchip Microelectronics Co., Ltd.

---

## Table of Contents

- Tables ............................................................................................................. 4  
- Figures ............................................................................................................ 5  
- Overview ........................................................................................................ 6  
- Features ......................................................................................................... 6  
- Applications ................................................................................................... 6  
- Ordering Information ..................................................................................... 7  
- 1. System Overview ..................................................................................... 8  
  - 1.1 Functional Block Diagram  
  - 1.2 Hardware Resources  
  - 1.3 Bluetooth RF Transceiver  
  - 1.4 Bluetooth Controller  
  - 1.5 Peripheral Interface Unit  
  - 1.6 Power Management Unit  
  - 1.7 Charging Management Unit  
- 2. Hardware Information ............................................................................ 12  
  - 2.1 Package Definitions  
  - 2.2 Package Dimensions  
  - 2.3 Pin Descriptions  
  - 2.4 Reference Schematics  
- 3. Electrical Characteristics ....................................................................... 32  
  - 3.1 Absolute Maximum Ratings  
  - 3.2 Recommended Operating Conditions  
  - 3.3 Power Consumption  
  - 3.4 Audio CODEC Parameters  
  - 3.5 Clock Parameters  
  - 3.6 ESD Parameters  
- Abbreviations ............................................................................................. 35  
- Contact Information .................................................................................... 36  
- Revision History ......................................................................................... 36  

---

## Overview

The FR801xH series chips are SoCs (System on Chip) designed for rapid development of low-power Bluetooth applications.  
Based on Freqchip's Bluetooth smart firmware and protocol stack, they are fully compatible with Bluetooth V5.1 (LE mode).  
Users can develop various applications on the built-in ARM Cortex-M3 32-bit high-performance MCU.

- **Bluetooth Smart Firmware includes:**  
  - L2CAP, SM, ATT, GATT, GAP  
  - BLE Profile & Protocol: GATT, LM, LC  
  - API drivers  
  - SIG MESH protocol stack  
  - Application profiles (proximity, health thermometer, heart rate, blood pressure, glucose, HID, etc.)  
  - SDK with drivers, OS-API, and SIG Mesh for networked applications

- **Integrated Features:**  
  - PMU (Li-ion charger + LDO)  
  - QSPI FLASH ROM with XIP mode  
  - I2C, UART, GPIO, ADC, PWM  
  - Competitive power consumption  
  - Stable Bluetooth connection  
  - Ultra-low BOM cost

---

## Features

- **Bluetooth:**  
  - Bluetooth V5.1 LE standard  
  - Supports 2M/1M/500K/125K data rates

- **CPU & Memory:**  
  - 32-bit ARM Cortex-M3 core, up to 48MHz  
  - 256KB/512KB/1MB Flash  
  - 48KB SRAM  
  - 128KB ROM (boot code, controller stack, BLE profile & protocol, API drivers, SIG MESH stack)

- **Power Management:**  
  - Integrated DC-DC, LDO  
  - Supports Li-ion/Li-polymer battery charging  
  - Programmable charge current up to 300mA  
  - Power-on reset, low voltage detection, voltage monitoring  
  - Software power-off, hardware wakeup

- **Peripheral Interfaces:**  
  - General GPIO (up to 30)  
  - Timers  
  - Efuse 128bit  
  - SPI Master/Slave, QSPI  
  - UART (FIFO 16/32)  
  - I2C (FIFO 8/32)  
  - PWM (6 channels)  
  - PDM  
  - 8-channel 10-bit SAR ADC  
  - Audio CODEC (mono, 20-bit DAC, 16-bit ADC)  
  - I2S

- **Bluetooth RF:**  
  - Integrated antenna matching (50Ω)  
  - Up to 10dBm TX power  
  - Sensitivity: -92~-95dBm  
  - Integrated channel filter, digital demodulator, real-time RSSI

- **Applications:**  
  - Smart keyboard/mouse  
  - Wearables  
  - Smart locks  
  - Smart home  
  - IoT  
  - SIG Mesh applications

---

## Ordering Information

| Model         | Temp Range      | Flash Size | Package   | Dimensions (mm)         |
|---------------|----------------|------------|-----------|-------------------------|
| FR8012HB      | -40°C~+105°C   | 256KB      | SOP16     | 10.0×3.9×1.5, 1.2pitch  |
| FR8012HAS     | -40°C~+105°C   | 512KB      | SOP16     | 10.0×3.9×1.5, 1.2pitch  |
| FR8012HAQ     | -40°C~+105°C   | 512KB      | QFN32     | 4.0×4.0×0.75, 0.4pitch  |
| FR8012HAQ-J   | -40°C~+105°C   | 512KB      | QFN32     | 4.0×4.0×0.85, 0.4pitch  |
| FR8016HA      | -40°C~+105°C   | 512KB      | QFN32     | 4.0×4.0×0.75, 0.4pitch  |
| FR8016HD      | -40°C~+105°C   | 1MB        | QFN32     | 4.0×4.0×0.85, 0.4pitch  |
| FR8018HA      | -40°C~+105°C   | 512KB      | QFN48     | 6.0×6.0×0.75, 0.4pitch  |
| FR8018HD      | -40°C~+105°C   | 1MB        | QFN48     | 6.0×6.0×0.75, 0.4pitch  |

---

## 1. System Overview

### 1.1 Functional Block Diagram

*(See Figure 1-1 in the original document)*

### 1.2 Hardware Resources

| Series      | Flash (KB) | RAM (KB) | GPIO | Timer | RTC | UART | I2C | SPI | QSPI | I2S | ADC | Charge | PDM | AES-128 | LV | TRNG |
|-------------|------------|----------|------|-------|-----|------|-----|-----|------|-----|-----|--------|-----|---------|----|------|
| FR8012HB    | 256        | 48       | 7    | 2     | √   | 2    | 2   | 1   | -    | 1   | 3ch | -      | √   | 1       | 1  | √    |
| FR8012HAS   | 512        | 48       | 7    | 2     | √   | 2    | 2   | 1   | -    | 1   | 3ch | -      | √   | 1       | 1  | √    |
| FR8012HAQ   | 512        | 48       | 15   | 2     | √   | 2    | 2   | 1   | 1    | 4ch | √   | √      | 1   | AES-128 | 1  | √    |
| FR8012HAQ-J | 512        | 48       | 19   | 2     | √   | 2    | 2   | 1   | 1    | 4ch | √   | √      | 1   | AES-128 | 1  | √    |
| FR8016HA    | 512        | 48       | 15+2¹| 2     | √   | 2    | 2   | 1   | 1    | 4ch | √   | √      | 1   | AES-128 | 1  | √    |
| FR8016HD    | 1024       | 48       | 19+2¹| 2     | √   | 2    | 2   | 1   | 1    | 4ch | √   | √      | 1   | AES-128 | 1  | √    |
| FR8018HA    | 512        | 48       | 30   | 2     | √   | 2    | 2   | 1   | 1    | 4ch | √   | √      | 1   | AES-128 | 1  | √    |
| FR8018HD    | 1024       | 48       | 30   | 2     | √   | 2    | 2   | 1   | 1    | 4ch | √   | √      | 1   | AES-128 | 1  | √    |

¹: Additional GPIOs available on some packages.

---

### 1.3 Bluetooth RF Transceiver

- Integrated antenna impedance matching (50Ω)
- Bluetooth v5.1 LE compliant
- Up to 10dBm TX power
- Sensitivity: -92 to -95dBm
- Integrated channel filter and digital demodulator
- Real-time digital RSSI

### 1.4 Bluetooth Controller

- Supports all device types: Broadcaster, Central, Observer, Peripheral
- Supports all packet types: Advertising, Data, Control
- Supports encryption (AES/CCM)
- Bitstream processing (CRC, Whitening)
- Frequency hopping
- Baseband power-down during protocol idle

### 1.5 Peripheral Interface Unit

- UART for debugging and AT command mode
- I2C for external EEPROM and sensors
- Up to 30 general-purpose IOs, all interrupt-capable
- 10-bit ADC, supports key mode and analog input
- 6-channel PWM controller
- Multiple programmable timers
- Watchdog circuit

### 1.6 Power Management Unit

- Power-on reset
- On-chip high-efficiency switching power supply, supports direct Li-ion battery input (1.8V–4.3V), programmable output voltage
- On-chip LDO for digital, RF, and analog circuits
- Software power-off and hardware wakeup
- Power-on reset supports low voltage detection
- Integrated voltage monitoring

### 1.7 Charging Management Unit

- Supports Li-ion/Li-polymer battery charging
- Programmable charge current up to 300mA
- Trickle charge current: 0.10/0.15/0.20/0.25 × constant current (register configurable)
- Trickle charge threshold: 2.7/2.8/2.9/3.0V
- Charge termination voltage: 4.1V–4.4V (50mV steps)
- Charge termination current: 0.10/0.15/0.20/0.25 × constant current
- Recharge voltage: triggers when VBAT drops 0.15V below termination voltage

*(See Figure 1-2 in original for charge curve)*

---

## 2. Hardware Information

### 2.1 Package Definitions

- SOP16, QFN32, QFN48 packages
- Pin layouts and diagrams for each package (see original figures)

### 2.2 Package Dimensions

- Detailed mechanical drawings (see original figures)

### 2.3 Pin Descriptions

- Pin type abbreviations:  
  - I: Digital input  
  - O: Digital output  
  - AI: Analog input  
  - AO: Analog output  
  - IO: Bidirectional digital  
  - OD: Open drain  
  - PWR: Power  
  - GND: Ground

- Full pin tables for each package, including alternate functions (UART, I2C, SPI, PWM, ADC, etc.)

### 2.4 Reference Schematics

- Minimal system and application reference schematics for each package (see original figures)

---

## 3. Electrical Characteristics

### 3.1 Absolute Maximum Ratings

| Parameter           | Min   | Max   | Unit |
|---------------------|-------|-------|------|
| Operating Temp      | -40   | 125   | °C   |
| Core Voltage        | 0.9   | 1.3   | V    |
| LDO_OUT             | 1.6   | 3.3   | V    |
| VBAT                | 1.8   | 4.3   | V    |
| VCHG                | 4.75  | 5.25  | V    |

### 3.2 Recommended Operating Conditions

| Parameter           | Min   | Typ   | Max   | Unit |
|---------------------|-------|-------|-------|------|
| Operating Temp      | -40   | 20    | 105   | °C   |
| Core Voltage        | 0.9   | 1.2   | 1.3   | V    |
| LDO_OUT             | 1.6   | 2.9   | 3.3   | V    |
| VBAT                | 1.8   | 3.3   | 4.3   | V    |
| VCHG                | 4.75  | 5     | 5.25  | V    |

### 3.3 Power Consumption

| Mode                        | Avg   | Max   | Unit |
|-----------------------------|-------|-------|------|
| TX Peak Current (0dB)       | 8     | -     | mA   |
| RX Peak Current             | 9.7   | -     | mA   |
| Sleep Current (48K RAM)     | 6.1   | -     | µA   |
| Power Off Current           | 2.7   | -     | µA   |

### 3.4 Audio CODEC Parameters

- **DAC (Mono):**  
  - Resolution: 20 bits  
  - Sample Rate: 8–48kHz  
  - SNR: 92dB  
  - Digital Gain: -48 to +32dB (1/48dB steps)  
  - Analog Gain: 0 to -30dB (3dB steps)  
  - Output Voltage: 1500mV (VDDA=2.9V)  
  - Stopband Attenuation: 65dB

- **ADC (Mono):**  
  - Resolution: 16 bits  
  - Sample Rate: 8–48kHz  
  - SNR: 79dB  
  - Digital Gain: -48 to +32dB (1/48dB steps)  
  - Analog Gain: 0 to +30dB (3dB steps)

### 3.5 Clock Parameters

| Parameter         | Min | Typ | Max | Unit |
|-------------------|-----|-----|-----|------|
| Clock Frequency   | 24  | 24  | 24  | MHz  |
| Load Capacitance  | -   | 9   | 12  | pF   |
| Tolerance         | -   | ±10 | -   | ppm  |
| Dynamic Resistance| -   | -   | 60  | Ω    |
| Parallel Capacitance| - | -   | 2   | pF   |

### 3.6 ESD Parameters

| Pin      | HBM      | CDM      |
|----------|----------|----------|
| RF       | ±2000V   | ±2000V   |
| XTALI    | ±2000V   | ±2000V   |
| XTALO    | ±2000V   | ±2000V   |
| OTHERS   | ±2000V   | ±2000V   |

---

## Abbreviations

| Abbreviation | Description           |
|--------------|----------------------|
| AEC          | Acoustic Echo Canceller |
| AGC          | Automatic Gain Control  |
| ANS          | Ambient Noise Suppression |
| ADC          | Analog-to-Digital Converter |
| DAC          | Digital-to-Analog Converter |
| GPIO         | General Purpose IO     |
| MIC          | Microphone             |
| PMU          | Power Management Unit  |
| OSC          | Oscillator             |
| PA           | Power Amplifier        |
| SoC          | System on Chip         |

---

## Contact Information

- **Company:** Shanghai Freqchip Microelectronics Co., Ltd.
- **Address:** Room 501-A, Building 8, Lane 912, Bibo Road, Free Trade Zone, Shanghai, China
- **Phone:** +86-21-5027-0080
- **Website:** [www.freqchip.com](http://www.freqchip.com)
- **Sales Email:** sales@freqchip.com
- **Documentation Email:** docs@freqchip.com

---

## Revision History

| Version | Date        | Summary                                      |
|---------|------------|-----------------------------------------------|
| V1.0    | 2022.11.1  | Initial release                               |
| V1.1    | 2022.12.29 |                                               |
| V1.1.4  | 2023.8.3   | Added FR8012HAQ-J, charging module info       |
| V1.1.5  | 2023.9.18  | Removed USB OTG, updated Cortex-M3 features, updated ESD info |

---