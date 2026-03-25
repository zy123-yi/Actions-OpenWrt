#!/bin/bash

# 1. 进入 package 目录准备拉取
mkdir -p package/community
cd package/community

# 2. 拉取 sbwml 维护的插件合集 (这个源在 25.12 下非常稳)
# 它包含了：PassWall, MosDNS, AdGuardHome, Daed 等
git clone --depth 1 https://github.com/sbwml/openwrt_pkgs openwrt_pkgs

# 3. 回到主目录
cd ../..

# 4. 汉化补丁：确保简体中文包被选中
# 针对 25.12.1 的 zh-Hans 标准
echo "CONFIG_PACKAGE_luci-i18n-passwall-zh-Hans=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-mosdns-zh-cn=y" >> .config
