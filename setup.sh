#!/usr/bin/env bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <workspace-path>"
    exit 1
fi

WORKSPACE_PATH="$1"
REPO_URL="https://github.com/chgpalmer/ebike-fw"
ZEPHYR_SDK_VERSION="0.16.8"
SDK_BASE_URL="https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}"
SDK_FILENAME="zephyr-sdk-${ZEPHYR_SDK_VERSION}_macos-x86_64_minimal.tar.xz"

# Prevent running inside a git clone of the repo
if [ -f "west.yml" ] && [ -d ".git" ]; then
    echo "Error: Do not run setup.sh from inside a git clone of the repository."
    echo "Instead, run it from a separate directory, e.g.:"
    echo "  mkdir my-workspace && ./setup.sh my-workspace"
    exit 1
fi

# Check if workspace exists and is non-empty
if [ -d "$WORKSPACE_PATH" ] && [ "$(ls -A "$WORKSPACE_PATH")" ]; then
    echo "Error: The workspace directory '$WORKSPACE_PATH' already exists and is not empty."
    echo "Please choose an empty or new directory."
    exit 1
fi

# Create workspace directory
mkdir -p "$WORKSPACE_PATH"
cd "$WORKSPACE_PATH"

# Set up Python virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install west
pip install --upgrade pip
pip install west

# Initialize and update west workspace
west init -m "$REPO_URL"
west update

# Install Zephyr Python requirements
pip install -r zephyr/scripts/requirements.txt

# Download and extract Zephyr SDK (macOS minimal version)
if [ ! -d "zephyr-sdk-${ZEPHYR_SDK_VERSION}" ]; then
    curl -LO "${SDK_BASE_URL}/${SDK_FILENAME}"
    tar xvf "${SDK_FILENAME}"
    rm "${SDK_FILENAME}"
    cd "zephyr-sdk-${ZEPHYR_SDK_VERSION}"
    ./setup.sh -t arm-zephyr-eabi -hc
    cd ..
fi

echo "Setup complete!"
echo "To start developing:"
echo "  source $WORKSPACE_PATH/.venv/bin/activate"
echo "  cd $WORKSPACE_PATH/ebike-fw"
echo "  west build -p auto -b your_board_name"
