#!/bin/bash
# 强制从 .config 中取消选中 trojan 相关包，防止由于依赖缺失导致编译失败
sed -i 's/CONFIG_PACKAGE_luci-app-trojan-plus=y/# CONFIG_PACKAGE_luci-app-trojan-plus is not set/' .config
sed -i 's/CONFIG_PACKAGE_trojan-plus=y/# CONFIG_PACKAGE_trojan-plus is not set/' .config
