#!/bin/bash

# ... (之前的 IP 修改和主机名修改代码) ...

# 1. 在 .config 中强制替换 dnsmasq 为 dnsmasq-full
# 必须先取消原有的 dnsmasq，否则编译会因为包冲突报错 (Error 1)
echo "CONFIG_PACKAGE_dnsmasq=n" >> .config
echo "CONFIG_PACKAGE_dnsmasq-full=y" >> .config

# 2. 开启 dnsmasq-full 的核心增强功能 (支持 PassWall 的分流)
echo "CONFIG_PACKAGE_dnsmasq_full_dhcp=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_ipset=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_nftset=y" >> .config
echo "CONFIG_PACKAGE_dnsmasq_full_tftp=y" >> .config

# 3. 针对 24.10 的防火墙修复 (确保 dnsmasq-full 与 fw4 协同)
echo "CONFIG_PACKAGE_kmod-nft-tproxy=y" >> .config

# 4. 修复之前报错的 opkg 路径问题 (使用相对路径)
ORIGIN_OPKG="package/base-files/files/etc/opkg.conf"
mkdir -p $(dirname $ORIGIN_OPKG)
cat > $ORIGIN_OPKG <<EOF
dest root /
dest ram /tmp
lists_dir ext /usr/lib/opkg/lists
option overlay_root /overlay
# option check_signature
EOF
