#!/bin/bash
# Add third-party feeds
sed -i '/src-git packages/d' feeds.conf.default
echo "src-git packages https://github.com/openwrt/packages.git;$REPO_BRANCH" > openwrt/feeds.conf.default
echo "src-git luci https://github.com/openwrt/luci.git;$REPO_BRANCH" >> openwrt/feeds.conf.default
echo "src-git routing https://github.com/openwrt/routing.git;$REPO_BRANCH" >> openwrt/feeds.conf.default
echo "src-git telephony https://github.com/openwrt/telephony.git;$REPO_BRANCH" >> openwrt/feeds.conf.default
# 使用 >> 表示将内容追加到文件末尾
# echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall' >> feeds.conf.default
# echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages' >> feeds.conf.default
# echo 'src-git helloworld https://github.com/fw876/helloworld.git' >> feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >> openwrt/feeds.conf.default
