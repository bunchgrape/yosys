#!/usr/bin/env bash

set -euo pipefail

yosys_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

apply_cueda_patch() {
    local repository="$1"
    local patch="$2"

    if git -C "${repository}" apply --reverse --check "${patch}" >/dev/null 2>&1; then
        echo "CUEDA patch already applied: ${patch##*/}"
        return
    fi

    if ! git -C "${repository}" apply --check "${patch}"; then
        echo "CUEDA patch is incompatible with ${repository}" >&2
        return 1
    fi

    git -C "${repository}" apply "${patch}"
    echo "Applied CUEDA patch: ${patch##*/}"
}

apply_cueda_patch \
    "${yosys_root}/frontends/slang/lib" \
    "${yosys_root}/patches/cueda/frontends-slang-lib.patch"
apply_cueda_patch \
    "${yosys_root}/libs/cxxopts" \
    "${yosys_root}/patches/cueda/cxxopts.patch"
apply_cueda_patch \
    "${yosys_root}/libs/fmt" \
    "${yosys_root}/patches/cueda/fmt.patch"
apply_cueda_patch \
    "${yosys_root}/libs/slang" \
    "${yosys_root}/patches/cueda/slang.patch"
apply_cueda_patch \
    "${yosys_root}/libs/tomlplusplus" \
    "${yosys_root}/patches/cueda/tomlplusplus.patch"
apply_cueda_patch \
    "${yosys_root}/" \
    "${yosys_root}/patches/cueda/fix_CMakeLists_test_name.txt"
