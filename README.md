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

## Workflow

### Setup flow

The [Zephyr Getting Started Guide](https://docs.zephyrproject.org/latest/develop/getting_started/index.html) pulls in Zephyr with all its history (1GB), all modules (4.5GB), and all toolchains (XGB).

This can be radically reduced by trimming history and unused modules/toolchains. The following is a faster, minimal setup:

```sh
# Go to your workspace root
cd ~/workspaces/

# Create workspace, download repository and Zephyr dependencies
mkdir -p ebike-fw-workspace && cd ebike-fw-workspace
python3 -m venv .venv
source .venv/bin/activate
pip install west
west init -m https://github.com/chgpalmer/ebike-fw  # download this repository
west update                                         # download Zephyr OS and modules
pip install -r zephyr/scripts/requirements.txt

# Install Zephyr SDK (choose the correct version for your OS)
# For macOS:
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.8/zephyr-sdk-0.16.8_macos-x86_64_minimal.tar.xz
tar xvf zephyr-sdk-0.16.8_macos-x86_64_minimal.tar.xz
cd zephyr-sdk-0.16.8
./setup.sh -t arm-zephyr-eabi -hc
```

**Tip:** For VS Code users, install the "C/C++", "CMake Tools", and "GitHub Copilot" extensions for the best experience.

---

### Development flow

Source the environment:
```sh
cd path/to/ebike-fw-workspace
source .venv/bin/activate
cd ebike-fw
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

**Notes:**
- `west zephyr-export` is only needed if you build with CMake directly, not with `west build`.
- Adjust SDK download links for your OS (Linux/macOS).
- For IDE features like code navigation, ensure `compile_commands.json` is generated (Zephyr does this by default).
