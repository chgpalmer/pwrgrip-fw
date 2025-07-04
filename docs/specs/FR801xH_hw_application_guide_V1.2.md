# FR801xH Hardware Application Guide  
Bluetooth Low Energy SoC

**Version:** V1.2  
**Date:** 2022.03.31

---

## Table of Contents

1. [FR801xH Series Chip Introduction](#1-fr801xh-series-chip-introduction)
2. [Package Definitions](#2-package-definitions)
   - 2.1 FR8012HAS Package
   - 2.2 FR8016 Package
   - 2.3 FR8018 Package
   - 2.4 FR801xH Pin Definitions
3. [Reference Designs](#3-reference-designs)
   - 3.1 FR8012HAS Reference Design
   - 3.2 FR8016HA Reference Design
   - 3.3 FR8016HD Reference Design
   - 3.4 FR8018HA/HD Reference Design
4. [Application Design Notes](#4-application-design-notes)
   - 4.1 Power Supply
   - 4.2 RF
   - 4.3 Crystal Oscillator
   - 4.4 GPIO
   - 4.5 Battery Voltage Sampling via ADC Divider
   - 4.6 Interrupt Pin Wiring
   - 4.7 LED Pin Wiring
   - 4.8 System Design
5. [PCB Antenna](#5-pcb-antenna)
6. [Contact Information](#6-contact-information)
7. [Revision History](#7-revision-history)

---

## 1. FR801xH Series Chip Introduction

- FR801xH integrates RF, Baseband, PMU, CODEC, SPI, I2C, UART, GPIO, ADC, PWM, Keyboard scan, etc.
- Supports Bluetooth V5.1, standard SIG Mesh, HomeKit.
- Applications: smart bracelets, voice remotes, smart home, etc.
- Good layout, clear routing, and solid grounding are essential for design.
- Few external components required; can use double-sided PCB to save cost.
- Top layer for components and signal routing, bottom for power and ground.

**FR801xH Series Models:**

| Device     | Package   | Size (mm)         | Features                                                        | Shipment  |
|------------|-----------|-------------------|------------------------------------------------------------------|-----------|
| FR8012HAS  | SOP16     | 10×3.9×1.5, 1.27p | 512KB flash, 7 GPIO, UART, I2C, SPI, PWM, ADC, I2S, LDO         | Tube      |
| FR8016HA   | QFN32     | 4×4×0.75, 0.4p    | 512KB flash, 15 GPIO, UART, I2C, SPI, PWM, ADC, I2S, LDO, Charger, Audio CODEC | Tape reel |
| FR8016HD   | QFN32     | 4×4×0.75, 0.4p    | 1MB flash, 19 GPIO, UART, I2C, SPI, PWM, ADC, I2S, LDO, Charger | Tape reel |
| FR8018HA   | QFN48     | 6×6×0.75, 0.4p    | 512KB flash, 30 GPIO, UART, I2C, SPI, PWM, ADC, I2S, LDO, Charger, Audio CODEC | Tape reel |
| FR8018HD   | QFN48     | 6×6×0.75, 0.4p    | 1MB flash, 30 GPIO, UART, I2C, SPI, PWM, ADC, I2S, LDO, Charger, Audio CODEC | Tape reel |

---

## 2. Package Definitions

### 2.1 FR8012HAS Package

- SOP16 package  
- [See original document for pinout and dimensions]

### 2.2 FR8016 Package

- FR8016HA: QFN32 4×4 package  
- FR8016HD: QFN32 4×4 package  
- [See original document for pinout and dimensions]

### 2.3 FR8018 Package

- FR8018HA/HD: QFN48 6×6 package  
- [See original document for pinout and dimensions]

### 2.4 FR801xH Pin Definitions

**Pin Type Abbreviations:**

| Symbol | Description         |
|--------|---------------------|
| I      | Digital Input       |
| O      | Digital Output      |
| DIO    | Digital Bidirectional |
| AI     | Analog Input        |
| AO     | Analog Output       |
| AIO    | Analog Bidirectional|
| PWR    | Power               |
| GND    | Ground              |

**Pin Mapping Table:**  
*(Excerpt, see original for full table)*

| Pin# (FR8018HA) | Pin# (FR8016HD) | Pin# (FR8016HA) | Pin# (FR8012HB) | Name    | Type | Function (Multiplexed) |
|-----------------|-----------------|-----------------|-----------------|---------|------|------------------------|
| 1               | 27              | 27              | 13              | PA3     | DIO  | SDA1/I2SDIN/PWM3_P/... |
| 2               | 28              | 28              | 14              | PA2     | DIO  | SCL1/I2SDOUT/PWM2_P/...|
| ...             | ...             | ...             | ...             | ...     | ...  | ...                    |

*(See original for all pins and alternate functions)*

---

## 3. Reference Designs

- 3.1 FR8012HAS Reference Design
- 3.2 FR8016HA Reference Design
- 3.3 FR8016HD Reference Design
- 3.4 FR8018HA/HD Reference Design

*(See original document for schematics and layouts)*

---

## 4. Application Design Notes

### 4.1 Power Supply

- Supply voltage: 1.8V–4.3V; supports Li-ion, coin cell, or dry cell.
- Place filter capacitors for MIC_BIAS, VMID, VCHG, VBAT, LDO_OUT close to IC pins and ground.
- If microphone or charging not used, omit related components.
- BSW is DC/DC switch output; place L2 inductor close to BSW, C11 capacitor close to L2, keep traces short and wide.
- L2: ≥4.7uH (recommended 10uH), >50mA, <1Ω DCR, use power inductor.
- Ensure at least 9 ground vias under chip for good grounding.

### 4.2 RF

- RF traces: 50Ω impedance, short, wide, no vias, same layer as chip, avoid right angles, use arcs or 135° bends.
- Shield with ground vias, ensure solid ground plane under RF traces.
- Reserve π matching circuit near RF pin for antenna tuning.
- Use inverted-F antenna, place at board edge, keep area clear of ground, metal, battery, and noise sources.

### 4.3 Crystal Oscillator

- Keep crystal traces short, avoid vias, isolate from RF traces with ground.
- Place load capacitors close to crystal.
- Use 24MHz crystal, ±10ppm, 6–12pF load capacitance.
- Tune load capacitance or register values to keep frequency offset within ±30kHz.

### 4.4 GPIO

- All pins configurable as input/output.
- GPIO high output = LDO_OUT voltage (configurable via API).
- When VBAT > 3.0V, LDO_OUT = 3.0V; when VBAT < 3.0V, LDO_OUT = VBAT.
- Input thresholds: high > 0.7×LDO_OUT, low < 0.3×LDO_OUT.
- PA2/PA3 default to UART0 at startup (PA3 = TX, PA2 = RX).

### 4.5 Battery Voltage Sampling via ADC Divider

- Use 2- or 3-resistor divider; ADC range: 0–LDO_OUT.
- Set LDO_OUT via `pmu_set_aldo_voltage()` in `user_entry_before_ble_init()`.
- Default LDO_OUT = 3.0V.
- Example: two 10MΩ resistors, C > 10nF.
- Can also use `adc_get_result()` to read VBAT directly (no divider needed).

### 4.6 Interrupt Pin Wiring

- If external interrupt pin >3.0V, add 1kΩ resistor between module and chip GPIO to avoid raising LDO_OUT.

### 4.7 LED Pin Wiring

- Use direct drive for LEDs via dedicated LED pins.

### 4.8 System Design

- Before mass production, tune frequency offset and antenna impedance for each design.
- Separate Bluetooth GND from high-power device GND, connect at a single point to power GND.

---

## 5. PCB Antenna

- On-board PCB antenna is low-cost and easy to assemble but lower performance and more susceptible to interference.
- For small/high-performance products, use chip or external antenna.
- Inverted-F antenna recommended.

---

## 6. Contact Information

- **Website:** [www.freqchip.com](http://www.freqchip.com)
- **Sales Email:** sales@freqchip.com
- **Phone:** +86-21-5027-0080

---

## 7. Revision History

| Version | Date       | Description                |
|---------|------------|----------------------------|
| V1.2    | 2022.3.31  | Updated pinout             |
| V1.1    | 2020.5.29  | Modified LED pin usage     |
| V1.0    | 2020.2.29  | Initial Draft              |

**Feedback:**  
Freqchip welcomes feedback on this product and document. Please send comments or suggestions to