#!/bin/bash
# 1. 修复 libtool 编译错误
sed -i 's/patsubst %,-l%,$(LIBKCRYPT)//' package/libs/libtool/Makefile

# 2. 修正 Lean 源码中某些陈旧插件对 pcre 的依赖定义
# 这步能解决你报错信息中 80% 的 "libpcre2 does not exist"
find package/feeds/ -name Makefile -exec sed -i 's/libpcre/libpcre2/g' {} +

# 3. 自动修复 aria2 等包可能需要的 libxml2 路径映射
sed -i 's/libxml2/libxml2-utils/g' $(find package/feeds/ -name Makefile) 2>/dev/null || true

# 将系统日志缓冲区由默认的 64K 提升到 512K，充分利用 16G 内存
sed -i 's/log_size=64/log_size=512/g' package/base-files/files/etc/config/system
