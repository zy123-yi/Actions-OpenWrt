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

# 1. 强制物理删除所有可能的 Trojan 路径
# 无论是 feeds 还是 package 目录下的全部干掉
rm -rf feeds/small/trojan-plus
rm -rf feeds/small/luci-app-trojan-plus
rm -rf package/community/jell/trojan-plus
rm -rf package/feeds/small/trojan-plus

# 2. 这里的 find 命令是保底手段：全盘搜索名为 trojan-plus 的文件夹并删除
find ./ -name "trojan-plus" -type d -exec rm -rf {} +

# 3. 再次强力修改 .config，确保没有任何插件能通过 select 把它拉回来
sed -i '/CONFIG_PACKAGE_trojan-plus/d' .config
sed -i '/CONFIG_PACKAGE_luci-app-trojan-plus/d' .config
