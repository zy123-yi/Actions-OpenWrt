#!/bin/bash
# 假设在 openwrt 目录执行
VERSION_VAL="25.12.1"

# 1. 强制修改版本定义
sed -i "s/VERSION_NUMBER:=.*/VERSION_NUMBER:=${VERSION_VAL}/g" include/version.mk
sed -i "s/VERSION_CODE:=.*/VERSION_CODE:=Stable/g" include/version.mk

# 2. 修改 Web 界面显示
sed -i "s/DISTRIB_DESCRIPTION='.*'/DISTRIB_DESCRIPTION='OpenWrt ${VERSION_VAL} Stable by Gemini'/g" package/base-files/files/etc/openwrt_release

# 3. 针对 x86_64 的特定优化：修改默认 IP (可选)
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 4. 强制勾选主界面的中文语言包
sed -i 's/CONFIG_LUCI_LANG_en=y/# CONFIG_LUCI_LANG_en is not set/' .config
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> .config

# 5. 自动勾选所有已选插件的中文语言包
# 这行命令会遍历所有已选的 luci-app，并尝试选中对应的 i18n-zh-Hans 包
grep "^CONFIG_PACKAGE_luci-app-" .config | grep "=y" | sed 's/app-/i18n-/;s/=y/-zh-Hans=y/' >> .config
