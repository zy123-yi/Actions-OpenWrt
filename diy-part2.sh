#!/bin/bash
# 强制将固件身份修改为最新的稳定版号
# 这样 apk 就会自动去 /releases/25.12.3/ 路径下载插件

if [ -n "$VERSION_NUMBER" ]; then
    echo "Updating version to $VERSION_NUMBER"
    # 修改 version.mk 里的版本定义
    sed -i "s/VERSION_NUMBER:=.*/VERSION_NUMBER:=${VERSION_NUMBER}/g" include/version.mk
    # 修改发布描述
    sed -i "s/DISTRIB_DESCRIPTION='.*'/DISTRIB_DESCRIPTION='OpenWrt ${VERSION_NUMBER} Stable'/g" package/base-files/files/etc/openwrt_release
fi
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
