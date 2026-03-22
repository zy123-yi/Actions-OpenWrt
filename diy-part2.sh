#!/bin/bash

# 1. 暴力修改所有 x86 内核配置模板，强制开启 BTF 编译
# 这是生成 vmlinux-btf 的唯一可靠途径，i7-5500U 必须有它
find target/linux/x86/ -name "config-*" -exec sh -c '
    sed -i "/CONFIG_DEBUG_INFO_BTF/d" {}
    sed -i "/CONFIG_BPF_SYSCALL/d" {}
    sed -i "/CONFIG_BPF_JIT/d" {}
    echo "CONFIG_DEBUG_INFO_BTF=y" >> {}
    echo "CONFIG_BPF_SYSCALL=y" >> {}
    echo "CONFIG_BPF_JIT=y" >> {}
    echo "CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y" >> {}
' \;

# 2. 强制在应用层选中 daed 及其所有硬依赖
# 这一步必须在 P2 脚本里再次强调，防止被 Workflow 覆盖
echo "CONFIG_PACKAGE_daed=y" >> .config
echo "CONFIG_PACKAGE_luci-app-daed=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-daed-zh-cn=y" >> .config
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config
echo "CONFIG_PACKAGE_kmod-veth=y" >> .config

# 3. i7-5500U AES-NI 加速 (性能补丁)
echo "CONFIG_CRYPTO_AES_NI_INTEL=y" >> .config
