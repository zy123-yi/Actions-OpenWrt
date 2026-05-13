#!/bin/bash

# --- 1. 插件拉取与清理阶段 ---
# 先回到主目录确保路径基准正确
cd $GITHUB_WORKSPACE || cd ../.. 

# 创建并进入社区插件目录
mkdir -p package/community
cd package/community

# 拉取 small-package
git clone --depth 1 https://github.com/kenzok8/small-package.git

# 【修正点】精准清理 small-package 里的 vlmcsd
# 因为你已经 cd 进了 package/community，所以路径直接写 small-package/...
rm -rf small-package/vlmcsd
rm -rf small-package/luci-app-vlmcsd

# 【核心逻辑】从 jell 单独拉取 vlmcsd (使用你要求的模式)
git clone --depth 1 --filter=blob:none --sparse https://github.com/kenzok8/jell.git vlmcsd_temp
cd vlmcsd_temp
git sparse-checkout set vlmcsd luci-app-vlmcsd
cd ..
cp -r vlmcsd_temp/vlmcsd ./
cp -r vlmcsd_temp/luci-app-vlmcsd ./
rm -rf vlmcsd_temp

# --- 2. 深度清理阶段 (解决冲突与报错) ---
# 回到 OpenWrt 根目录执行清理
cd ../..

# 彻底切除 Trojan, daed, AdGuardHome 等高风险冲突项
find ./package/community -name "trojan-plus" -type d -exec rm -rf {} +
find ./package/community -name "luci-app-trojan-plus" -type d -exec rm -rf {} +
find ./package/community -name "trojan-go" -type d -exec rm -rf {} +
find ./package/community -name "daed" -type d -exec rm -rf {} +
find ./package/community -name "luci-app-daed" -type d -exec rm -rf {} +
find ./package/community -name "luci-app-adguardhome" -type d -exec rm -rf {} +
find ./package/community -name "AdGuardHome" -type d -exec rm -rf {} +

# 解决 feeds 中的 vlmcsd 重复定义冲突 (这是你之前报错的主因)
rm -rf feeds/packages/net/vlmcsd

# --- 3. 配置写入阶段 (.config) ---
# 强制写入需要的插件
{
    echo "CONFIG_PACKAGE_luci-app-passwall=y"
    echo "CONFIG_PACKAGE_luci-app-mosdns=y"
    echo "CONFIG_PACKAGE_luci-app-xl2tpd=y"
    echo "CONFIG_PACKAGE_luci-proto-ppp=y"
    echo "CONFIG_PACKAGE_xl2tpd=y"
    echo "CONFIG_PACKAGE_luci-app-ipsec-vpnd=y"
} >> .config

# 移除不需要的插件配置（双重保险）
sed -i '/CONFIG_PACKAGE_luci-app-adguardhome/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-daed/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-trojan-plus/d' .config
