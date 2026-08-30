#!/usr/bin/env bash

set -euo pipefail

apply_patch() {
    local repository=$1
    local patch=$2

    if git -C "${repository}" apply --check "${patch}" >/dev/null 2>&1; then
        git -C "${repository}" apply "${patch}"
        echo "Applied ${patch}"
    elif git -C "${repository}" apply --reverse --check "${patch}" >/dev/null 2>&1; then
        echo "Already applied: ${patch}"
    else
        echo "Patch is neither applicable nor already applied: ${patch}" >&2
        git -C "${repository}" apply --check "${patch}"
    fi
}

apply_patch frontends/slang/lib ../../../patches/cueda/frontends-slang-lib.patch
apply_patch libs/cxxopts ../../patches/cueda/cxxopts.patch
apply_patch libs/fmt ../../patches/cueda/fmt.patch
apply_patch libs/slang ../../patches/cueda/slang.patch
apply_patch libs/tomlplusplus ../../patches/cueda/tomlplusplus.patch
