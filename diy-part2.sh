#!/bin/bash

# --- 1. 环境清理 ---
rm -rf tmp/

# --- 2. 插件下载与修复 ---
cd package/community

# 下载 small-package
git clone --depth 1 https://github.com/kenzok8/small-package.git

# 【新增：解决 CMake 3.5 报错的关键】
# 彻底删除第三方源里的 opkg，强制系统使用官方自带版本
rm -rf small-package/opkg

# 【继续之前的修复】清理 vlmcsd 冲突
rm -rf small-package/vlmcsd
rm -rf small-package/luci-app-vlmcsd

# 从 jell 定向拉取 vlmcsd (使用 sparse 模式)
git clone --depth 1 --filter=blob:none --sparse https://github.com/kenzok8/jell.git vlmcsd_temp
cd vlmcsd_temp
git sparse-checkout set vlmcsd luci-app-vlmcsd
cd ..
cp -r vlmcsd_temp/vlmcsd ./
cp -r vlmcsd_temp/luci-app-vlmcsd ./
rm -rf vlmcsd_temp

# --- 3. 根目录后续操作 ---
cd ../..

# 深度清理其他潜在冲突（Trojan, daed 等）
find ./package/community -name "trojan*" -type d -exec rm -rf {} +
find ./package/community -name "daed*" -type d -exec rm -rf {} +

# 强制更新索引
./scripts/feeds update -i
./scripts/feeds install -a

# --- 4. 配置写入 ---
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-mosdns=y
CONFIG_PACKAGE_luci-app-xl2tpd=y
CONFIG_PACKAGE_luci-proto-ppp=y
CONFIG_PACKAGE_xl2tpd=y
CONFIG_PACKAGE_luci-app-ipsec-vpnd=y
EOF
