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
# 强制关闭 24.10 中不稳定的 Rust 及其相关统计插件，确保固件轻量稳定
sed -i 's/CONFIG_PACKAGE_rust=y/CONFIG_PACKAGE_rust=n/g' .config
sed -i 's/CONFIG_PACKAGE_luci-app-statistics=y/CONFIG_PACKAGE_luci-app-statistics=n/g' .config
# 在 diy-part2.sh 中加入
# 强制让 Go 相关的 Makefile 信任宿主机环境中的 go 路径
sed -i 's/GO_HOST_PROG:=.*/GO_HOST_PROG:=\/usr\/bin\/go/g' feeds/packages/lang/golang/golang-values.mk 2>/dev/null || true
# 如果 Go 版本依然冲突，直接删掉这个惹祸的包，不编译它
rm -rf feeds/helloworld/hysteria
rm -rf feeds/helloworld/luci-app-hysteria
