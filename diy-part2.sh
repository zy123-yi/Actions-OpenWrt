#!/bin/bash

# 1. 基础设置
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Home-Router/g' package/base-files/files/bin/config_generate

# 2. 移除 helloworld 以解决冲突 (这是最稳妥的做法)
# 如果你坚持要留着，那就手动删除冲突严重的重复包
rm -rf feeds/helloworld/xray-core
rm -rf feeds/helloworld/v2ray-core
rm -rf feeds/helloworld/v2ray-plugin
rm -rf feeds/helloworld/shadowsocks-rust

# 3. 移除导致索引错误的 Makefile 所在目录
rm -rf feeds/helloworld/luci-app-ssr-plus
rm -rf feeds/passwall_packages/geoview
rm -rf feeds/passwall_packages/hysteria

# 4. 修复 PassWall 的依赖关系
# 如果 luci-app-passwall 报错，通常是因为它找不到对应的子包
# 我们强制清理 tmp 并在 install 前同步
rm -rf tmp
./scripts/feeds update -i
./scripts/feeds install -a

# 5. 针对智能家居的 Avahi 补丁
echo "CONFIG_PACKAGE_avahi-dbus-daemon=y" >> .config
echo "CONFIG_PACKAGE_libavahi-dbus-support=y" >> .config
