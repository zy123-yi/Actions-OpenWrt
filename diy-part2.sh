#!/bin/bash

# 1. 修改内核模板 (解决 vmlinux-btf 和 daed 运行环境)
# 针对所有 x86 平台的内核配置文件注入 eBPF/BTF 支持
find target/linux/x86/ -name "config-*" -exec sh -c 'echo "CONFIG_DEBUG_INFO_BTF=y" >> {}' \;
find target/linux/x86/ -name "config-*" -exec sh -c 'echo "CONFIG_BPF_SYSCALL=y" >> {}' \;
find target/linux/x86/ -name "config-*" -exec sh -c 'echo "CONFIG_XDP_SOCKETS=y" >> {}' \;

# 2. 修正 .config 中的软件包选中 (解决 sing-box 升级报错和 daed 消失)
# 强制选中内核模块
echo "CONFIG_PACKAGE_kmod-nft-queue=y" >> .config
echo "CONFIG_PACKAGE_kmod-nfnetlink-queue=y" >> .config
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config
echo "CONFIG_PACKAGE_kmod-veth=y" >> .config

# 强制选中应用 (确保它们 100% 出现在固件里)
echo "CONFIG_PACKAGE_luci-app-daed=y" >> .config
echo "CONFIG_PACKAGE_luci-app-passwall=y" >> .config

# 3. 修复可能存在的 OpenSSL 编译死循环 (可选)
sed -i 's/read-only//g' package/libs/openssl/Makefile 2>/dev/null || true
