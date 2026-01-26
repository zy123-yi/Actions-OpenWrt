#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
#!/bin/bash

rm -rf ./tmp

# 1. 修改默认 IP 为 192.168.10.1 (避免与光猫 192.168.1.1 冲突)
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 2. 修改默认主机名为 Home-Router
sed -i 's/OpenWrt/Home-Router/g' package/base-files/files/bin/config_generate

# 3. 针对美的、盼盼等智能家居优化（允许本地多播发现）
# 开启 mDNS 基础支持
echo "CONFIG_PACKAGE_avahi-dbus-daemon=y" >> .config
echo "CONFIG_PACKAGE_libavahi-dbus-support=y" >> .config
#!/bin/bash

# 1. 屏蔽 Hysteria (导致你目前报错的主要原因)
rm -rf feeds/helloworld/hysteria
rm -rf feeds/helloworld/luci-app-hysteria
rm -rf feeds/passwall_packages/hysteria
rm -rf feeds/passwall_packages/hysteria2

# 2. 屏蔽其他潜在的 Go 冲突包
rm -rf feeds/helloworld/tuic-client
rm -rf feeds/helloworld/naiveproxy
rm -rf feeds/passwall_packages/tuic-client
rm -rf feeds/passwall_packages/naiveproxy

# 3. 屏蔽 Rust 报错包 (如果 Rust 也报错，建议关掉这个不常用的)
rm -rf feeds/packages/lang/rust
rm -rf feeds/packages/utils/onionshare-cli

# 4. 强制清理残留
./scripts/feeds install -a
