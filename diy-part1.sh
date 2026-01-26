#!/bin/bash

# 1. 强制重写 feeds.conf.default 和 feeds.conf，改用 GitHub 镜像源并彻底移除 helloworld
cat > feeds.conf.default <<EOF
src-git packages https://github.com/openwrt/packages.git;openwrt-24.10
src-git luci https://github.com/openwrt/luci.git;openwrt-24.10
src-git routing https://github.com/openwrt/routing.git;openwrt-24.10
src-git telephony https://github.com/openwrt/telephony.git;openwrt-24.10
src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main
src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main
src-git ower https://github.com/sbwml/luci-app-mosdns
EOF

# 同步覆盖 feeds.conf（防止某些 Actions 模板优先读取此文件）
cp feeds.conf.default feeds.conf

# 2. 物理删除残留目录 (解决 install feeds 环节报错的关键)
rm -rf feeds/helloworld
rm -rf package/feeds/helloworld

# 3. 增加 Git 网络容错机制
git config --global http.postBuffer 524288000
git config --global https.postBuffer 524288000
git config --global core.compression 0
