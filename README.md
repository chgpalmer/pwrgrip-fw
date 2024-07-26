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

This can be radically reduced by trimming history and unused modules and toolchains. The following will be faster:
```
# Create workspace
mkdir -p path/to/workspace && cd path/to/workspace

# Install Zephyr's meta-tool "west"
python3 -m venv .venv
source .venv/bin/activate
pip install west

# Initiate workspace from this repository
west init -m https://github.com/chgpalmer/ebike-fw --mr main .

# Pull zephyr OS and modules
west update

# Zephyr CMake package
west zephyr-export

# Zephyr python dependencies
pip install -r ~/zephyrproject/zephyr/scripts/requirements.txt

# Install Zephyr SDK (ARM and host tools)
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.8/zephyr-sdk-0.16.8_linux-x86_64_minimal.tar.xz
tar xvf zephyr-sdk-0.16.8_linux-x86_64_minimal.tar.xz
cd zephyr-sdk-0.16.8
./setup.sh -t arm-zephyr-eabi -hc
```

### Development flow
Source the environment:
```
cd path/to/workspace
source .venv/bin/activate
cd ebike-fw
```

#### Build
```
west build --board stm32f411e_disco
```

#### Flash
```
west flash
```
