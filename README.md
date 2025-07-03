# Electric Bike Controller Firmware

eBike controller firmware for To7 DM-02 motor controller boards. These boards use an ARTERY AT32F413CBT7 SOC:
* 32-bit ARM Cortex-M4 core with FPU. For more details see https://www.arterychip.com/en/product/AT32F413.jsp

## Status: Pre-alpha

### Stage 1. Board support
- [x] Skeleton zephyr project that builds helloworld
- [ ] Import AT32 HAL + flashing tools into Zephyr module
- [ ] Add AT32 driver shims (Flash, pwm, ..?) + bindings
- [ ] Add AT32F413 SoC (dts, Kconfig, CMakeLists.txt)
- [ ] Add MinShine board (dts, runners)
- [ ] Helloworld on hardware

### Stage 2. eBike app
- [ ] ...

## Dependencies
* cmake
* python3 (and various python packages)
* Zephyr OS and Zephyr SDK

## Quick Setup

To set up your workspace automatically, just run:

```sh
wget https://raw.githubusercontent.com/chgpalmer/pwrgrip-fw/main/setup.sh
chmod +x setup.sh
./setup.sh my-workspace
rm setup.sh
```

Replace `my-workspace` with your desired workspace directory name.

This script will:
- Create the workspace directory
- Set up a Python virtual environment
- Install west and Zephyr dependencies
- Download and set up the Zephyr SDK (macOS minimal version)
- Initialize the project

**Tip:** For VS Code users, install the "C/C++", "CMake Tools", and "GitHub Copilot" extensions for the best experience.

> **Note:**
> You can safely re-run `setup.sh` in an existing workspace to update or repair your environment.
> If the directory is not empty, you will be prompted before continuing.

---

### Development flow

Source the environment:
```sh
cd path/to/my-workspace
source .venv/bin/activate
cd pwrgrip-fw
```

#### Build
```sh
west build -b stm32f411e_disco
```

#### Flash
```sh
west flash
```

---

### macOS Troubleshooting

If you see an error about `libunistring` or `wget` when installing the Zephyr SDK, run:
```sh
brew install libunistring wget
```

**Notes:**
- `west zephyr-export` is only needed if you build with CMake directly, not with `west build`.
- Adjust SDK download links for your OS (Linux/macOS) if needed.
- For IDE features like code navigation, ensure `compile_commands.json` is generated (Zephyr does this by default).
