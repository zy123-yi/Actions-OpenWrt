#!/bin/bash

# 1. 修复 libtool 编译错误 (保留原逻辑)
[ -f package/libs/libtool/Makefile ] && sed -i 's/patsubst %,-l%,$(LIBKCRYPT)//' package/libs/libtool/Makefile

# 2. 修正 pcre 依赖 (更精准的替换，避免破坏系统核心包)
# 建议只针对 feeds 中的插件包进行替换
find package/feeds/ -name Makefile -exec sed -i 's/+libpcre$/+libpcre2/g; s/DEPENDS:=libpcre/DEPENDS:=libpcre2/g' {} +

# 3. 修复 libxml2 路径映射
find package/feeds/ -name Makefile -exec sed -i 's/libxml2/libxml2-utils/g' {} + 2>/dev/null || true

# 4. 重点修复：系统日志缓冲区 (解决文件不存在报错)
SYS_CONF="package/base-files/files/etc/config/system"
# 先创建目录，确保万无一失
mkdir -p package/base-files/files/etc/config/
if [ -f "$SYS_CONF" ]; then
    sed -i 's/log_size=64/log_size=512/g' "$SYS_CONF"
else
    # 如果文件不存在，直接生成一个包含 log_size 的基础配置
    echo "config system" > "$SYS_CONF"
    echo "    option hostname 'OpenWrt-19'" >> "$SYS_CONF"
    echo "    option log_size '512'" >> "$SYS_CONF"
    echo "    option timezone 'CST-8'" >> "$SYS_CONF"
    echo "    option zonename 'Asia/Shanghai'" >> "$SYS_CONF"
fi

# 5. 针对 19 号机的建议：修改默认内网 IP 为 192.168.2.19
sed -i 's/192.168.1.1/192.168.2.19/g' package/base-files/files/etc/config/network
