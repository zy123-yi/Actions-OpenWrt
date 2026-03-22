#!/bin/bash

# 1. 强制修改 x86_64 平台的内核默认配置文件 (针对 6.12 内核)
# 这是解决 "cannot find dependency vmlinux-btf" 的唯一根本方法
echo "CONFIG_DEBUG_INFO_BTF=y" >> target/linux/x86/config-6.12
echo "CONFIG_BPF=y" >> target/linux/x86/config-6.12
echo "CONFIG_BPF_SYSCALL=y" >> target/linux/x86/config-6.12
echo "CONFIG_BPF_JIT=y" >> target/linux/x86/config-6.12
echo "CONFIG_XDP_SOCKETS=y" >> target/linux/x86/config-6.12
echo "CONFIG_XDP_SOCKETS_DIAG=y" >> target/linux/x86/config-6.12
echo "CONFIG_VETH=y" >> target/linux/x86/config-6.12

# 2. 修正 .config 中的关键包选中状态，防止被静默取消
sed -i '/CONFIG_PACKAGE_kmod-xdp-sockets-diag/d' .config
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config

sed -i '/CONFIG_PACKAGE_kmod-veth/d' .config
echo "CONFIG_PACKAGE_kmod-veth=y" >> .config

sed -i '/CONFIG_PACKAGE_daed/d' .config
echo "CONFIG_PACKAGE_daed=y" >> .config

sed -i '/CONFIG_PACKAGE_luci-app-daed/d' .config
echo "CONFIG_PACKAGE_luci-app-daed=y" >> .config

# 3. 强制开启 BTF 编译支持（这步会增加编译时间，但必须有）
echo "CONFIG_KERNEL_DEBUG_INFO_BTF=y" >> .config

# 4. (可选) 清理冲突的旧包，确保从你添加的 feed 源编译 daed
rm -rf package/feeds/luci/luci-app-daed
rm -rf package/feeds/daed/daed
