#!/usr/bin/env bash
# setup.sh - Set up or update the pwrgrip-fw Zephyr development environment.
set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <workspace-path>"
    exit 1
fi

for cmd in python3 pip wget tar git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' is required but not installed."
        exit 1
    fi
done

WORKSPACE_PATH="$1"
REPO_URL="https://github.com/chgpalmer/pwrgrip-fw"
ZEPHYR_SDK_VERSION="0.16.8"
SDK_BASE_URL="https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}"

# --- OpenOCD settings ---
OPENOCD_REPO="https://github.com/chgpalmer/openocd.git"
OPENOCD_BRANCH="master"
OPENOCD_DIR="openocd"

UNAME_OUT="$(uname -s)"
case "${UNAME_OUT}" in
    Linux*)   SDK_FILENAME="zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64_minimal.tar.xz";;
    Darwin*)  SDK_FILENAME="zephyr-sdk-${ZEPHYR_SDK_VERSION}_macos-x86_64_minimal.tar.xz";;
    *)        echo "Unsupported OS: ${UNAME_OUT}"; exit 1;;
esac

mkdir -p "$WORKSPACE_PATH"

# Prompt if directory is not empty
if [ "$(ls -A "$WORKSPACE_PATH")" ]; then
    echo "Warning: The workspace directory '$WORKSPACE_PATH' is not empty."
    echo "Running this script will (re)initialize Zephyr and related files if missing."
    read -p "Continue setup in this directory? [y/N]: " yn
    case "$yn" in
        [Yy]*) echo "Continuing setup...";;
        *) echo "Aborting."; exit 1;;
    esac
fi

cd "$WORKSPACE_PATH"

# Set up Python virtual environment if missing
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi
source .venv/bin/activate

pip install --upgrade pip
pip install west

# Initialize west workspace if missing
if [ ! -d ".west" ]; then
    west init -m "$REPO_URL"
fi
west update

pip install -r zephyr/scripts/requirements.txt

# Download and extract Zephyr SDK if missing
if [ ! -d "zephyr-sdk-${ZEPHYR_SDK_VERSION}" ]; then
    wget -N "${SDK_BASE_URL}/${SDK_FILENAME}"
    tar xvf "${SDK_FILENAME}"
    rm -f "${SDK_FILENAME}"
    cd "zephyr-sdk-${ZEPHYR_SDK_VERSION}"
    ./setup.sh -t arm-zephyr-eabi -h -c
    cd ..
fi

# Clone and build OpenOCD with custom PHYPLUS6252 driver
if [ ! -d "$OPENOCD_DIR" ]; then
    git clone "$OPENOCD_REPO" "$OPENOCD_DIR"
    cd "$OPENOCD_DIR"
    git checkout "$OPENOCD_BRANCH"
    ./bootstrap
    ./configure --enable-cmsis-dap
    make -j$(nproc)
    cd ..
else
    echo "OpenOCD directory already exists, skipping clone/build."
fi

echo "Setup complete!"
echo "To start developing:"
echo "  source $WORKSPACE_PATH/.venv/bin/activate"
echo "  cd $WORKSPACE_PATH/pwrgrip-fw"
echo "  west build -p auto -b your_board_name"
echo ""
echo "To use your custom OpenOCD:"
echo "  $WORKSPACE_PATH/openocd/src/openocd -f interface/cmsis-dap.cfg -f target/phyplus6252.cfg"