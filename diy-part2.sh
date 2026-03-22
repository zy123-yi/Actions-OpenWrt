#!/bin/bash

# 1. 强制修改内核模板 (开启 BTF/eBPF 核心支持)
find target/linux/x86/ -name "config-*" -exec sh -c '
    sed -i "/CONFIG_DEBUG_INFO_BTF/d" {}
    sed -i "/CONFIG_BPF_SYSCALL/d" {}
    sed -i "/CONFIG_XDP_SOCKETS/d" {}
    echo "CONFIG_DEBUG_INFO_BTF=y" >> {}
    echo "CONFIG_BPF_SYSCALL=y" >> {}
    echo "CONFIG_XDP_SOCKETS=y" >> {}
' \;

# 2. 【关键】强制复活 daed 及其所有依赖
# 注意：这些行必须放在 diy-part2.sh 的最后，确保不被覆盖
sed -i '/CONFIG_PACKAGE_daed/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-daed/d' .config
sed -i '/CONFIG_PACKAGE_luci-i18n-daed-zh-cn/d' .config

echo "CONFIG_PACKAGE_daed=y" >> .config
echo "CONFIG_PACKAGE_luci-app-daed=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-daed-zh-cn=y" >> .config

# 3. 强行补齐内核模块依赖 (缺少这些 daed 就装不上)
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config
echo "CONFIG_PACKAGE_kmod-veth=y" >> .config
echo "CONFIG_PACKAGE_kmod-nft-queue=y" >> .config

# 4. 修复 OpenSSL 编译权限
sed -i 's/read-only//g' package/libs/openssl/Makefile 2>/dev/null || true
