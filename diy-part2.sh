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


# 4. 勾选官方中文主支持
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> .config

# 5. 自动补全汉化包（同时尝试两种命名格式）
# 逻辑：只要勾选了 luci-app-xxx，就尝试勾选其对应的 zh-Hans 和 zh-cn
grep "^CONFIG_PACKAGE_luci-app-" .config | grep "=y" | while read line; do
    pkg=$(echo $line | sed 's/CONFIG_PACKAGE_//;s/=y//')
    app_name=$(echo $pkg | sed 's/luci-app-//')
    
    # 尝试注入 zh-Hans (官方标准)
    echo "CONFIG_PACKAGE_luci-i18n-$app_name-zh-Hans=y" >> .config
    # 尝试注入 zh-cn (第三方源常用)
    echo "CONFIG_PACKAGE_luci-i18n-$app_name-zh-cn=y" >> .config
done

# 6. 针对 mosdns 的专项强制勾选
echo "CONFIG_PACKAGE_luci-i18n-mosdns-zh-cn=y" >> .config
