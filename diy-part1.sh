#!/bin/bash
# 锁定官方 25.12 稳定版分支
echo "src-git packages https://github.com/openwrt/packages.git;openwrt-25.12" > feeds.conf.default
echo "src-git luci https://github.com/openwrt/luci.git;openwrt-25.12" >> feeds.conf.default
echo "src-git routing https://github.com/openwrt/routing.git;openwrt-25.12" >> feeds.conf.default
echo "src-git telephony https://github.com/openwrt/telephony.git;openwrt-25.12" >> feeds.conf.default
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default
echo "src-git mosdns https://github.com/sbwml/luci-app-mosdns.git;mosdns" >> feeds.conf.default
echo "src-git vlmcsd https://github.com/mchome/luci-app-vlmcsd.git;vlmcsd" >> feeds.conf.default
