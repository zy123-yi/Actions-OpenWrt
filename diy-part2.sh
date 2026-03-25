#!/bin/bash
# 强制定义版本号，欺骗 apk 软件源指向稳定版路径
# 假设 $REPO_BRANCH 是 openwrt-25.12
VERSION_VAL="25.12.0"

# 修改版本号
sed -i "s/VERSION_NUMBER:=.*/VERSION_NUMBER:=${VERSION_VAL}/g" include/version.mk
# 修改内部代号
sed -i "s/VERSION_CODE:=.*/VERSION_CODE:=$(date +%Y%m%d)/g" include/version.mk

# 强制修改软件源 URL 逻辑（可选，但推荐）
# 这会确保你的固件以后去 releases 路径下载插件，而不是 snapshots
sed -i "s/snapshots/releases\/${VERSION_VAL}/g" package/base-files/image-config.in
# 1. 从 feeds 源码中彻底删除会导致报错的 trojan 相关包
rm -rf feeds/small/trojan-plus
rm -rf feeds/small/luci-app-trojan-plus
rm -rf feeds/small/trojan-go
rm -rf feeds/small/luci-app-trojan-go

# 2. 修改 .config，确保即使之前勾选了也会被取消
sed -i 's/CONFIG_PACKAGE_luci-app-trojan-plus=y/# CONFIG_PACKAGE_luci-app-trojan-plus is not set/' .config
sed -i 's/CONFIG_PACKAGE_trojan-plus=y/# CONFIG_PACKAGE_trojan-plus is not set/' .config
sed -i 's/CONFIG_PACKAGE_luci-app-trojan-go=y/# CONFIG_PACKAGE_luci-app-trojan-go is not set/' .config
sed -i 's/CONFIG_PACKAGE_trojan-go=y/# CONFIG_PACKAGE_trojan-go is not set/' .config
