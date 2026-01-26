#!/bin/bash

# 1. 基础设置：修改默认 IP 和 主机名
# 24.10 的路径通常一致，确保 IP 修改生效
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Home-Router/g' package/base-files/files/bin/config_generate

# 2. 清理残留缓存与索引 (确保环境纯净)
rm -rf tmp
rm -rf logs/*

# 3. 针对智能家居的 mDNS 优化 (美的/追觅/小米设备发现)
# 修正：将配置写入 .config 模板
echo "CONFIG_PACKAGE_avahi-dbus-daemon=y" >> .config
echo "CONFIG_PACKAGE_libavahi-dbus-support=y" >> .config

# 4. 修复软件源 opkg 配置 (核心修正点：使用相对路径)
# 这一步能解决你“系统没有软件包”和“Permission denied”的问题
ORIGIN_OPKG="package/base-files/files/etc/opkg.conf"
mkdir -p $(dirname $ORIGIN_OPKG)
cat > $ORIGIN_OPKG <<EOF
dest root /
dest ram /tmp
lists_dir ext /usr/lib/opkg/lists
option overlay_root /overlay
# option check_signature
EOF

# 5. 强制 24.10 菜单刷新 (解决“服务菜单不显示”的问题)
# 开启后，系统会在启动时自动生成权限索引
echo "CONFIG_LUCI_SRCDIET=y" >> .config

# 6. 补充 ACC 加速内核模块 (确保加速功能不因依赖缺失而挂掉)
echo "CONFIG_PACKAGE_kmod-nft-offload=y" >> .config
echo "CONFIG_PACKAGE_kmod-tcp-bbr=y" >> .config

# 7. 更新并重新安装 Feeds (确保所有插件都在位)
./scripts/feeds update -a
./scripts/feeds install -a
