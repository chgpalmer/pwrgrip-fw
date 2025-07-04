# pwrgrip-fw: Firmware for PB-03 Power Grip (PHYPLUS6252)

Firmware for the pwrgrip PB-03 board, a BLE-enabled power grip device based on the Ai-Thinker PB-03 module (PHYPLUS6252 SoC).  
This project targets Zephyr RTOS and supports custom hardware including load cell (HX717), OLED display, USB-C power, and more.

---

## Project Overview

- **Target Hardware:**  
  - **PB-03 BLE Module:** Ai-Thinker PB-03 (PHYPLUS6252 SoC, BLE 5.2, 32-bit ARM Cortex-M0, 64KB SRAM, 256KB Flash)
  - **Custom PCB:** USB-C power, LiPo charging, HX717 load cell ADC, SSD1306 OLED, buttons, battery monitor
  - **Debug/Programming:** SWD (via CMSIS-DAP), UART (console/bootloader, requires soldering)
- **Firmware Goals:**  
  - Zephyr RTOS port for PHYPLUS6252 and PB-03 board
  - Support for all onboard peripherals (load cell, OLED, buttons, battery monitor)
  - BLE communication and OTA update support (future)
  - Robust flashing/debugging via OpenOCD (custom driver) and vendor tools

---

## Status

- **Hardware documentation:** Complete ([pcb.md](docs/overview/pcb.md), [pb-03.md](docs/overview/pb-03.md))
- **OpenOCD debug access:** Working (SWD, CMSIS-DAP, Cortex-M0 detected)
- **Custom OpenOCD flash driver:** Implemented (`phyplus6252_flash.c`), target config (`phyplus6252.cfg`) added, **ready for hardware testing**
- **Zephyr board/SoC port:** In progress (board and SoC definitions stubbed, peripheral bring-up ongoing)
- **Peripheral drivers:** HX717, OLED, GPIO, UART, I2C/SPI identified and being ported/adapted
- **Documentation:** Up to date ([flashing.md](docs/overview/flashing.md), [phyplus6252_sdk.md](docs/overview/phyplus6252_sdk.md))

---

## Quick Start

### 1. Clone and Set Up the Workspace

To set up your workspace, run:

```sh
wget https://raw.githubusercontent.com/chgpalmer/pwrgrip-fw/main/setup.sh
chmod +x setup.sh
mkdir my-workspace && ./setup.sh my-workspace
rm setup.sh
```

This script will:
- Set up a Python virtual environment
- Install Zephyr and Python dependencies
- Download and set up the Zephyr SDK (macOS/Linux minimal version)
- Clone and build the custom OpenOCD fork (with PHYPLUS6252 flash support)
- Initialize the workspace

### 2. Build the Firmware

```sh
source ../.venv/bin/activate
cd pwrgrip-fw
west build -b pb03
```
*(Replace `pb03` with your board name if different.)*

### 3. Flash and Debug

- **Via OpenOCD (recommended for PB-03):**
  ```sh
  openocd -f interface/cmsis-dap.cfg -f target/phyplus6252.cfg
  ```
  Then use `west flash` or GDB as usual.

- **Via Vendor Tools:**  
  Use Keil/J-Link with the provided `.FLM` file, or the Windows GUI tool for flashing/debugging.

- **UART Bootloader:**  
  (If supported, see [flashing.md](docs/overview/flashing.md) and solder wires to P9/P10.)

---

## Hardware Features

- **BLE SoC:** PHYPLUS6252 (BLE 5.2, Cortex-M0, 64KB SRAM, 256KB Flash)
- **Load Cell Interface:** HX717 24-bit ADC
- **Display:** SSD1306 OLED (I2C)
- **Power:** USB-C, LiPo battery, TP4056 charger, 3.3V LDO
- **User Input:** Buttons (mode, tare, clear, on/off)
- **Battery Monitoring:** Voltage divider to ADC
- **Debug/Programming:** SWD (P2/P3), UART (P9/P10, not routed—requires soldering)

See [pcb.md](docs/overview/pcb.md) and [pb-03.md](docs/overview/pb-03.md) for full pin mapping and hardware details.

---

## Development Flow

1. **Source the environment:**
    ```sh
    cd path/to/pwrgrip-fw-workspace
    source .venv/bin/activate
    cd pwrgrip-fw
    ```

2. **Build:**
    ```sh
    west build -b pb03
    ```

3. **Flash:**
    ```sh
    # With OpenOCD running in another terminal:
    west flash
    ```

4. **Debug:**
    - Use VS Code with Cortex-Debug extension, or GDB via OpenOCD.

---

## Documentation

- [Hardware Overview: PB-03 Module](docs/overview/pb-03.md)
- [Custom PCB Details](docs/overview/pcb.md)
- [PHYPLUS6252 SDK Breakdown](docs/overview/phyplus6252_sdk.md)
- [Flashing and Debugging Guide](docs/overview/flashing.md)
- [Peripheral Bring-up Comparison](docs/overview/frusdk_physdk_comparison.md)
- [HX717 ADC](docs/overview/hx717.md)
- [OLED Display](docs/overview/oled.md)

---

## Troubleshooting

- **No debug connection?**  
  - Check SWD wiring (P2/P3), power, and adapter.
  - Confirm OpenOCD sees the Cortex-M0 core.
- **No UART output?**  
  - UART pins (P9/P10) are not routed—solder wires to module pins for serial console.
- **Flashing fails?**  
  - Use vendor tools as fallback. See [flashing.md](docs/overview/flashing.md) for details.

---

## References

- [Zephyr Project Documentation](https://docs.zephyrproject.org/latest/)
- [OpenOCD Flash Programming](https://open-cmsis-pack.github.io/OpenOCD-Flash-Programming/)
- [Cortex-Debug VS Code Extension](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug)
- [PHYPLUS6252 SDK and Docs](docs/overview/phyplus6252_sdk.md)

---

## Project Status

- **Bring-up:** In progress
- **OpenOCD flashing:** Driver implemented, ready for hardware test
- **Zephyr port:** Board/SoC definitions stubbed, peripheral bring-up ongoing
- **Documentation:** Up to date

---

> **Tip:**  
> Update the plan and documentation as you go! Check off items, add notes, and keep track of issues or discoveries.
