#!/bin/bash

# --- 第一部分：进入根目录并清理 ---
# 确保我们在 OpenWrt 源码根目录（即包含 feeds 和 package 的地方）
[ -d package ] || cd ..

# --- 第二部分：处理 jell 仓库 ---
# 先删除旧的 jell（如果存在），防止因文件夹已存在导致 clone 失败
rm -rf package/community/jell

# 创建目录并拉取
# mkdir -p package/community
# git clone --depth 1 https://github.com/kenzok8/jell.git package/community/jell

# --- 第三部分：物理切除 jell 里的 daed (这是你报错的根源) ---
# 这一步必须在 clone 之后立即执行
# if [ -d "package/community/jell/daed" ]; then
#    echo "Found ghost daed in jell, removing..."
#    rm -rf package/community/jell/daed
# fi
# if [ -d "package/community/jell/mosdns" ]; then
#    echo "Found ghost mosdns in jell, removing..."
#    rm -rf package/community/jell/mosdns
# fi
# --- 第四部分：重新安装干净的 daed ---
# 删除所有地方可能残留的 daed 文件夹
# find ./package -type d -name "daed" -exec rm -rf {} +
# find ./feeds -type d -name "daed" -exec rm -rf {} +
# find ./package -type d -name "mosdns" -exec rm -rf {} +
# find ./feeds -type d -name "mosdns" -exec rm -rf {} +
# find ./package -type d -name "passwall" -exec rm -rf {} +
# find ./feeds -type d -name "passwall" -exec rm -rf {} +

# 拉取官方最新标准源到 package/daed
# git clone --depth 1 https://github.com/QiuSimons/luci-app-daed.git package/daed
# git clone --depth 1 https://github.com/sbwml/luci-app-mosdns.git package/mosdns
# 移除 openwrt feeds 自带的核心库
# rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls,haproxy}
# rm -rf ./packages/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls,haproxy}
#rm -rf ./feeds/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls,haproxy}
# git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages

# 移除 openwrt feeds 过时的luci版本
# rm -rf feeds/luci/applications/luci-app-passwall
# git clone https://github.com/Openwrt-Passwall/openwrt-passwall package/passwall-luci

# 1. 彻底清理掉 small-package 里的 vlmcsd（防止它干扰编译）
# 假设你的目录名是 package/small-package
# rm -rf package/communitye/vlmcsd
# rm -rf package/communitye/luci-app-vlmcsd
# git clone --depth 1 --filter=blob:none --sparse https://github.com/kenzok8/jell.git package/vlmcsd_temp
# cd package/vlmcsd_temp
# git sparse-checkout set vlmcsd luci-app-vlmcsd
# cd ../..
#cp -r package/vlmcsd_temp/vlmcsd package/community
# cp -r package/vlmcsd_temp/luci-app-vlmcsd package/luci-app-vlmcsd
# rm -rf package/vlmcsd_temp

# 4. 返回主目录
# cd ../..
# 在 diy-part2.sh 的末尾添加
# echo "CONFIG_PACKAGE_luci-app-passwall=y" >> .config
# echo "CONFIG_PACKAGE_luci-app-mosdns=y" >> .config
# 自动选中所有依赖项（很重要！）
# echo "CONFIG_PACKAGE_luci-i18n-passwall-zh-Hans=y" >> .config
# echo "CONFIG_PACKAGE_luci-i18n-mosdns-zh-cn=y" >> .config
#!/bin/bash

#!/bin/bash



# 4. 解决 25.12 稳定版核心冲突
# 删掉 small 源中不兼容 APK 模式的旧核心，强制系统使用 sbwml 源中修复过的版本
# rm -rf feeds/small/sing-box
# rm -rf feeds/small/xray-core
# rm -rf feeds/small/v2ray-core
# rm -rf feeds/small/v2ray-plugin

# 5. 额外清理 Turbo ACC 冲突（防止 Duplicate 报错）
# rm -rf feeds/luci/applications/luci-app-turboacc
# rm -rf feeds/packages/net/vlmcsd

# 5. 在 .config 中强制禁用这些项目（双重保险）
# sed -i '/CONFIG_PACKAGE_luci-app-adguardhome/d' .config
# sed -i '/CONFIG_PACKAGE_luci-app-daed/d' .config
# sed -i '/CONFIG_PACKAGE_luci-app-trojan-plus/d' .config
# 在 diy-part2.sh 中追加配置
# echo "CONFIG_PACKAGE_luci-app-xl2tpd=y" >> .config
# echo "CONFIG_PACKAGE_luci-proto-ppp=y" >> .config
# echo "CONFIG_PACKAGE_xl2tpd=y" >> .config

# 如果需要 IPsec 加密支持
# echo "CONFIG_PACKAGE_luci-app-ipsec-vpnd=y" >> .config
#!/bin/bash
#!/bin/bash

# 1. 创建自定义插件目录
mkdir -p package/custom

# 2. 直接用 git clone 精准拉取 PassWall 组件
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/custom/passwall_packages
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall.git package/custom/passwall_luci

# ====================================================================
# 🔥 【终极物理清理】直接整箱端走所有带 Rust 和已失效的废弃组件
# ====================================================================
# 物理删除 Rust 核心组件（彻底解决你日志里卡 shadowsocks-rust 的问题）
rm -rf package/custom/passwall_packages/shadowsocks-rust
rm -rf package/custom/passwall_packages/chinadns-ng
rm -rf package/custom/passwall_packages/brook

# 物理删除已失效、会导致下载失败的古老 SSR 组件
rm -rf package/custom/passwall_packages/shadowsocks-libev

# 3. 强行在其余组件的 Makefile 里抹除残留的文本引用（防止系统回头去找它们）
find package/custom/ -name "Makefile" | xargs sed -i '/shadowsocksr-libev/d'
find package/custom/ -name "Makefile" | xargs sed -i '/shadowsocks-rust/d'
find package/custom/ -name "Makefile" | xargs sed -i '/chinadns-ng/d'
find package/custom/ -name "Makefile" | xargs sed -i '/brook/d'

find package/custom/ -name "Config.in" | xargs sed -i '/shadowsocksr-libev/d'
find package/custom/ -name "Config.in" | xargs sed -i '/shadowsocks-rust/d'

# 4. 如果存在 .config，彻底封死相关开关
if [ -f .config ]; then
    sed -i '/CONFIG_PACKAGE_shadowsocks-rust/d' .config
    sed -i '/CONFIG_PACKAGE_chinadns-ng/d' .config
    sed -i '/CONFIG_PACKAGE_shadowsocksr-libev/d' .config
    echo "CONFIG_PACKAGE_shadowsocks-rust=n" >> .config
    echo "CONFIG_PACKAGE_chinadns-ng=n" >> .config
    echo "CONFIG_PACKAGE_shadowsocksr-libev=n" >> .config
fi
# ====================================================================



find ./ -name "trojan-plus" -type d -exec rm -rf {} +
find ./ -name "luci-app-trojan-plus" -type d -exec rm -rf {} +
find ./ -name "trojan-go" -type d -exec rm -rf {} +

# 2. 彻底切除 daed 相关（既然你不需要了）
# find ./ -name "daed" -type d -exec rm -rf {} +
# find ./ -name "luci-app-daed" -type d -exec rm -rf {} +

# 3. 彻底切除 AdGuardHome 相关（防止 Go 语言环境冲突）
find ./ -name "luci-app-adguardhome" -type d -exec rm -rf {} +
find ./ -name "AdGuardHome" -type d -exec rm -rf {} +
# 3. 精准拉取 Mosdns v5 分支及地理数据依赖
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/custom/luci-app-mosdns
# git clone --depth=1 https://github.com/sbwml/v2ray-geodata.git package/custom/v2ray-geodata
git clone --depth=1 https://github.com/mufeng05/turboacc.git package/custom/turboacc

# 4. 精准拉取 Vlmcsd KMS 组件
git clone --depth 1 --filter=blob:none --sparse https://github.com/kenzok8/jell.git package/vlmcsd_temp
cd package/vlmcsd_temp
git sparse-checkout set vlmcsd luci-app-vlmcsd
cd ../..
cp -r package/vlmcsd_temp/vlmcsd package/custom
cp -r package/vlmcsd_temp/luci-app-vlmcsd package/luci-app-vlmcsd
rm -rf package/vlmcsd_temp
# --- 修复依赖索引 ---
./scripts/feeds update -i
./scripts/feeds install -a
