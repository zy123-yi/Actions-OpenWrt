#!/bin/bash

# 1. 重写 feeds 配置文件，全部改用 GitHub 镜像源（解决 503 报错）
cat > feeds.conf.default <<EOF
src-git packages https://github.com/openwrt/packages.git;openwrt-24.10
src-git luci https://github.com/openwrt/luci.git;openwrt-24.10
src-git routing https://github.com/openwrt/routing.git;openwrt-24.10
src-git telephony https://github.com/openwrt/telephony.git;openwrt-24.10
src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main
src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main
src-git ower https://github.com/sbwml/luci-app-mosdns
EOF

# 2. 增加 Git 重试机制（防止由于网络抖动导致的 503/504）
git config --global http.postBuffer 524288000
git config --global https.postBuffer 524288000
git config --global core.compression 0
