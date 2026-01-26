#!/bin/bash

# 1. 基础配置修改
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Home-Router/g' package/base-files/files/bin/config_generate

# 2. 定义报错黑名单（根据你刚才的报错信息）
# 物理移除所有导致 "please fix Makefile" 的目录
declare -a bug_pkgs=(
    "feeds/helloworld/xray-plugin"
    "feeds/helloworld/v2ray-plugin"
    "feeds/helloworld/shadowsocks-rust"
    "feeds/helloworld/hysteria"
    "feeds/passwall_packages/geoview"
    "feeds/passwall_packages/hysteria"
    "feeds/passwall_packages/shadow-tls"
    "feeds/passwall_packages/shadowsocks-rust"
    "feeds/passwall_packages/naiveproxy"
)

for pkg in "${bad_pkgs[@]}"; do
    [ -d "$pkg" ] && rm -rf "$pkg"
done

# 3. 强制清理所有的软链接，防止残留索引
find package/feeds/ -type l -delete

# 4. 关键：清理 tmp 缓存，这是导致 Makefile 报错持续存在的根源
rm -rf tmp
rm -rf logs/*

# 5. 重新安装并强制刷新索引
./scripts/feeds update -i
./scripts/feeds install -a

# 6. 智能家居/内核组件增强（美的/追觅优化）
{
    echo "CONFIG_PACKAGE_avahi-dbus-daemon=y"
    echo "CONFIG_PACKAGE_libavahi-dbus-support=y"
    echo "CONFIG_PACKAGE_kmod-nft-tproxy=y"
} >> .config
