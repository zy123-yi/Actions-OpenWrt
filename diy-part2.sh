#!/bin/bash

# 1. 清理环境，防止缓存了 jell 时代的路径
rm -rf tmp/
# 彻底清理旧的 community 目录
rm -rf package/community

# 2. 创建目录并拉取源
mkdir -p package/community
cd package/community

# 拉取 small-package (作为主干)
git clone --depth 1 https://github.com/kenzok8/small-package.git small
rm -rf small-package/opkg

# 3. 处理 vlmcsd 冲突（这就是你之前报错的根源）
# 删掉 small 里的坏包，直接把 jell 里的好包拉过来
rm -rf small/vlmcsd small/luci-app-vlmcsd
git clone --depth 1 --filter=blob:none --sparse https://github.com/kenzok8/jell.git jell_temp
cd jell_temp
git sparse-checkout set vlmcsd luci-app-vlmcsd
cd ..
mv jell_temp/vlmcsd ./
mv jell_temp/luci-app-vlmcsd ./
rm -rf jell_temp

# 4. 【关键：解决固件 20M 的必杀技】
# 将所有插件“提拔”到 package/ 根目录下，确保编译系统能识别
cd ../..
ln -sf ./package/community/small/* ./package/
ln -sf ./package/community/vlmcsd ./package/
ln -sf ./package/community/luci-app-vlmcsd ./package/

# 5. 再次修正 .config 写入 (使用更通用的包名)
# 之前的 20M 是因为配置没被识别，这次我们要写得更死一点
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-mosdns=y
CONFIG_PACKAGE_luci-app-xl2tpd=y
CONFIG_PACKAGE_xl2tpd=y
CONFIG_PACKAGE_luci-proto-ppp=y
CONFIG_PACKAGE_luci-app-ipsec-vpnd=y
EOF

# 6. 强制执行依赖刷新
# 如果这一步报错，说明包的源码没放对位置
make defconfig
