# PHYPLUS6252 SDK Breakdown (`phyplus_sdk.md`)

This document distills the PHYPLUS6252 SDK to guide a Zephyr RTOS port, especially when source access may be limited. It highlights SDK structure, critical gaps, and actionable steps for SoC bring-up.

---

## 1. Quick Start for Zephyr Port

- **Essential Steps:**
  - Identify SoC variant and obtain all datasheets/reference manuals.
  - Extract register maps, memory map, and pinmux from SDK headers and application notes.
  - Create Zephyr SoC definition (arch, memory, startup, vector table).
  - Write Zephyr device tree and board files using SDK and datasheet as reference.
  - Port or stub drivers for UART, GPIO, timers, etc., using Zephyr APIs.
  - Use Zephyr BLE/Mesh stacks; port only application/profile logic from SDK.
  - Validate each subsystem with Zephyr sample apps.

---

## 2. Critical Gaps / Must-Have Information

- Full SoC memory map and peripheral register definitions.
- Pinout, alternate functions, and pinmux configuration.
- Clock sources, PLL, and clock tree.
- Power domains, sleep modes, and wakeup sources.
- Interrupt controller details.
- Boot sequence, reset behavior, and flash programming.
- Electrical specs (voltages, currents, timing).
- Any undocumented peripherals or errata.

**If not present in SDK, these must be sourced from datasheets or application notes.**

---

## 3. SDK Structure Overview

```
phy6222_v313_0512/
  components/
    arch/
    ble/
    common/
    driver/
    ethermind/
    inc/
    libraries/
    osal/
    profiles/
    ...
  example/
  lib/
  misc/
  release_note.md
PHY62XX_3.x.x_ANS/
phypluskit_v2.5.2b/
```

---

## 4. Known Issues/Quirks

- Some SDK drivers may not handle all error conditions or edge cases.
- Certain features (e.g., low-power modes, DMA) may be partially implemented or undocumented.
- Precompiled libraries may not be portable across toolchains.
- Some peripherals may have undocumented registers or errata (see application notes).

---

## 5. Flashing/Debugging

- **SDK Tools:**  
  - May include proprietary flashing tools or scripts.
  - Some support for Keil ULINK, J-Link, or PHYPLUS-specific tools.
- **Open Tools:**  
  - Check for OpenOCD or pyOCD support for the PHYPLUS6252.
  - If not supported, custom scripts or vendor tools may be required.
- **Debug Interface:**  
  - Typically SWD (Serial Wire Debug).
  - Pinout and connection details should be confirmed in the datasheet (see Section 2).

---

## 6. Build System

- **SDK Build System:**  
  - Uses Makefiles, Keil projects, and possibly IAR projects.
  - Toolchain-specific startup files and linker scripts are present.
- **Zephyr Build System:**  
  - Uses CMake and west.
  - Migration will require creating CMakeLists.txt and Kconfig files, and adapting to Zephyr’s build conventions.

---

## 7. Key SDK Components

### 7.1. `components/`

#### - `arch/`
Architecture-specific code (e.g., Cortex-M0).  
**Zephyr port:** Replace with Zephyr's SoC/arch abstraction.

#### - `ble/`
Bluetooth Low Energy stack (controller, host, HCI, profiles).  
- `controller/`, `host/`, `hci/`, `include/`
**Zephyr port:** Zephyr has its own BLE stack (NimBLE or Zephyr BLE). Porting will require mapping application logic and profiles.

#### - `common/`
Common utilities and definitions.

#### - `driver/`
Peripheral drivers:
- `uart/`, `gpio/`, `pwm/`, `flash/`, `timer/`, `watchdog/`, `kscan/`, `i2c/`, `dma/`, `spiflash/`, `led_light/`, `key/`, `log/`, `clock/`, `pwrmgr/`, `adc/`, `voice/`, `bsp_button/`
**Zephyr port:**  
- Replace with Zephyr's device drivers and APIs.
- Use as reference for hardware register mappings and initialization sequences.
- **See Section 2 for datasheet requirements.**

#### - `ethermind/`
Bluetooth Mesh stack (Ethermind), cryptography, mesh platform, OSAL for mesh, utilities.
- `mesh/`, `platforms/`, `external/crypto/`, `osal/`, `utils/`
**Zephyr port:**  
- Zephyr has its own mesh stack; porting may require adapting mesh application logic.
- Crypto: Zephyr provides its own crypto APIs.

#### - `inc/`
Common header files, version info, chip defines.

#### - `libraries/`
Utility libraries:
- `crc16/`, `fs/`, `cli/`, `console/`, `datetime/`
**Zephyr port:**  
- Zephyr has its own filesystem, CLI, and utility libraries.

#### - `osal/`
OS Abstraction Layer for portability.
**Zephyr port:**  
- Replace with Zephyr kernel APIs (threads, timers, events, queues).

#### - `profiles/`
BLE profiles and roles:
- `Roles/` (GAP, GATT, Peripheral, Central, Observer, Bond Manager)
- `SimpleProfile/`, `DevInfo/`, `Keys/`, `ota_app/`, `multiRole/`, `phy_plus_phy/`, `ppsp/`, `ScanParam/`, `Batt/`, `HID/`, `HIDVoice/`
**Zephyr port:**  
- Zephyr provides some standard profiles; custom/proprietary profiles will need to be ported.

---

### 7.2. `example/`

Reference applications and demos:
- `ble_mesh/` (mesh_switch, mesh_light, mesh_gateway, mesh_friend, mesh_lpn, mesh_multiconn, aliGenie_bleMesh variants)
- `ble_peripheral/` (simpleBlePeripheral, pwmLight, HIDKeyboard, HIDAdvRemote, sbpMultiConn, sbpSmartRF, sbpSmart_nRF, ppsp_demo, extBlePeripheral, bleUart_AT)
- `ble_central/` (simpleBleCentral, sbcMultiConn, extBleCentral)
- `ble_multi/` (simpleBleMultiConnection, ble_at)
- `OTA/` (otadongle, slboot)
- `peripheral/` (adc, gpio, timer, fs, spiflash, dmac, bsp_btn, watchdog, i2c)
- `PhyPlusPhy/` (proprietary PHY examples)

**Zephyr port:**  
- Use as reference for feature validation and porting.
- Application logic may need significant adaptation to Zephyr's APIs and build system.

---

### 7.3. `lib/`

Precompiled libraries (e.g., `rf.lib`, `ble_host.lib`).  
**Zephyr port:**  
- Source code is preferred for portability. If only binaries are available, porting may be limited.

---

### 7.4. `misc/`

Miscellaneous files (e.g., `jump_table.c`).

---

### 7.5. `PHY62XX_3.x.x_ANS/`

Application notes and documentation (PDFs):
- ADC, GPIO, Mesh, Peripheral, Power Management, Security Boot, BSP Button, etc.

**Zephyr port:**  
- **See Section 2 for datasheet requirements.**

---

### 7.6. `phypluskit_v2.5.2b/`

Additional tools/utilities (contents not fully listed).

---

## 8. Peripheral Coverage Table

| Peripheral | SDK Driver | Source/Binary | Zephyr Driver Exists | Notes |
|------------|------------|---------------|----------------------|-------|
| UART       | Yes        | Source        | Yes                  | Use Zephyr API |
| SPI        | Yes        | Source        | Yes                  | Use Zephyr API |
| I2C        | Yes        | Source        | Yes                  | Use Zephyr API |
| GPIO       | Yes        | Source        | Yes                  | Use Zephyr API |
| ADC        | Yes        | Source        | Yes                  | Use Zephyr API |
| PWM        | Yes        | Source        | Yes                  | Use Zephyr API |
| BLE        | Yes        | Binary        | Yes                  | Use Zephyr BLE stack |
| Mesh       | Yes        | Source        | Yes                  | Use Zephyr Mesh stack |
| Watchdog   | Yes        | Source        | Yes                  | Use Zephyr API |
| DMA        | Yes        | Source        | Yes                  | Use Zephyr API |
| Flash      | Yes        | Source        | Yes                  | Use Zephyr API |
| Others     | Varies     | Source/Binary | Varies               | Check individually |

---

## 9. Validation & Testing

For each ported peripheral or subsystem, plan to validate with simple tests and Zephyr samples:
- UART: Loopback test (TX to RX), Zephyr `samples/drivers/uart`
- GPIO: Toggle output, read input, Zephyr `samples/basic/blinky`
- I2C/SPI: Communicate with known slave device or loopback, Zephyr `samples/drivers/i2c`/`spi`
- ADC: Read known voltage or use test input, Zephyr `samples/drivers/adc`
- Timer/PWM: Output waveform and measure frequency/duty, Zephyr `samples/drivers/pwm`
- BLE: Connect with standard BLE central/peripheral, run GATT tests, Zephyr `samples/bluetooth/peripheral`
- Mesh: Join mesh network, send/receive messages, Zephyr `samples/bluetooth/mesh`

---

## 10. Device Tree & SoC Integration

- Zephyr requires device tree files describing SoC peripherals and board layout.
- Use SDK header files (in `components/inc/`) and datasheet to define base addresses, IRQs, and pinmux.
- Create or adapt Zephyr SoC and board files (`soc.c`, `Kconfig.soc`, `dts`).
- Reference Zephyr upstream SoC ports for structure.

---

## 11. Toolchain/Compiler Notes

- **Supported Toolchains:**  
  The SDK provides support for Keil (ARMCC), GCC (GNU Arm Embedded), and IAR Embedded Workbench.  
  - Project files for Keil (`.uvprojx`), GCC Makefiles, and IAR (`.ewp`) may be present.
- **Binary Blobs:**  
  Some libraries (e.g., `rf.lib`, `ble_host.lib`) are provided as precompiled binaries, typically for ARMCC/Keil.  
  - These may not be compatible with GCC or IAR.
  - Source code is preferred for Zephyr integration.
- **Quirks:**  
  - Some startup files or linker scripts may be toolchain-specific.
  - Check for toolchain-specific pragmas or inline assembly.

---

## 12. Licensing/Redistribution

- **License:**  
  The SDK’s license is not always clearly stated.  
  - If redistributing or integrating with Zephyr (which is Apache 2.0), ensure all code is compatible.
  - Binary-only libraries may restrict redistribution or modification.
- **Recommendation:**  
  - Clarify licensing with PHYPLUS or your vendor before open-source release.

---

## 13. Example: Peripheral Register Mapping

If you have mapped a peripheral (e.g., UART) to Zephyr, document the mapping:

```c
// SDK UART register access (example)
#define UART0_BASE 0x40004000
#define UART0_DR   (*(volatile uint32_t *)(UART0_BASE + 0x00))

// Zephyr device tree (example)
uart0: uart@40004000 {
    compatible = "phyplus,phy6222-uart";
    reg = <0x40004000 0x1000>;
    status = "okay";
};
```

- **Reference:**  
  - Use SDK header files and datasheet to define Zephyr’s device tree and driver register offsets.

---

## 14. Reverse Engineering Tips

- Use CMSIS headers and any available SVD files to extract register and peripheral info.
- Compare SDK header files with Zephyr SoC ports for similar ARM Cortex-M0 devices.
- Application notes in `PHY62XX_3.x.x_ANS/` often contain register maps, pinouts, and usage examples.
- If only binaries are available, use disassembly tools to infer register usage.

---

## 15. Open Questions / Blockers

- Are all peripheral register definitions available in the SDK, or are some only in the datasheet?
- Are there any undocumented peripherals or errata not covered in the SDK or application notes?
- Is there a public/open-source license for all SDK components required for Zephyr integration?
- Are there open tools for flashing/debugging, or is vendor tooling required?
- What is the minimum viable set of features for initial Zephyr bring-up?

---

## 16. Glossary

- **SoC:** System on Chip
- **CMSIS:** Cortex Microcontroller Software Interface Standard
- **SVD:** System View Description (XML format for peripheral/register info)
- **OSAL:** OS Abstraction Layer
- **BSP:** Board Support Package

---

## 17. Change Log

- **2024-06-XX:** Major restructuring for Zephyr porting focus, added peripheral coverage table, device tree notes, and reverse engineering tips.

---

## 18. Datasheet/Manual Links

- **PHYPLUS6252 Datasheet:**  
  - [PHYPLUS Official Website](https://www.phyplusinc.com/) (registration may be required)
  - [PHY62XX Series Documentation](https://www.phyplusinc.com/en/download/)
- **Reference Manuals:**  
  - Check `PHY62XX_3.x.x_ANS/` for application notes and hardware guides.
- **Community Resources:**  
  - [Zephyr Project Documentation](https://docs.zephyrproject.org/latest/)
  - [NimBLE BLE Stack](https://github.com/apache/mynewt-nimble)

---

**Note:**  
This SDK is a good reference for hardware initialization and application logic, but a full Zephyr port will require significant work, especially for low-level hardware abstraction and integration with Zephyr's build and runtime model. Always cross-reference with the official datasheet and reference manual for the PHYPLUS6252.
