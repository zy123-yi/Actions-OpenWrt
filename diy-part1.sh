#!/bin/bash

# 1. 强制重写 feeds.conf.default 和 feeds.conf，改用 GitHub 镜像源并彻底移除 helloworld
cat > feeds.conf.default <<EOF
src-git packages https://git.openwrt.org/feed/packages.git^f1470815f41fe199bfdafe9a91ad115bc2e91203
src-git luci https://git.openwrt.org/project/luci.git^75e41cba5160281b2d1dca922719efef29f7ffd8
src-git routing https://git.openwrt.org/feed/routing.git^3eb59e9471858c83891979793f1dd29cca156919
src-git telephony https://git.openwrt.org/feed/telephony.git^2a4541d46199ac96fac214d02c908402831c4dc6
src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main
src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main
# src-git helloworld https://github.com/fw876/helloworld.git
src-git-full kenzok8 https://github.com/kenzok8/openwrt-packages
src-git-full small https://github.com/kenzok8/small
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
