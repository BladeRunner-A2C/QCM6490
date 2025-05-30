#!/usr/bin/env bash

BUILD_ROOT="$PWD"
QSSI_ROOT="${BUILD_ROOT}/LA.QSSI.13.0"
VENDOR_ROOT="${BUILD_ROOT}/LA.UM.9.14.1"

function sync_repo {
    mkdir -p "$1" && cd "$1"
    echo "[+] Changed directory to $1."

    if repo init --depth=1 -q -u https://github.com/BladeRunner-A2C/QCM6490 -m "$2"; then
        echo "[+] Repo initialized successfully."
    else
        echo "[-] Error: Failed to initialize repo."
        exit 1
    fi

    echo "[+] Starting repo sync..."
    if schedtool -B -e ionice -n 0 repo sync -c --force-sync --optimized-fetch --no-tags --retry-fetches=5 -j"$(nproc --all)"; then
        echo "[+] Repo synced successfully."
    else
        echo "[-] Error: Failed to sync repo."
        exit 1
    fi
}

if [ "$1" = 'full' ]; then
    echo -e "\nSetting up for full package build...\n"
    sync_repo "$QSSI_ROOT" "qssi.xml"
    sync_repo "$VENDOR_ROOT" "target.xml"
else
    sync_repo "$VENDOR_ROOT" "target.xml"
fi

cd "$BUILD_ROOT"
echo "[+] Successfully returned to the build root."
