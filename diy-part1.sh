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

# 1. 移除原有定义，防止重复报错
sed -i '/helloworld/d' feeds.conf.default
sed -i '/passwall/d' feeds.conf.default

# 2. 创建自定义插件目录（如果不存在）
mkdir -p package/custom

# 3. 直接克隆源码到 package/custom 目录下
# 如果官方地址慢，可以在下面地址前加 https://mirror.ghproxy.com/ (尝试不同的前缀)
git clone --depth=1 https://github.com/fw876/helloworld.git package/custom/helloworld
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git package/custom/passwall

# 4. 获取 Passwall 所需的依赖包（这个非常关键，否则编译会报错）
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/custom/passwall_packages
