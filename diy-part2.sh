#!/bin/bash

# 1. 进入 package 目录准备拉取
mkdir -p package/community
cd package/community

# 2. 拉取 sbwml 维护的插件合集 (这个源在 25.12 下非常稳)
# 它包含了：PassWall, MosDNS, AdGuardHome, Daed 等
git clone --recursive --depth 1 https://github.com/sbwml/openwrt_pkgs openwrt_pkgs

# 3. 回到主目录
cd ../..

# 4. 汉化补丁：确保简体中文包被选中
# 针对 25.12.1 的 zh-Hans 标准
echo "CONFIG_PACKAGE_luci-i18n-passwall-zh-Hans=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-mosdns-zh-cn=y" >> .config
#!/bin/bash

# 1. 进入插件目录（根据你的克隆路径调整）
# 如果你按之前的建议克隆到了 package/community/openwrt_pkgs
cd package/community/openwrt_pkgs

# 2. 核心修复：修正 AdGuardHome 的版本号格式
# 将 1.8-20221120 改为 1.8.20221120 (把第一个横杠换成点)
find ./luci-app-adguardhome -name "Makefile" -exec sed -i 's/1.8-20221120/1.8.20221120/g' {} +

# 3. 顺便修复其他可能存在的版本号隐患 (可选，针对常见报错包)
# APK 模式不喜欢过长的特殊字符版本号
find ./ -name "Makefile" -exec sed -i 's/PKG_VERSION:=.*-.*-.*$/PKG_VERSION:=1.0/g' {} + 2>/dev/null || true

# 返回主目录
cd ../../../
