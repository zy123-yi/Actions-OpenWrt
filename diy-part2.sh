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
