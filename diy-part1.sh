#!/bin/bash
# 锁定官方 25.12 稳定版分支
echo "src-git packages https://github.com/openwrt/packages.git;openwrt-25.12" > feeds.conf.default
echo "src-git luci https://github.com/openwrt/luci.git;openwrt-25.12" >> feeds.conf.default
echo "src-git routing https://github.com/openwrt/routing.git;openwrt-25.12" >> feeds.conf.default
echo "src-git telephony https://github.com/openwrt/telephony.git;openwrt-25.12" >> feeds.conf.default
