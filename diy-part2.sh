#!/bin/bash

# 1. 从 feeds 源码中彻底删除会导致报错的 trojan 相关包
rm -rf feeds/small/trojan-plus
rm -rf feeds/small/luci-app-trojan-plus
rm -rf feeds/small/trojan-go
rm -rf feeds/small/luci-app-trojan-go

# 2. 修改 .config，确保即使之前勾选了也会被取消
sed -i 's/CONFIG_PACKAGE_luci-app-trojan-plus=y/# CONFIG_PACKAGE_luci-app-trojan-plus is not set/' .config
sed -i 's/CONFIG_PACKAGE_trojan-plus=y/# CONFIG_PACKAGE_trojan-plus is not set/' .config
sed -i 's/CONFIG_PACKAGE_luci-app-trojan-go=y/# CONFIG_PACKAGE_luci-app-trojan-go is not set/' .config
sed -i 's/CONFIG_PACKAGE_trojan-go=y/# CONFIG_PACKAGE_trojan-go is not set/' .config
