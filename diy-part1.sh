#!/bin/bash
TARGET_FILE="feeds.conf.default"
# 2. 依然保留你的第三方源 (用于 PassWall)
echo 'src-git small https://github.com/kenzok8/small' >> $TARGET_FILE
echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns' >> $TARGET_FILE

# 1. 修正官方源：指向 openwrt-25.12 分支，而不是 v25.12.1 标签
echo "src-git packages https://github.com/openwrt/packages.git;openwrt-25.12" > $TARGET_FILE
echo "src-git luci https://github.com/openwrt/luci.git;openwrt-25.12" >> $TARGET_FILE
echo "src-git routing https://github.com/openwrt/routing.git;openwrt-25.12" >> $TARGET_FILE
echo "src-git telephony https://github.com/openwrt/telephony.git;openwrt-25.12" >> $TARGET_FILE

