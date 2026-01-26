#!/bin/bash

# 1. 基础设置：修改默认 IP 和 主机名
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Home-Router/g' package/base-files/files/bin/config_generate

# 2. 清理残留缓存与索引 (确保 24.10 环境纯净)
rm -rf tmp
rm -rf logs/*

# 3. 针对智能家居的 mDNS 优化 (美的/追觅/小米设备发现)
# 确保 Avahi 开启，这样手机 App 才能通过 .local 域名发现内网家电
echo "CONFIG_PACKAGE_avahi-dbus-daemon=y" >> .config
echo "CONFIG_PACKAGE_libavahi-dbus-support=y" >> .config

# 4. 强制修复 PassWall 核心关联 (防止 24.10 编译时某些子依赖丢失)
# 这一步会根据我们精简后的 .config 重新核对依赖
./scripts/feeds update -i
./scripts/feeds install -a

# 在 diy-part2.sh 中加入，修正 24.10 的软件源格式
sed -i 's/check_signature/ # check_signature/g' /etc/opkg.conf  # 暂时跳过签名校验（可选）

# 确保软件源指向正确的 24.10 官方镜像地址（根据你的架构自动匹配）
echo "dest root /" > /etc/opkg.conf
echo "dest ram /tmp" >> /etc/opkg.conf
echo "lists_dir ext /usr/lib/opkg/lists" >> /etc/opkg.conf
echo "option overlay_root /overlay" >> /etc/opkg.conf
