# Porting Plan: pwrgrip-fw for pb-03 (PHYPLUS6252)

This document outlines the step-by-step plan for porting and developing the pwrgrip-fw firmware for the pb-03 board (PHYPLUS6252 SoC).

---

## 0. **Document Hardware Context**
- [ ] Document the pb03 module (SoC, crystal, flash, etc.) and its pinout.
- [ ] Document your custom PCB: all peripherals (USB-C, HX711, OLED, etc.), connections, and any special requirements.
- [ ] Record pin mappings between the SoC/module and your peripherals.
- [ ] Use `docs/pcb.md` for this documentation (see scaffold below).

---

## 1. **Minimal Buildable Stub**
- [ ] Create a new board definition for your custom PCB (e.g., `my_pcb`) under `boards/`
- [ ] Create a new SoC definition for `phyplus6252` under `soc/`
- [ ] Add minimal DTS, Kconfig, and CMake files for board and SoC
- [ ] Integrate the Keil SDK as a HAL module (stub out as needed)
- [ ] Add a minimal `main.c` that just builds (e.g., empty main loop)
- [ ] Confirm you can build with `west build -b my_pcb`

---

## 2. **Initial Cleanup**
- [ ] Remove or archive old board/SoC files (MinShine, AT32, STM32, etc.)
- [ ] Clean up `west.yml` and other config files to remove unused modules

---

## 3. **Leverage Existing Zephyr Peripheral Drivers from FRUSDK**
- [ ] Identify peripherals present in both PHY6252 and Freqchip (FRUSDK) SoCs (see `frusdk_physdk_comparison.md`)
- [ ] For peripherals with confirmed compatible register maps (e.g., I2C, WDT, SPI/SSI, DMA SW HANDSHAKE), copy/adapt Zephyr drivers from the `hal_freqchip` Zephyr module repo
- [ ] Integrate these drivers into the new SoC/HAL layer for PHYPLUS6252
- [ ] Test each ported driver on your custom PCB hardware

---

## 4. **Basic UART Support**
- [ ] Add UART support in SoC and board files (use Zephyr or port from FRUSDK if compatible)
- [ ] Implement a simple "hello world" over UART
- [ ] Confirm serial output works on real hardware

---

## 5. **GPIO and Board Bring-up**
- [ ] Add basic GPIO support (LEDs, buttons if present)
- [ ] Test toggling a pin or LED

---

## 6. **Peripheral Support**
- [ ] Add/port SPI/I2C support in SoC and board files (reuse FRUSDK Zephyr modules where possible)
- [ ] Integrate and test HX711 (load cell ADC)
- [ ] Integrate and test OLED display (I2C/SPI)
- [ ] Add any other peripherals (e.g., motor drivers, sensors)

---

## 7. **Application Layer**
- [ ] Implement main application logic (read HX711, display on OLED, etc.)
- [ ] Add command-line or UART-based debug interface if needed

---

## 8. **Testing and Documentation**
- [ ] Add board bring-up and test instructions to `README.md`
- [ ] Document any quirks or hardware-specific notes in `PLAN.md` or a new `NOTES.md`

---

## 9. **Cleanup and Maintenance**
- [ ] Remove unused code and configs
- [ ] Tag a "minimal working" commit
- [ ] Plan next features or improvements

---

## Documentation Status

- [x] PHYPLUS6252 SoC datasheet (BLE 5.4, full memory map, pinout, electrical specs)
- [x] Application notes: peripherals, power management, security boot, GPIO, ADC, etc.
- [x] SDK structure and coverage (`phyplus6252_sdk.md`)
- [x] FRUSDK Zephyr HAL module and driver sources
- [ ] **PB-03 board schematic/datasheet** (needed for pin mapping, external circuitry, board-specific features)
- [ ] **Custom PCB schematic/datasheet** (needed for pin mapping, peripherals, etc.)
- [ ] (Optional) ARM Cortex-M0 Technical Reference Manual ([link](https://developer.arm.com/documentation/ddi0432/c/))

**Action:**
- Try to obtain the PB-03 module and custom PCB schematics/datasheets.
- If not available, document any pin mapping or board quirks you discover during bring-up in `docs/pcb.md`, `PLAN.md`, or a new `NOTES.md`.

---

## References
- [Zephyr Board Porting Guide](https://docs.zephyrproject.org/latest/hardware/porting/board_porting.html)
- [Zephyr SoC Porting Guide](https://docs.zephyrproject.org/latest/hardware/porting/soc_porting.html)
- [Zephyr HAL Integration](https://docs.zephyrproject.org/latest/hardware/porting/hal_porting.html)
- [FRUSDK Zephyr HAL module (Freqchip)](https://github.com/Freqchip/zephyr-hal-fr30xx) <!-- update with actual repo if needed -->

---

**Tip:**  
Update this plan as you go! Check off items, add notes, and keep track of issues or discoveries.