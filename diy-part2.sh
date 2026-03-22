#!/bin/bash

# 1. 暴力修改所有 x86 内核配置模板，强制开启 BTF 支持
# 这是生成 vmlinux-btf 的唯一可靠途径
find target/linux/x86/ -name "config-*" -exec sh -c '
    sed -i "/CONFIG_DEBUG_INFO_BTF/d" {}
    sed -i "/CONFIG_BPF_SYSCALL/d" {}
    echo "CONFIG_DEBUG_INFO_BTF=y" >> {}
    echo "CONFIG_BPF_SYSCALL=y" >> {}
    echo "CONFIG_BPF_JIT=y" >> {}
    echo "CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y" >> {}
' \;

# 2. 强制在编译前注入插件勾选 (防止被 defconfig 刷掉)
echo "CONFIG_PACKAGE_daed=y" >> .config
echo "CONFIG_PACKAGE_luci-app-daed=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-daed-zh-cn=y" >> .config
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config

# 3. i7-5500U AES-NI 加速
echo "CONFIG_CRYPTO_AES_NI_INTEL=y" >> .config
