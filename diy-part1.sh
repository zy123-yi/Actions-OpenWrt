#!/bin/bash

# 1. 清理 feeds.conf.default 中可能冲突的旧条目
sed -i '/passwall/d' feeds.conf.default
sed -i '/daed/d' feeds.conf.default

# 2. 物理删除残留目录 (这一步是解决 "No such file or directory" 的核心)
rm -rf feeds/passwall*
rm -rf feeds/daed*

# 3. 添加 PassWall 官方最新源
echo "src-git passwall_pkgs https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default

# 4. 添加 daed 官方源 (如果是用 6.12 内核，这行必须加)
echo "src-git daed https://github.com/QiuSimons/luci-app-daed.git" >> feeds.conf.default
