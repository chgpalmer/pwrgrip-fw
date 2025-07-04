# Programming and Debugging the PB-03 (PHY6252) Board

This guide summarizes the current state and options for programming and debugging the PB-03 module (PHYPLUS6252 SoC), with a focus on enabling OpenOCD-based flashing and debug, but also covering UART and vendor tools.

---

## Overview

- **SWD (SIO/SDT) pins** are connected on the PCB for ARM debug access.
- **OpenOCD** with a CMSIS-DAP adapter and the `stm32f0x.cfg` target can connect and debug the ARM Cortex-M0 core, but cannot program internal flash without a custom driver.
- **UART** (P9/P10) is available on the module (not routed on PCB, but can be soldered) for serial console (stdout/Zephyr shell) and possibly UART bootloader flashing.
- **Vendor tools** (Keil/J-Link with `.FLM` file, or Windows GUI tools) are the manufacturer’s intended methods for flashing and debugging.
- **BLE OTA** is possible after a bootloader is running.

---

## Internal Flash Details

- **Internal flash is memory-mapped at:**  
  `0x11000000~0x1107FFFF` (512KB) — as per the SoC datasheet.
- The SDK's `core_bumbee_m0.h` and `mcu_phy_bumbee.h` define this region and the base addresses for the SoC's peripherals.
- The internal flash controller is accessed via the `AP_SPIF` peripheral, and the SDK's `flash.c`/`flash.h` implements the programming/erase logic using these registers.
- The controller issues **JEDEC SPI NOR commands** (WREN, PP, SE, CE, RDID, etc.) to the internal flash, which is unusual but not unique for BLE/IoT SoCs.

---

## Programming/Debugging Methods

| Method         | Debug | Flash | VS Code Integration | Notes                                 |
|----------------|-------|-------|---------------------|---------------------------------------|
| **OpenOCD**        | Yes   | No*   | Yes (Cortex-Debug)  | *Needs custom flash driver            |
| **Keil MDK/J-Link**| Yes   | Yes   | Yes (via tasks)     | Use provided `.FLM` file              |
| **Vendor Tool**    | No    | Yes   | Yes (via tasks)     | Windows only, less integrated         |
| **UART Bootloader**| No    | Yes   | Yes (via tasks)     | May require special boot pin/sequence |
| **BLE OTA**        | No    | Yes   | No                  | Requires working bootloader           |

---

## OpenOCD Flashing: Feasibility and Next Steps

### Key Observations

- The PHYPLUS6252 internal flash controller is **not** STM32/Nordic/ARM proprietary, but is **very similar to a generic QSPI/SPI NOR controller** (e.g., Synopsys DesignWare QSPI).
- All flash operations are performed by issuing JEDEC SPI NOR commands via the `AP_SPIF` controller.
- The SDK’s `flash.c`/`flash.h` are the best reference for the programming sequence and register usage.

### What to Do Next

1. **Compare the `AP_SPIF_TypeDef` register map** with OpenOCD’s existing QSPI/SPI NOR drivers (e.g., `dw_qspi.c`, `zynq_qspi.c`, `cfi.c`).
2. **If the register map matches**, try adapting an existing OpenOCD driver for the PHYPLUS6252.
3. **If not**, use the SDK’s programming sequence as a reference to write a new OpenOCD flash driver.
4. **Handle cache bypass/reset** as in the SDK, if required.
5. **Be aware of possible security/bootloader restrictions** that could block direct programming.

---

## UART Flashing and Serial Output

- **UART (P9/P10)** can be used for:
  - **Serial console (stdout/Zephyr shell):** Highly recommended for debugging and logs.
  - **UART bootloader flashing:** If supported, may require a specific boot pin/sequence (see datasheet or Security Boot User Guide).
- **To use UART:** Solder wires to the module pins if not routed on your PCB.

---

## Manufacturer-Intended Flashing Methods

- **Keil MDK/J-Link:** Use the provided `.FLM` file for flashing and debugging via SWD.
- **Vendor Windows Tool:** (e.g., `PhyPlusKit.exe`) for flashing via SWD or UART.
- **BLE OTA:** For firmware updates after a bootloader is running.

---

## Summary Table

| File/Folder                                                                 | Purpose                                               |
|-----------------------------------------------------------------------------|-------------------------------------------------------|
| phy6252-SDK/components/driver/flash/flash.c, flash.h                        | Internal flash driver (primary source for OpenOCD driver) |
| phy6252-SDK/components/driver/spiflash/                                     | External SPI flash (not for code)                     |
| hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_flash.h      | Freqchip internal flash driver (compare for compatibility) |
| core_bumbee_m0.h, mcu_phy_bumbee.h                                         | SoC memory map, peripheral base addresses, register structs |
| .FLM files                                                                  | Keil flash loader blobs (not usable by OpenOCD, but confirm algorithm) |

---

## Recommendations

- **Short Term:**  
  Use Keil/J-Link tools for flashing and debugging. Integrate with VS Code using tasks or scripts. Use OpenOCD for RAM debugging only (no flash) unless you find or write a compatible flash driver.
- **Medium Term:**  
  Investigate the internal flash controller and attempt to write or adapt an OpenOCD flash driver. Compare with Freqchip/FR30xx for compatibility.
- **UART:**  
  Solder wires to UART pins for serial output and possible UART bootloader flashing.
- **Document:**  
  As you discover working toolchains, scripts, or quirks, update this file for future reference.

---

## References

- [OpenOCD Flash Programming](https://open-cmsis-pack.github.io/OpenOCD-Flash-Programming/)
- [Cortex-Debug VS Code Extension](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug)
- [PB-03 Module Pinout](pb-03.md)
- [PCB Pin Mapping](pcb.md)
- [PHYPLUS6252 SDK and Keil tools]
- [PHY622X Security Boot User Guide](../specs/PHY62XX_3.x.x_ANS/PHY622X_Security_Boot_User_Guide_v1.0.txt)

---

openocd output:
<pre>
Open On-Chip Debugger 0.12.0+dev (2023-12-19-08:57)
Licensed under GNU GPL v2
For bug reports, read
    http://openocd.org/doc/doxygen/bugs.html
Info : auto-selecting first available session transport "swd". To override use 'transport select <transport>'.
Info : clock speed 1000 kHz
Info : CMSIS-DAP: SWD supported
Info : CMSIS-DAP: FW Version = 2.0.0
Info : CMSIS-DAP: Serial# = 0001A0000002
Info : CMSIS-DAP: Interface Initialised (SWD)
Info : SWCLK/TCK = 1000 kHz
Info : CMSIS-DAP: Interface ready
Info : Hardware thread awareness created
Info : clock speed 1000 kHz
Info : SWD DPIDR 0x0bb11477
Info : PHYplus PHY6222.cpu: hardware has 4 breakpoints, 2 watchpoints
Info : starting gdb server for PHYplus PHY6222.cpu on 3333
Info : Listening on port 3333 for gdb connections
Info : Listening on port 4444 for telnet connections
Info : Listening on port 6666 for tcl connections
</pre>

---

**Summary:**  
You can debug with OpenOCD now, but cannot program flash without a custom driver. Use Keil/J-Link tools for flashing for now. If you want full OpenOCD support, you’ll need to investigate the flash controller and possibly write a driver—be aware of possible bootloader/security restrictions. UART is highly recommended for serial output and may be usable for flashing if supported by the bootloader. Document your findings as you go!