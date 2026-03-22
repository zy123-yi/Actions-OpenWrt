#!/bin/bash

# 1. 修改内核模板 (解决 vmlinux-btf 和 daed 运行环境)
# 针对所有 x86 平台的内核配置文件注入 eBPF/BTF 支持
# 使用 sed 确保先删除可能存在的旧配置，再添加，防止重复
find target/linux/x86/ -name "config-*" -exec sh -c '
    sed -i "/CONFIG_DEBUG_INFO_BTF/d" {}
    sed -i "/CONFIG_BPF_SYSCALL/d" {}
    sed -i "/CONFIG_XDP_SOCKETS/d" {}
    echo "CONFIG_DEBUG_INFO_BTF=y" >> {}
    echo "CONFIG_BPF_SYSCALL=y" >> {}
    echo "CONFIG_XDP_SOCKETS=y" >> {}
' \;

# 2. 修正 .config 中的软件包选中 (解决依赖缺失问题)
# 先删除已有配置，确保新配置生效 (防止被 Workflow 里的旧逻辑覆盖)
sed -i '/CONFIG_PACKAGE_kmod-nft-queue/d' .config
sed -i '/CONFIG_PACKAGE_kmod-nfnetlink-queue/d' .config
sed -i '/CONFIG_PACKAGE_kmod-xdp-sockets-diag/d' .config
sed -i '/CONFIG_PACKAGE_kmod-veth/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-daed/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-passwall/d' .config

# 强制选中内核模块与应用
echo "CONFIG_PACKAGE_kmod-nft-queue=y" >> .config
echo "CONFIG_PACKAGE_kmod-nfnetlink-queue=y" >> .config
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config
echo "CONFIG_PACKAGE_kmod-veth=y" >> .config
echo "CONFIG_PACKAGE_luci-app-daed=y" >> .config
echo "CONFIG_PACKAGE_luci-app-passwall=y" >> .config

# 3. 针对 i7-5500U 的 AES-NI 加速 (PassWall 性能翻倍关键)
# 确保内核开启了 AES 指令集支持
echo "CONFIG_CRYPTO_AES_NI_INTEL=y" >> .config

# 4. 修复 OpenSSL 编译权限问题
sed -i 's/read-only//g' package/libs/openssl/Makefile 2>/dev/null || true
