#!/bin/bash
TARGET_FILE="openwrt/feeds.conf.default"

# 1. 强制覆盖为官方 25.12 分支源
# 这样能保证 scripts/feeds update -a 100% 成功，且不会有语法报错
echo "src-git packages https://github.com/openwrt/packages.git;openwrt-25.12" > $TARGET_FILE
echo "src-git luci https://github.com/openwrt/luci.git;openwrt-25.12" >> $TARGET_FILE
echo "src-git routing https://github.com/openwrt/routing.git;openwrt-25.12" >> $TARGET_FILE
echo "src-git telephony https://github.com/openwrt/telephony.git;openwrt-25.12" >> $TARGET_FILE

# 2. 注意：这里删除了所有的第三方 src-git (如 small, sbwml)
# 因为我们要通过 diy-part2.sh 手动克隆，避免 feeds 脚本的严格校验
