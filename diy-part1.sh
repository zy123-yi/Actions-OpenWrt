#!/bin/bash

# 移除自带的旧包，防止名称冲突导致的不更新
rm -rf package/lean/luci-app-passwall
rm -rf package/feeds/luci/luci-app-passwall

# 添加 PassWall 官方源 (luci + packages)
# 这样做能确保你在“服务”菜单里看到的永远是 xiaorouji 的最新版本
sed -i '$a src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main' feeds.conf.default
sed -i '$a src-git passwall_pkgs https://github.com/xiaorouji/openwrt-passwall-packages.git;main' feeds.conf.default

# 提示：daed 的源也可以在这里一并处理
rm -rf package/feeds/daed/luci-app-daed
