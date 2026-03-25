#!/bin/bash

# 1. 智能定位文件（不管你在根目录还是 openwrt 目录）
if [ -f "feeds.conf.default" ]; then
    TARGET_FILE="feeds.conf.default"
elif [ -f "openwrt/feeds.conf.default" ]; then
    TARGET_FILE="openwrt/feeds.conf.default"
else
    echo "ERROR: Cannot find feeds.conf.default!"
    exit 1
fi

# 2. 确保分支变量有效（如果探测失败则回退）
BRANCH=${REPO_BRANCH:-openwrt-25.12}

# 3. 覆盖写入官方源（解决 Duplicate 报错）
echo "src-git packages https://github.com/openwrt/packages.git;$BRANCH" > $TARGET_FILE
echo "src-git luci https://github.com/openwrt/luci.git;$BRANCH" >> $TARGET_FILE
echo "src-git routing https://github.com/openwrt/routing.git;$BRANCH" >> $TARGET_FILE
echo "src-git telephony https://github.com/openwrt/telephony.git;$BRANCH" >> $TARGET_FILE

# 4. 添加第三方源（sbwml 源在 25.12 下比 small 更稳）
# echo 'src-git sbwml https://github.com/sbwml/openwrt_pkgs' >> $TARGET_FILE
# 如果你一定要用 small，取消下面这行的注释
echo 'src-git small https://github.com/kenzok8/small' >> $TARGET_FILE
# echo 'src-git mosdns https://github.com/sbwml/luci-app-mosdns' >> $TARGET_FILE
echo "Success: $TARGET_FILE updated with branch $BRANCH"
