#!/bin/bash
# 这个脚本现在只负责简单的文本替换
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
