
#!/bin/bash

# 1. 彻底解决 vmlinux-btf 缺失：直接修改内核默认模板
# 这一步是万恶之源，必须在编译内核前强行注入
find target/linux/x86/ -name "config-6.12" -exec sh -c '
    sed -i "/CONFIG_DEBUG_INFO_BTF/d" {}
    echo "CONFIG_DEBUG_INFO_BTF=y" >> {}
    echo "CONFIG_BPF_SYSCALL=y" >> {}
    echo "CONFIG_BPF_JIT=y" >> {}
' \;

# 2. 彻底解决 kmod-xdp-sockets-diag 缺失：在 .config 中强制选中内核驱动
# daed 运行需要 XDP 套接字诊断模块，必须显式开启
echo "CONFIG_PACKAGE_kmod-xdp-sockets-diag=y" >> .config
echo "CONFIG_PACKAGE_kmod-veth=y" >> .config
echo "CONFIG_PACKAGE_kmod-nft-queue=y" >> .config

# 3. 确保 daed 被选中
echo "CONFIG_PACKAGE_daed=y" >> .config
echo "CONFIG_PACKAGE_luci-app-daed=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-daed-zh-cn=y" >> .config
