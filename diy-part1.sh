#!/bin/bash
# 先把可能存在的旧条目删干净（包括 Workflow 刚才可能写进去的）
sed -i '/daed/d' feeds.conf.default
sed -i '/passwall/d' feeds.conf.default

# 重新添加，并给仓库起个唯一的后缀名（如 _repo）防止名称冲突
echo "src-git daed_repo https://github.com/QiuSimons/luci-app-daed.git" >> feeds.conf.default
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> feeds.conf.default
