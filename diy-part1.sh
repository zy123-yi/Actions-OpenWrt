#!/bin/bash
# 移除可能冲突的旧源
sed -i '/daed/d' feeds.conf.default
sed -i '/passwall/d' feeds.conf.default

# 添加官方最新源
echo "src-git daed https://github.com/QiuSimons/luci-app-daed.git" >> feeds.conf.default
echo "src-git passwall_pkgs https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default
