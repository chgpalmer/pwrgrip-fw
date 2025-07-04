#!/usr/bin/env bash
# setup.sh - Set up or update the pwrgrip-fw Zephyr development environment.
set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <workspace-path>"
    exit 1
fi

print_header() {
    local msg="$1"
    echo
    echo "========== $msg =========="
}

# Function to run commands and handle output
run_cmd() {
    local cmd_str="${*}"
    if [ ${#cmd_str} -gt 60 ]; then
        cmd_str="${cmd_str:0:57}..."
    fi
    # Print command, but don't add newline yet
    echo -n "  $cmd_str"
    local tmpfile
    tmpfile=$(mktemp)
    # Run command, capture all output
    if "$@" >"$tmpfile" 2>&1; then
        printf " %*s[\033[0;32mOK\033[0m]\n" $((60 - ${#cmd_str})) ""
    else
        printf " %*s[\033[0;31mFAIL\033[0m]\n" $((60 - ${#cmd_str})) ""
        echo "---- Command output ----"
        cat "$tmpfile"
        rm -f "$tmpfile"
        return 1
    fi
    rm -f "$tmpfile"
}

WORKSPACE_PATH=`realpath "$1"`
REPO_URL="https://github.com/chgpalmer/pwrgrip-fw"
ZEPHYR_SDK_VERSION="0.16.8"
SDK_BASE_URL="https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}"

OPENOCD_REPO="https://github.com/chgpalmer/openocd.git"
OPENOCD_BRANCH="phyplus6252"
OPENOCD_DIR="openocd"
NPROC=$(command -v nproc >/dev/null 2>&1 && nproc || sysctl -n hw.ncpu)

UNAME_OUT="$(uname -s)"
case "${UNAME_OUT}" in
    Linux*)   SDK_FILENAME="zephyr-sdk-${ZEPHYR_SDK_VERSION}_linux-x86_64_minimal.tar.xz";;
    Darwin*)  SDK_FILENAME="zephyr-sdk-${ZEPHYR_SDK_VERSION}_macos-x86_64_minimal.tar.xz";;
    *)        echo "Unsupported OS: ${UNAME_OUT}"; exit 1;;
esac

mkdir -p "$WORKSPACE_PATH"

# Prompt if directory is not empty (excluding expected items)
if ls -A1 | grep -vE "(setup.sh|.venv|.west|zephyr|pwrgrip-fw|openocd|modules)"; then
    echo "Workspace is not empty, running this script will setup any missing project files."
    ls -1 "$WORKSPACE_PATH" | xargs -I {} echo "  - {}"
    read -p "Continue setup in $WORKSPACE_PATH? [y/N]: " yn
    case "$yn" in
        [Yy]*) echo "Continuing setup...";;
        *) echo "Aborting."; exit 1;;
    esac
fi

cd "$WORKSPACE_PATH"

# --- Cleanup logic ---
CURRENT_SETUP_DIR=""
cleanup_on_exit() {
    cd "$WORKSPACE_PATH"
    if [ -n "$CURRENT_SETUP_DIR" ] && [ -d "$CURRENT_SETUP_DIR" ]; then
        echo "Cleaning up incomplete directory: $CURRENT_SETUP_DIR"
        rm -rf -- "$CURRENT_SETUP_DIR"
    fi
}
trap cleanup_on_exit EXIT

# --- Python virtual environment setup ---
print_header "Setting up Python virtual environment..."
if [ ! -d ".venv" ]; then
    run_cmd python3 -m venv .venv
fi
source .venv/bin/activate

# --- Python dependencies ---
print_header "Installing Python dependencies..."
run_cmd pip install --upgrade pip
run_cmd pip install west

# --- Zephyr west workspace setup ---
print_header "Initializing Zephyr west workspace..."
if [ ! -d ".west" ]; then
    CURRENT_SETUP_DIR=".west"
    run_cmd west init -m "$REPO_URL"
    west update
    CURRENT_SETUP_DIR=""
fi
# --- Zephyr west workspace setup ---

print_header "Installing zephyr dependencies..."
run_cmd pip install -r zephyr/scripts/requirements.txt

# --- Zephyr SDK setup ---
print_header "Building Zephyr SDK..."
if [ ! -d "zephyr-sdk-${ZEPHYR_SDK_VERSION}" ]; then
    CURRENT_SETUP_DIR="zephyr-sdk-${ZEPHYR_SDK_VERSION}"
    run_cmd wget -N "${SDK_BASE_URL}/${SDK_FILENAME}"
    run_cmd tar xvf "${SDK_FILENAME}"
    run_cmd rm -f "${SDK_FILENAME}"
    cd "zephyr-sdk-${ZEPHYR_SDK_VERSION}"
    run_cmd ./setup.sh -t arm-zephyr-eabi -h -c
    cd ..
fi

# --- OpenOCD build ---
print_header "Building custom OpenOCD..."
if [ ! -d "$OPENOCD_DIR" ]; then
    CURRENT_SETUP_DIR="$OPENOCD_DIR"
    run_cmd git clone "$OPENOCD_REPO" "$OPENOCD_DIR"
    cd "$OPENOCD_DIR"
    run_cmd git checkout "$OPENOCD_BRANCH"
    run_cmd git submodule update --init --recursive
    run_cmd ./bootstrap
    run_cmd ./configure --enable-cmsis-dap --enable-internal-jimtcl
    run_cmd make -j"$NPROC"
    cd ..
fi

CURRENT_SETUP_DIR=""

print_header "Setup complete!"
echo "To start developing:"
echo "  source $WORKSPACE_PATH/.venv/bin/activate"
echo "  cd $WORKSPACE_PATH/pwrgrip-fw"
echo "  west build -p auto -b your_board_name"
echo ""
echo "To use your custom OpenOCD:"
echo "  $WORKSPACE_PATH/openocd/src/openocd -f interface/cmsis-dap.cfg -f target/phyplus6252.cfg"
