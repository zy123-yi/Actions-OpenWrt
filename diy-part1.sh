#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source

#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
#!/bin/bash

#!/bin/bash
#!/bin/bash
# 移除旧定义
sed -i '/helloworld/d' feeds.conf.default
sed -i '/passwall/d' feeds.conf.default

# 使用备用镜像地址
echo 'src-git helloworld https://ghproxy.net/https://github.com/fw876/helloworld.git' >> feeds.conf.default
echo 'src-git passwall https://ghproxy.net/https://github.com/xiaorouji/openwrt-passwall.git' >> feeds.conf.default
echo 'src-git passwall_packages https://ghproxy.net/https://github.com/xiaorouji/openwrt-passwall-packages.git' >> feeds.conf.default
