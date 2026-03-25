#!/bin/bash
# Add third-party feeds
echo "src-git packages https://github.com/openwrt/packages.git;$REPO_BRANCH" > feeds.conf.default
echo "src-git luci https://github.com/openwrt/luci.git;$REPO_BRANCH" >> feeds.conf.default
# 使用 >> 表示将内容追加到文件末尾
# echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall' >> feeds.conf.default
# echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages' >> feeds.conf.default
# echo 'src-git helloworld https://github.com/fw876/helloworld.git' >> feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >> feeds.conf.default
