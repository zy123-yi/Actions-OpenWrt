#!/bin/bash

# 1. 如果 feeds.conf.default 不存在，就创建一个，或者直接修改 feeds.conf
[ ! -f feeds.conf.default ] && cp feeds.conf feeds.conf.default

# 2. 彻底清空并重新写入 feeds 配置（确保只保留 PassWall）
cat > feeds.conf.default <<EOF
src-git packages https://github.com/openwrt/packages.git;openwrt-24.10
src-git luci https://github.com/openwrt/luci.git;openwrt-24.10
src-git routing https://github.com/openwrt/routing.git;openwrt-24.10
src-git telephony https://github.com/openwrt/telephony.git;openwrt-24.10
src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main
src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main
src-git ower https://github.com/sbwml/luci-app-mosdns
EOF

# 3. 强制删除可能存在的 helloworld 缓存文件夹（双重保险）
rm -rf package/feeds/helloworld
rm -rf feeds/helloworld
