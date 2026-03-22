#!/bin/bash
# 移除可能重复的源
sed -i '/daed/d' feeds.conf.default
# 添加最新 daed 源
echo "src-git daed https://github.com/QiuSimons/luci-app-daed.git" >> feeds.conf.default
