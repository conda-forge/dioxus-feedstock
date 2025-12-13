#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=thin
export OPENSSL_DIR=${PREFIX}
export OPENSSL_NO_VENDOR=1
export LIBGIT2_NO_VENDOR=1
export PKG_CONFIG_PATH="${BUILD_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}"
export PKG_CONFIG_ALLOW_CROSS=1

if [[ ${target_platform} =~ .*osx.* ]]; then
    mkdir -p ${SRC_DIR}/target/release/deps
    ln -sf ${BUILD_PREFIX}/lib/libgit2* ${SRC_DIR}/target/release/deps
fi

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path packages/cli
