#!/bin/bash
# 进入 openwrt 目录 (取决于你的 Workflow 路径)
# cd openwrt
# 1. 自动定位 feeds.conf.default 的位置
# 如果当前目录下有这个文件就用当前的，如果没有就去子目录找
if [ -f "feeds.conf.default" ]; then
    TARGET_FILE="feeds.conf.default"
elif [ -f "openwrt/feeds.conf.default" ]; then
    TARGET_FILE="openwrt/feeds.conf.default"
else
    echo "错误：找不到 feeds.conf.default 文件！"
    exit 1
fi

# 2. 使用 > 覆盖写入（清空原有内容），确保官方源版本对齐
# 注意：$REPO_BRANCH 变量需要从 .yml 传递过来
# 1. 使用 > 覆盖写入第一行，彻底清空原文件并定义官方 packages 分支
echo "src-git packages https://github.com/openwrt/packages.git;$REPO_BRANCH" > feeds.conf.default

# 2. 使用 >> 追加后续行
echo "src-git luci https://github.com/openwrt/luci.git;$REPO_BRANCH" >> feeds.conf.default
echo "src-git routing https://github.com/openwrt/routing.git;$REPO_BRANCH" >> feeds.conf.default
echo "src-git telephony https://github.com/openwrt/telephony.git;$REPO_BRANCH" >> feeds.conf.default
# echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall' >> feeds.conf.default
# echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages' >> feeds.conf.default
# echo 'src-git helloworld https://github.com/fw876/helloworld.git' >> feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >> openwrt/feeds.conf.default
