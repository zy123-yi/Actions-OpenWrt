#!/bin/bash

# 1. 清理旧源
sed -i '/daed/d' feeds.conf.default
sed -i '/passwall/d' feeds.conf.default

# 2. 使用这种格式添加（明确分支和路径）
echo "src-git daed https://github.com/QiuSimons/luci-app-daed.git" >> feeds.conf.default
echo "src-git passwall_pkgs https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default

# 3. 【绝招】如果上面的 feed 还是装不上，直接把 daed 物理“绑架”到 package 目录下
# 这样做会绕过 feeds 扫描机制，强制编译器必须看到它
git clone --depth 1 https://github.com/QiuSimons/luci-app-daed.git package/daed-app
git clone --depth 1 https://github.com/QiuSimons/daed.git package/daed-core
