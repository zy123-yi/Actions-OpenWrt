#!/bin/bash

# 1. 强制清理旧的 feeds 索引缓存 (这是最关键的一步，防止系统记着旧路径)
rm -rf tmp/

# 2. 确保社区目录存在
mkdir -p package/community

# 3. 进到社区目录操作
cd package/community

# 下载 small-package
git clone --depth 1 https://github.com/kenzok8/small-package.git

# 【精准切除】删除 small-package 里那个坏掉的 vlmcsd
rm -rf small-package/vlmcsd
rm -rf small-package/luci-app-vlmcsd

# 【定向拉取】从 jell 拿好用的 vlmcsd (使用 sparse 模式)
git clone --depth 1 --filter=blob:none --sparse https://github.com/kenzok8/jell.git vlmcsd_temp
cd vlmcsd_temp
git sparse-checkout set vlmcsd luci-app-vlmcsd
cd ..
cp -r vlmcsd_temp/vlmcsd ./
cp -r vlmcsd_temp/luci-app-vlmcsd ./
rm -rf vlmcsd_temp

# 4. 返回根目录
cd ../..

# 5. 【补救措施】强制让编译系统重新读取 package 目录下的所有新包
./scripts/feeds update -a
./scripts/feeds install -a

# 6. 再次写入配置 (确保这些 y 不会被系统剔除)
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-mosdns=y
CONFIG_PACKAGE_luci-app-xl2tpd=y
CONFIG_PACKAGE_luci-proto-ppp=y
CONFIG_PACKAGE_xl2tpd=y
CONFIG_PACKAGE_luci-app-ipsec-vpnd=y
EOF

# 7. 检查核心依赖（防止因为没选内核模块导致插件不生效）
echo "CONFIG_PACKAGE_kmod-l2tp=y" >> .config
