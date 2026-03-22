# 1. 强制在内核全局配置文件中开启 BTF 和 XDP 支持
echo "CONFIG_DEBUG_INFO_BTF=y" >> target/linux/x86/config-6.12
echo "CONFIG_BPF_SYSCALL=y" >> target/linux/x86/config-6.12
echo "CONFIG_XDP_SOCKETS=y" >> target/linux/x86/config-6.12
echo "CONFIG_XDP_SOCKETS_DIAG=y" >> target/linux/x86/config-6.12
echo "CONFIG_VETH=y" >> target/linux/x86/config-6.12

# 2. 强制选中核心依赖包 (解决 opkg 找不到包的问题)
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config
echo "CONFIG_PACKAGE_kmod-veth=y" >> .config
echo "CONFIG_PACKAGE_daed=y" >> .config
echo "CONFIG_PACKAGE_luci-app-daed=y" >> .config

# 3. 针对 6.12 内核的特殊补丁：强制生成 vmlinux-btf
# 如果没有这个包，daed 永远装不上
echo "CONFIG_KERNEL_DEBUG_INFO_BTF=y" >> .config
