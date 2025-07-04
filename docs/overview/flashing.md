# Programming and Debugging the PB-03 (PHY6252) Board

This guide summarizes programming and debugging options for the PB-03 module (PHYPLUS6252 SoC), focusing on OpenOCD-based flashing and debug, with notes on UART and vendor tools.

---

## Overview

- **SWD pins** are available for ARM debug access.
- **OpenOCD** with a CMSIS-DAP adapter and `phyplus6252.cfg` target can connect and debug the Cortex-M0 core.
- **Custom OpenOCD flash driver (`phyplus6252_flash.c`) and target config (`phyplus6252.cfg`)** are implemented.
- **UART** (P9/P10) is available for serial console and possibly UART bootloader flashing.
- **Vendor tools** (Keil/J-Link with `.FLM`, Windows GUI) are the official methods for flashing/debugging.
- **BLE OTA** is possible after a bootloader is running.

---

## Internal Flash

- **Memory-mapped at:** `0x11000000~0x1107FFFF` (512KB).
- Accessed via the `AP_SPIF` peripheral using JEDEC SPI NOR commands (WREN, PP, SE, CE, RDID, etc.).
- SDK sources: `flash.c`, `flash.h`, `core_bumbee_m0.h`, `mcu_phy_bumbee.h`.

---

## Programming/Debugging Methods

| Method         | Debug | Flash | VS Code Integration | Notes                                 |
|----------------|-------|-------|---------------------|---------------------------------------|
| OpenOCD        | Yes   | Yes*  | Yes (Cortex-Debug)  | *Custom driver/config, under test     |
| Keil MDK/J-Link| Yes   | Yes   | Yes (via tasks)     | Use `.FLM` file                       |
| Vendor Tool    | No    | Yes   | Yes (via tasks)     | Windows only                          |
| UART Bootloader| No    | Yes   | Yes (via tasks)     | May need special boot pin/sequence    |
| BLE OTA        | No    | Yes   | No                  | Requires bootloader                   |

---

## OpenOCD Flashing: Status

- **Custom OpenOCD driver and config added.**
- Implements JEDEC SPI NOR command sequences.
- **Untested** on real hardware.

**Next Steps:**
1. Test the driver/config on hardware.
2. Verify probe, erase, program, and verify.
3. Document issues/quirks here.

---

## UART Flashing and Serial Output

- **UART (P9/P10):** For serial console and possibly bootloader flashing.
- Solder wires if not routed on PCB.

---

## Manufacturer-Intended Flashing

- **Keil MDK/J-Link:** Use `.FLM` file.
- **Vendor Windows Tool:** For SWD/UART flashing.
- **BLE OTA:** For updates after bootloader is running.

---

## File Reference

| File/Folder                                      | Purpose                                   |
|--------------------------------------------------|-------------------------------------------|
| phyplus6252_flash.c, phyplus6252.cfg             | Custom OpenOCD driver/config              |
| SDK flash.c, flash.h                             | Internal flash driver (reference)         |
| .FLM files                                       | Keil flash loader blobs                   |
| core_bumbee_m0.h, mcu_phy_bumbee.h               | SoC memory map, register structs          |

---

## Investigation: Why Flash Writes May Hang or Fail

**Observed:**
- OpenOCD can read flash (reads succeed).
- Flash contains non-blank data (likely factory firmware/bootloader).
- Write operations hang/fail and do not change flash.

**Possible Causes:**
- **Security Boot/Bootloader Lockdown:**  
  The PHY6252/6222 contains a ROM-based bootloader. On reset, the CPU starts from ROM, which checks efuse keys to determine if secure boot is enabled. If so, only encrypted/signed images matching the efuse keys will boot, and external programming may be blocked. Programming may require a special "programming mode" (see below). Once efuse keys are set, programming may be permanently locked out.
- **Programming Mode Not Enabled:**  
  Flash programming (including efuse and main flash writes/erases) is only allowed when the chip is in a special "programming mode." This mode is typically entered by holding the TM (Test Mode) pin low during reset or power-up. If the device is not in programming mode, the bootloader/security logic will block all external write/erase commands to protect firmware integrity. In this state, reads will still succeed, but all programming attempts will fail or hang. This cannot be bypassed via JTAG/SWD alone.
- **Flash Controller Initialization:**  
  The vendor SDK performs specific controller setup before writes/erases. Missing this in OpenOCD may block commands.
- **Write Protection:**  
  Hardware or efuse-level protection may still be active even after unlock commands.
- **Timeouts/Status Polling:**  
  If the controller is locked or busy, status polling may hang.

**Boot ROM and Security:**
- The ROM bootloader verifies and decrypts firmware in the "FW Storage" region of flash, based on efuse configuration.
- If efuse security is enabled, only valid encrypted/signed images will boot. There is no documented way to bypass this check in hardware.
- If efuse security is not enabled, the ROM may allow plain images to boot (depends on chip state).

**Next Steps:**
- Check if the device is in programming mode (see datasheet/security boot doc; usually TM pin low at reset).
- Verify efuse/bootloader protection status with vendor tools.
- Ensure OpenOCD driver matches vendor’s controller init and unlock/lock sequence.
- Add debug logging to observe command execution/status.
- Use vendor tools to erase/unlock if possible.

**Reference:**  
See "PHY6252/6222 Security Boot User Guide v1.0" for efuse programming, security boot, and flash mapping.

**Note:**  
Reads always succeed, but writes may be blocked by security features or controller state. Further investigation is needed to determine if the device is locked, needs special initialization, or must be in a specific mode for programming.

---

**SoC Datasheet Notes:**
- The PHY6252 datasheet confirms a 96KB Boot ROM at 0x10000000, which runs at power-on and checks flash validity and efuse security settings.
- The chip includes a 256-bit efuse for storing security keys and configuration, which the ROM checks at boot to enforce secure boot and flash access policies.
- Internal flash is mapped at 0x11000000–0x1107FFFF (512KB).
- The bootloader can enter a "programming mode" at boot (see Security Boot User Guide for TM pin details); this is required for any flash or efuse programming.
- If efuse security is enabled, only valid encrypted/signed images will boot, and flash writes may be permanently locked out. There is no documented way to bypass this in hardware.

---

**Summary:**  
A custom OpenOCD flash driver and target config are implemented and ready for testing. Next step: test flashing on hardware and document results/issues.

---

**Security Boot Process (from Security Boot User Guide):**
- The chip checks the TM pin at reset:
  - **TM = 1:** Enters programming/debug mode, allowing flash and efuse programming via vendor tools or JTAG/SWD.
  - **TM = 0:** Enters normal boot mode; only reads are allowed, and all writes/erases are blocked.
- On normal boot, the ROM:
  - Reads efuse to determine if secure boot is enabled.
  - If enabled, verifies firmware integrity (MIC check) before booting the application.
  - If verification fails or the image is not valid, boot is aborted.
- There is no documented way to bypass secure boot or write to flash/efuse without entering programming mode via the TM pin.
