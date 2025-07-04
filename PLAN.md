# Porting & Bring-up Plan: pwrgrip-fw for PB-03 (PHYPLUS6252)

This plan tracks the porting, bring-up, and development of the pwrgrip-fw firmware for the PB-03 board (PHYPLUS6252 SoC), including hardware documentation, Zephyr porting, OpenOCD support, and application development.

---

## 0. **Hardware Documentation & Context**
- [x] Document PB-03 module (SoC, crystal, flash, etc.) and pinout ([pb-03.md](docs/overview/pb-03.md))
- [x] Document custom PCB: peripherals (USB-C, HX711, OLED, etc.), connections, and requirements ([pcb.md](docs/overview/pcb.md))
- [x] Record pin mappings between SoC/module and peripherals ([pcb.md](docs/overview/pcb.md))
- [x] Summarize power, mechanical, and component details ([pcb.md](docs/overview/pcb.md))
- [ ] Add schematic diagrams or references to docs

---

## 1. **OpenOCD Debug & Flashing Support**
- [x] Confirm SWD wiring and debug access (OpenOCD + CMSIS-DAP works, core detected)
- [x] Implement custom OpenOCD flash driver (`phyplus6252_flash.c`)
- [x] Implement OpenOCD target config (`phyplus6252.cfg`)
- [x] Update documentation on flashing/debugging ([flashing.md](docs/overview/flashing.md))
- [ ] **Test OpenOCD flash programming on real hardware**
- [ ] Document results, quirks, and update flashing.md as needed

---

## 2. **Minimal Buildable Zephyr Stub**
- [ ] Create new board definition for custom PCB under `boards/`
- [ ] Create new SoC definition for `phyplus6252` under `soc/`
- [ ] Add minimal DTS, Kconfig, and CMake files for board and SoC
- [ ] Integrate Keil SDK as a HAL module (stubbed as needed)
- [ ] Add minimal `main.c` that builds (empty main loop)
- [ ] Confirm build with `west build -b pb03` (or your board name)

---

## 3. **Initial Cleanup**
- [ ] Remove/archive old board/SoC files (MinShine, AT32, STM32, etc.)
- [ ] Clean up `west.yml` and other config files to remove unused modules

---

## 4. **Peripheral Bring-up (Reuse from FRUSDK Where Possible)**
- [x] Identify peripherals with compatible register maps (see [frusdk_physdk_comparison.md](docs/overview/frusdk_physdk_comparison.md))
- [ ] Port/adapt Zephyr drivers for I2C, WDT, SPI/SSI, DMA SW HANDSHAKE, etc.
- [ ] Integrate drivers into SoC/HAL layer for PHYPLUS6252
- [ ] Test each ported driver on hardware

---

## 5. **UART & Serial Debug**
- [ ] Add UART support in SoC and board files
- [ ] Implement "hello world" over UART
- [ ] Confirm serial output on hardware (requires soldering to module pins P9/P10)
- [ ] Document UART pin usage and any quirks in [pcb.md](docs/overview/pcb.md)

---

## 6. **GPIO, Board Bring-up, and Basic Peripherals**
- [ ] Add basic GPIO support (LEDs, buttons)
- [ ] Test toggling a pin or LED
- [ ] Integrate and test HX711 (load cell ADC)
- [ ] Integrate and test OLED display (I2C/SPI)
- [ ] Add any other peripherals (e.g., motor drivers, sensors)
- [ ] Document quirks or hardware-specific notes in `PLAN.md` or `NOTES.md`

---

## 7. **Application Layer**
- [ ] Implement main application logic (read HX711, display on OLED, etc.)
- [ ] Add command-line or UART-based debug interface if needed

---

## 8. **Testing, Flashing, and Documentation**
- [x] Add board bring-up and test instructions to `README.md`
- [x] Document flashing/debugging methods and status ([flashing.md](docs/overview/flashing.md))
- [x] Document any quirks or hardware-specific notes in `PLAN.md` or a new `NOTES.md`
- [ ] Update documentation as new features are tested or issues are found

---

## 9. **Cleanup, Maintenance, and Next Steps**
- [ ] Remove unused code and configs
- [ ] Tag a "minimal working" commit
- [ ] Plan next features or improvements (BLE OTA, power management, etc.)

---

## 10. **Documentation Status**

- [x] PHYPLUS6252 SoC datasheet (BLE 5.4, full memory map, pinout, electrical specs)
- [x] Application notes: peripherals, power management, security boot, GPIO, ADC, etc.
- [x] SDK structure and coverage ([phyplus6252_sdk.md](docs/overview/phyplus6252_sdk.md))
- [x] FRUSDK Zephyr HAL module and driver sources
- [x] PB-03 board schematic/datasheet (for pin mapping, external circuitry, board-specific features)
- [x] Custom PCB schematic/datasheet (for pin mapping, peripherals, etc.)
- [ ] (Optional) ARM Cortex-M0 Technical Reference Manual ([link](https://developer.arm.com/documentation/ddi0432/c/))

---

## 11. **References**
- [Zephyr Board Porting Guide](https://docs.zephyrproject.org/latest/hardware/porting/board_porting.html)
- [Zephyr SoC Porting Guide](https://docs.zephyrproject.org/latest/hardware/porting/soc_porting.html)
- [Zephyr HAL Integration](https://docs.zephyrproject.org/latest/hardware/porting/hal_porting.html)
- [FRUSDK Zephyr HAL module (Freqchip)](https://github.com/Freqchip/zephyr-hal-fr30xx)
- [PB-03 Module Overview](docs/overview/pb-03.md)
- [PCB Details](docs/overview/pcb.md)
- [PHYPLUS6252 SDK Breakdown](docs/overview/phyplus6252_sdk.md)
- [Flashing and Debugging](docs/overview/flashing.md)

---

**Tip:**  
Update this plan as you go! Check off items, add notes, and keep track of issues or discoveries.