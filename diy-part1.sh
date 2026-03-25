#!/bin/bash
# 进入 openwrt 目录 (取决于你的 Workflow 路径)
# cd openwrt

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
