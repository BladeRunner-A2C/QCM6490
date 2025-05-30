#!/usr/bin/env bash

BUILD_ROOT="$PWD"
QSSI_ROOT="${BUILD_ROOT}/LA.QSSI.13.0"
VENDOR_ROOT="${BUILD_ROOT}/LA.UM.9.14.1"

function build_qssi {
    cd "$QSSI_ROOT"

    source build/envsetup.sh
    lunch qssi-userdebug
    ./build.sh dist --qssi_only -j "$(nproc --all)"
}

function build_target {
    cd "$VENDOR_ROOT"

    source build/envsetup.sh
    lunch lahaina-userdebug
    ./build.sh dist --target_only -j "$(nproc --all)"
}

function build_super {
    cd "$VENDOR_ROOT"

    python vendor/qcom/opensource/core-utils/build/build_image_standalone.py \
        --image super \
        --qssi_build_path "$QSSI_ROOT" \
        --target_build_path "$VENDOR_ROOT" \
        --merged_build_path "$VENDOR_ROOT" \
        --target_lunch lahaina \
        --skip_qiifa \
        --output_ota
}

if [ "$1" = 'full' ]; then
    build_qssi
    build_target
    build_super
else
    build_target
fi
