#!/bin/bash

# 1. 创建并进入社区插件目录
mkdir -p package/community
cd package/community

# 2. 拉取 PassWall 插件及依赖 (使用目前活跃的备份源)
# 这个源通常包含了 luci-app-passwall 及其核心组件
git clone --depth 1 https://github.com/kenzok8/small.git

# 3. 单独拉取 MosDNS (使用原作者 sbwml 的稳定版本)
# 这是目前 25.12 环境下适配最好的 MosDNS 方案
git clone --depth 1 https://github.com/sbwml/luci-app-mosdns.git mosdns-luci
git clone --depth 1 https://github.com/sbwml/v2dat.git v2dat

# 4. 返回主目录
cd ../..
# 在 diy-part2.sh 的末尾添加
echo "CONFIG_PACKAGE_luci-app-passwall=y" >> .config
echo "CONFIG_PACKAGE_luci-app-mosdns=y" >> .config
# 自动选中所有依赖项（很重要！）
echo "CONFIG_PACKAGE_luci-i18n-passwall-zh-Hans=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-mosdns-zh-cn=y" >> .config
