#!/bin/bash

# 1. 基础信息修改
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Home-Router/g' package/base-files/files/bin/config_generate

# 2. 物理移除会导致编译失败的“钉子户”插件
# 彻底解决 v2ray-plugin, geoview, shadowsocks-rust, hysteria 等冲突
declare -a bad_pkgs=(
    "feeds/helloworld/v2ray-plugin"
    "feeds/helloworld/shadowsocks-rust"
    "feeds/helloworld/hysteria"
    "feeds/helloworld/luci-app-hysteria"
    "feeds/passwall_packages/geoview"
    "feeds/passwall_packages/hysteria"
    "feeds/passwall_packages/hysteria2"
    "feeds/passwall_packages/shadowsocks-rust"
    "feeds/passwall_packages/tuic-client"
    "feeds/passwall_packages/naiveproxy"
)

for pkg in "${bad_pkgs[@]}"; do
    rm -rf "$pkg"
    # 同时删除已安装的软链接，防止 No rule 报错
    find package/feeds/ -name "$(basename $pkg)" -type l -delete
done

# 3. 智能家居优化：增强 mDNS/Avahi 发现能力
# 这能显著提升手机 App 发现美的空调和追觅扫地机的成功率
{
    echo "CONFIG_PACKAGE_avahi-dbus-daemon=y"
    echo "CONFIG_PACKAGE_libavahi-dbus-support=y"
    echo "CONFIG_PACKAGE_kmod-nft-tproxy=y"
    echo "CONFIG_PACKAGE_kmod-nft-socket=y"
} >> .config

# 4. 强制修复包索引（解决 No rule to make target）
./scripts/feeds update -i
./scripts/feeds install -a

# 5. 最后的强力清洗：清除可能存在的残留 .config 干扰
rm -rf tmp
