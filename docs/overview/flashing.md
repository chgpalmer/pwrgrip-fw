# Programming and Debugging the PB-03 (PHY6252) Board

This guide summarizes the current state and options for programming and debugging the PB-03 module (PHYPLUS6252 SoC), with a focus on enabling OpenOCD-based flashing and debug, but also covering UART and vendor tools.

---

## Overview

- **SWD (SIO/SDT) pins** are connected on the PCB for ARM debug access.
- **OpenOCD** with a CMSIS-DAP adapter and the `phyplus6252.cfg` target can connect and debug the ARM Cortex-M0 core.  
- **A custom OpenOCD flash driver (`phyplus6252_flash.c`) and target config (`phyplus6252.cfg`) have been implemented and added to the OpenOCD fork.**  
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
| **OpenOCD**        | Yes   | Yes*  | Yes (Cortex-Debug)  | *Custom flash driver and target config implemented, untested |
| **Keil MDK/J-Link**| Yes   | Yes   | Yes (via tasks)     | Use provided `.FLM` file              |
| **Vendor Tool**    | No    | Yes   | Yes (via tasks)     | Windows only, less integrated         |
| **UART Bootloader**| No    | Yes   | Yes (via tasks)     | May require special boot pin/sequence |
| **BLE OTA**        | No    | Yes   | No                  | Requires working bootloader           |

---

## OpenOCD Flashing: Status and Next Steps

### Current Status

- **A custom OpenOCD flash driver (`phyplus6252_flash.c`) and target config (`phyplus6252.cfg`) have been added to the OpenOCD fork.**
- The driver implements JEDEC SPI NOR command sequences as per the SDK.
- The driver and config are **untested** on real hardware.

### Next Steps

1. **Test the new OpenOCD flash driver and target config on real hardware.**
2. Verify that flash probe, erase, program, and verify operations work as expected.
3. Document any issues, quirks, or required changes in this file.
4. Update the table above and recommendations as results come in.

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
| openocd/src/flash/nor/phyplus6252_flash.c                                   | Custom OpenOCD flash driver for PHYPLUS6252           |
| openocd/src/target/phyplus6252.cfg                                          | OpenOCD target config for PHYPLUS6252                 |
| phy6252-SDK/components/driver/spiflash/                                     | External SPI flash (not for code)                     |
| hal_freqchip/fr30xx_c/components/drivers/peripheral/Inc/driver_flash.h      | Freqchip internal flash driver (compare for compatibility) |
| core_bumbee_m0.h, mcu_phy_bumbee.h                                         | SoC memory map, peripheral base addresses, register structs |
| .FLM files                                                                  | Keil flash loader blobs (not usable by OpenOCD, but confirm algorithm) |

---

## Recommendations

- **Short Term:**  
  Use Keil/J-Link tools for flashing and debugging if OpenOCD flashing is not yet working. Integrate with VS Code using tasks or scripts. Use OpenOCD for RAM debugging only if flash programming fails.
- **Medium Term:**  
  Test and debug the new OpenOCD flash driver and target config. Update this document with results and any required fixes.
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
$ ./src/openocd -s tcl -f interface/cmsis-dap.cfg -f target/phyplus6252.cfg
Open On-Chip Debugger 0.12.0+dev-g9737f0740 (2025-07-04-19:28)
Licensed under GNU GPL v2
For bug reports, read
        http://openocd.org/doc/doxygen/bugs.html
Warn : DEPRECATED: auto-selecting transport "swd". Use 'transport select swd' to suppress this message.
Warn : Transport "swd" was already selected
none separate
Info : Listening on port 6666 for tcl connections
Info : Listening on port 4444 for telnet connections
Info : Using CMSIS-DAPv2 interface with VID:PID=0x0d28:0x0204, serial=00000080002900773900000e4e54514aa5a5a5a597969908
Info : CMSIS-DAP: SWD supported
Info : CMSIS-DAP: SWO-UART supported
Info : CMSIS-DAP: Atomic commands supported
Info : CMSIS-DAP: Test domain timer supported
Info : CMSIS-DAP: FW Version = 2.1.0
Info : CMSIS-DAP: Serial# = 00000080002900773900000e4e54514aa5a5a5a597969908
Info : CMSIS-DAP: Interface Initialised (SWD)
Info : SWCLK/TCK = 1 SWDIO/TMS = 1 TDI = 0 TDO = 0 nTRST = 0 nRESET = 1
Info : CMSIS-DAP: Interface ready
Info : clock speed 1000 kHz
Info : SWD DPIDR 0x0bb11477
Info : [phyplus6252.cpu] Cortex-M0 r0p0 processor detected
Info : [phyplus6252.cpu] target has 4 breakpoints, 2 watchpoints
Info : [phyplus6252.cpu] Examination succeed
Info : [phyplus6252.cpu] starting gdb server on 3333
Info : Listening on port 3333 for gdb connections
</pre>

---

**Summary:**  
A custom OpenOCD flash driver and target config are now implemented and ready for testing. The next step is to test flashing on real hardware and document the results and any issues