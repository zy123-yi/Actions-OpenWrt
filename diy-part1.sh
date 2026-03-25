#!/bin/bash
TARGET_FILE="openwrt/feeds.conf.default"

# 1. 覆盖写入官方 25.12.1 分支源
echo "src-git packages https://github.com/openwrt/packages.git;v25.12.1" > $TARGET_FILE
echo "src-git luci https://github.com/openwrt/luci.git;v25.12.1" >> $TARGET_FILE
echo "src-git routing https://github.com/openwrt/routing.git;v25.12.1" >> $TARGET_FILE
echo "src-git telephony https://github.com/openwrt/telephony.git;v25.12.1" >> $TARGET_FILE

# 2. 只添加一个第三方源（建议用 small，它对 PassWall 的维护最快）
# 不要同时加 sbwml 和 small，否则会因为重复定义导致 feeds 报错
echo 'src-git small https://github.com/kenzok8/small' >> $TARGET_FILE
echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns' >> $TARGET_FILE
