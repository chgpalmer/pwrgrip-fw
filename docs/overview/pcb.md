# PCB Summary: pwrgrip PB-03 SMD v1.1

**Revision date:** 2024-01-13  
**Designer:** Charles Palmer  
**EDA Tool:** EasyEDA Standard Editor

---

## Overview

The pwrgrip PB-03 SMD v1.1 is a 2-layer surface-mount PCB designed for a power grip device.  
It features the Ai-Thinker PB-03 BLE module (PHYPLUS6252 SoC), USB-C power and data, battery charging, load cell interface, and an OLED display.

---

## Key Subsystems

### Power Input & Regulation

- USB-C input connects directly to:
  - **TP4056 LiPo charge IC:** Programmable current (~600mA via 2kΩ resistor)
  - **Power selection MOSFETs and diodes:** Safely switch between USB and LiPo
  - **HT733 or RT9078 3.3V regulator:** Downstream from battery rail
  - Dropout voltage of ~0.15V keeps system powered down to ~2.1V battery
  - Schottky diode on USB-VCC input to prevent reverse current to host
  - Battery voltage monitor circuit (possibly feeding MCU ADC for safe shutdown)

### Microcontroller Core

- PB-03 module with PhyPlusInc PHY6252 Bluetooth SoC
- Low power, BLE-capable, ideal for handheld grip applications
- External programmer via USB or serial debug interface (possible)
- Earlier prototypes used ESP32-S3

### Display Interface

- **SSD1306 OLED (128x64):** Mounted via ribbon cable directly to PCB
- Driven over I²C bus
- Pins likely mapped to default PB-03 SDA/SCL or rerouted to fit physical layout

### Load Cell Amplifier Circuit

- **HX717:** Mounted near input pads
- Connected to Wheatstone bridge strain gauges
- Handles force data acquisition at 10–320Hz
- Signal lines (A+, A−) routed from external load cell connector
- Grounded shielding likely tied to analog ground

### User Interface & Control

- Multiple push buttons (mode, tare, clear, on/off)
- Likely mapped to MCU GPIO pins
- Possible rotary encoder or capacitive input footprints in future versions

### Connectors & IO

- Power, signal, and load cell connectors placed for edge or bottom access
- Mounting holes and screen position hint at enclosure constraints

### Layout Observations

- v1.1 silkscreen tag is present
- Drain/source routing near the FET footprint appears fixed compared to prior versions
- Regulator and charger blocks look clean and isolated—good for EMI

---

## Block Diagram / Connections

<pre>
                               ┌───────────────────────────┐
                               │         USB-C Port        │
                               └────────────┬──────────────┘
                                            │
                                            ▼
                          ┌────────────────────────────────────┐
                          │         TP4056 Charger IC          │
                          │      • Charges LiPo battery        │
                          │      • Configurable current limit  │
                          └────────────┬─────────────┬────────┘
                                       │             │
                                       ▼             ▼
                            ┌────────────────┐   ┌────────────┐
                            │   LiPo Battery │   │  USB 5V In │
                            └────┬───────────┘   └────┬───────┘
                                 │                    │
                   ┌─────────────▼────────────────────▼──────────────┐
                   │           Power Source Selection & Protection   │
                   │      • MOSFET switches                          │
                   │      • Schottky diodes                          │
                   └──────┬─────────────────────┬────────────────────┘
                          │                     │
                          ▼                     ▼
               ┌─────────────────┐     ┌────────────────────────┐
               │   HT733 LDO     │     │  Battery Voltage Monitor│
               │   3.3V Regulator│     │  → feeds into MCU ADC   │
               └────┬────────────┘     └────────────┬───────────┘
                    │                               │
                    ▼                               ▼
        ┌────────────────────────┐      ┌───────────────────────────┐
        │     Main Power Rail    │─────▶│       MCU (PB-03)         │
        │      (3.3V system)     │      │ • Bluetooth SoC PHY6252   │
        └────────────────────────┘      │ • Wakes from GPIO         │
                                        │ • Connects via I²C/SPI    │
                                        └────────┬────────────┬─────┘
                                                 │            │
                                                 ▼            ▼
                            ┌────────────────────┐   ┌────────────────────────┐
                            │    OLED Display     │   │    Buttons Interface   │
                            │  • SSD1306, I²C     │   │  • Tare, Mode, etc.    │
                            └────────┬────────────┘   └─────────┬─────────────┘
                                     │                          │
                                     ▼                          ▼
                          ┌────────────────────────────┐   ┌────────────────────┐
                          │      HX717 Amplifier       │   │   MCU Reset Circuit │
                          │ • Reads Load Cell strain   │   │ • Optional GPIO pin │
                          │ • Outputs force data       │   └────────────────────┘
                          └────────────┬───────────────┘
                                       │
                                       ▼
                           ┌─────────────────────┐
                           │   Load Cell Strain   │
                           │ • Wheatstone bridge  │
                           │ • External sensor    │
                           └─────────────────────┘

</pre>

---

## MC Pin Mapping

**Pin-to-Pad Mapping (from PCB layout):**

| PCB Pad / Signal | PB-03 Pin | SoC Pin | Function                                      |
|------------------|-----------|---------|-----------------------------------------------|
| 3V3              | 3         | 3V3     | Resgulated power supply (input to module)      |
| LED              | 16        | P32     | Drives status or heartbeat LED                |
| I2C_SCK          | 12        | P16     | I²C clock line → SSD1306 OLED                 |
| I2C_SDT          | 13        | P17     | I²C data line → SSD1306 OLED                  |
| CHRG             | —         | GND     | TP4056 charge status pad (direct to ground)   |
| STDBY            | —         | NC      | Not connected (TP4056 standby not routed)     |
| PGA+             | 19        | P18     | Load cell signal (A+) to amplifier            |
| PGA−             | 32        | P20     | Load cell signal (A−) to amplifier            |
| BAT_7            | 31        | P9      | Battery monitor input (via voltage divider)   |
| SWD_IO           | 22        | P2      | Serial Wire Debug data (programming)          |
| SWD_CLK          | 23        | P3      | Serial Wire Debug clock (programming)         |
| SW1              | 27        | P34     | Tactile button (e.g. Tare or Mode)            |
| SW2              | 29        | P23     | Tactile button (e.g. Clear or Power toggle)   |

**Notes:**
- CHRG tied directly to GND suggests passive LED status indicator only, not software-readable.
- STDBY is left unconnected, so no standby status is fed to the MCU.
- SWD_IO and SWD_CLK give you solid in-system programming/debug options alongside USB.
- The I²C lines (P16, P17) are routed cleanly to the OLED footprint via short traces—well done!
---

## Power

- Input: USB-C (5V)
- Battery: Li-ion (via TP4056 charger)
- System voltage: 3.3V (HT7533-1 LDO)

---

## Mechanical (TODO)

- Board type: SMD, 2-layer
- Dimensions: 36.10mm * 33.70mm
- Silkscreen label: "PB-03 SMD v1.1"
- Mounting/connector details: Screw mount in the corners

---

## Component Summary

| Component      | Part Number         | Description                                 | Link                                      |
|----------------|--------------------|---------------------------------------------|-------------------------------------------|
| PB-03 Module   | PB-03              | BLE SoC module (PHYPLUS6252)                | [C2980079](https://lcsc.com/eda_search?q=C2980079) |
| HX717          | HX717_C2961106     | 24-bit ADC for load cell (HX717)            | [C2961106](https://lcsc.com/eda_search?q=C2961106) |
| SSD1306 OLED   | [manual assembly]  | 128x64 OLED, I2C, ribbon cable, central UI  | [add if known]                            |
| USB-C          | TYPE-C 6P          | USB-C connector                             | [C456012](https://lcsc.com/eda_search?q=C456012)   |
| TP4056         | TP4056-42-ESOP8    | Li-ion battery charger                      | [C16581](https://lcsc.com/eda_search?q=C16581)     |
| HT7533-1       | HT7533-1           | 3.3V LDO regulator                          | [C14289](https://lcsc.com/eda_search?q=C14289)     |
| Tactile Switch | TS-1187A-B-A-B     | User input switch                           | [C318884](https://lcsc.com/eda_search?q=C318884)   |
| LED            | NCD0805R1          | Red LED                                     | [C84256](https://lcsc.com/eda_search?q=C84256)     |
| [Others]       | [see BOM]          | Passives, FETs, diodes, pads                | [see BOM]                                  |

---

## Additional Notes / TODOs

- [ ] Add detailed pin mapping for all key peripherals.
- [ ] Add schematic diagram or reference.
- [ ] Add mounting/connector details.
- [ ] Add any board-specific quirks or errata.
- [ ] Reference full BOM in `docs/BOM_pwrgrip-PB-03-SMD_2025-07-04.csv`.
- [ ] Add photos or layout images if available.
- [ ] Add OLED and other external module details as available.
- [ ] Pin mapping and schematic details to be added.

---

See the full BOM for part numbers and supplier details.