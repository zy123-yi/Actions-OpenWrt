#!/bin/bash

# 1. 环境大扫除
rm -rf tmp/
rm -rf package/community
mkdir -p package/community

# 2. 拉取 small-package (仅作为备用依赖库)
# git clone --depth 1 https://github.com/kenzok8/small-package.git package/community/small

# 3. 【关键步骤】删除 small 里的“多刺”插件
# 删掉 small 里的 passwall, vlmcsd, shadowsocks 等所有容易报错的货
# rm -rf package/community/small/luci-app-passwall
# rm -rf package/community/small/passwall
# rm -rf package/community/small/vlmcsd
# rm -rf package/community/small/luci-app-vlmcsd
# rm -rf package/community/small/shadowsocks*
# rm -rf package/community/small/opkg

# 4. 【定向精准拉取】从 jell 仓库只拿你要的“传统 PassWall”和“vlmcsd”
# 使用这种方式可以保证拿到的包是之前编译成功的那个版本
# git clone --depth 1 --filter=blob:none --sparse https://github.com/kenzok8/jell.git package/community/jell_temp
git clone --depth 1 --filter=blob:none --sparse https://github.com/kenzok8/jell.git
# cd package/community/jell_temp
# git sparse-checkout set luci-app-passwall vlmcsd luci-app-vlmcsd
cd ../../..

# 把 jell 的好包搬出来，放到 package 根目录（优先级最高）
# cp -r package/community/jell_temp/luci-app-passwall package/
# cp -r package/community/jell_temp/vlmcsd package/
# cp -r package/community/jell_temp/luci-app-vlmcsd package/
# rm -rf package/community/jell_temp

# 5. 刷新 feeds 并强制安装（确保依赖链条连通）
./scripts/feeds update -a
./scripts/feeds install -a

# 6. 配置写入 (针对传统 PassWall)
# cat >> .config <<EOF
# CONFIG_PACKAGE_luci-app-passwall=y
# CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
# CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
# 配合 MosDNS
# CONFIG_PACKAGE_luci-app-mosdns=y
# L2TP 插件
# CONFIG_PACKAGE_luci-app-xl2tpd=y
# CONFIG_PACKAGE_xl2tpd=y
# CONFIG_PACKAGE_luci-proto-ppp=y
# CONFIG_PACKAGE_luci-app-ipsec-vpnd=y
# EOF

# 7. 自动补全所有依赖项
make defconfig
