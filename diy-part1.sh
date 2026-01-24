#!/bin/bash

# 1. 彻底移除旧的、可能冲突的定义
sed -i '/helloworld/d' feeds.conf.default
sed -i '/passwall/d' feeds.conf.default

# 2. 通过 Feeds 注入新地址（由 OpenWrt 编译系统自动处理下载，更稳定）
echo 'src-git helloworld https://github.com/fw876/helloworld.git' >>feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main' >>feeds.conf.default
echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main' >>feeds.conf.default
