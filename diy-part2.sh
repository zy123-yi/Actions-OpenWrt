#!/bin/bash
#!/bin/bash

# 1. 强制修改版本号显示（把 SNAPSHOT 替换为具体的版本）
# 这里的 $REPO_BRANCH 会被替换为 openwrt-25.12
# 我们提取出 25.12 部分
VERSION_NUM=$(echo $REPO_BRANCH | cut -d '-' -f 2)

sed -i "s/VERSION_NUMBER:=.*/VERSION_NUMBER:=${VERSION_NUM}.0/g" include/version.mk
sed -i "s/VERSION_CODE:=.*/VERSION_CODE:=Stable/g" include/version.mk

# 2. 修改发布描述，显示在 Web 登录界面
sed -i "s/DISTRIB_DESCRIPTION='.*'/DISTRIB_DESCRIPTION='OpenWrt ${VERSION_NUM}.0 Stable'/g" package/base-files/files/etc/openwrt_release
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
