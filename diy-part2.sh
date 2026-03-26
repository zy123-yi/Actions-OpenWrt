#!/bin/bash

# 1. 创建并进入社区插件目录
mkdir -p package/community
cd package/community

# 2. 拉取 PassWall 插件及依赖 (使用目前活跃的备份源)
# 这个源通常包含了 luci-app-passwall 及其核心组件
git clone --depth 1 https://github.com/kenzok8/jell.git


# 4. 返回主目录
cd ../..
# 在 diy-part2.sh 的末尾添加
echo "CONFIG_PACKAGE_luci-app-passwall=y" >> .config
echo "CONFIG_PACKAGE_luci-app-mosdns=y" >> .config
# 自动选中所有依赖项（很重要！）
echo "CONFIG_PACKAGE_luci-i18n-passwall-zh-Hans=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-mosdns-zh-cn=y" >> .config
#!/bin/bash

#!/bin/bash

# 1. 彻底切除 Trojan 相关（解决 Boost 1.89 报错的罪魁祸首）
find ./ -name "trojan-plus" -type d -exec rm -rf {} +
find ./ -name "luci-app-trojan-plus" -type d -exec rm -rf {} +
find ./ -name "trojan-go" -type d -exec rm -rf {} +

# 2. 彻底切除 daed 相关（既然你不需要了）
find ./ -name "daed" -type d -exec rm -rf {} +
find ./ -name "luci-app-daed" -type d -exec rm -rf {} +

# 3. 彻底切除 AdGuardHome 相关（防止 Go 语言环境冲突）
find ./ -name "luci-app-adguardhome" -type d -exec rm -rf {} +
find ./ -name "AdGuardHome" -type d -exec rm -rf {} +

# 4. 解决 25.12 稳定版核心冲突
# 删掉 small 源中不兼容 APK 模式的旧核心，强制系统使用 sbwml 源中修复过的版本
# rm -rf feeds/small/sing-box
# rm -rf feeds/small/xray-core
# rm -rf feeds/small/v2ray-core
# rm -rf feeds/small/v2ray-plugin

# 5. 额外清理 Turbo ACC 冲突（防止 Duplicate 报错）
rm -rf feeds/luci/applications/luci-app-turboacc
rm -rf feeds/packages/net/vlmcsd

# 5. 在 .config 中强制禁用这些项目（双重保险）
sed -i '/CONFIG_PACKAGE_luci-app-adguardhome/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-daed/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-trojan-plus/d' .config
