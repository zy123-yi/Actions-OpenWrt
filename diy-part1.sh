#!/bin/bash

# 1. 彻底删除 feeds.conf.default 中已有的相关条目（防止重复定义导致 merging error）
sed -i '/passwall/d' feeds.conf.default
sed -i '/daed/d' feeds.conf.default

# 2. 重新添加官方最前线源码仓库
# 使用不同的名称（如 passwall_official）可以降低冲突风险
echo "src-git passwall_pkgs https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;main" >> feeds.conf.default
echo "src-git daed_repo https://github.com/QiuSimons/luci-app-daed.git" >> feeds.conf.default

# 3. 额外保险：如果 LEDE 源码 package 目录下有残留的同名文件夹，直接删除
rm -rf package/feeds/passwall*
rm -rf package/feeds/luci/luci-app-passwall
rm -rf package/feeds/daed
