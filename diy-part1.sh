#!/bin/bash

# 移除原有定义
sed -i '/helloworld/d' feeds.conf.default
sed -i '/passwall/d' feeds.conf.default

# 注意：不要在脚本里写 git clone，这很容易导致 Action 挂掉。
# 请把 git clone 那几行移动到你的 .yml 文件中，
# 或者使用上面的“建议 1”通过 feeds.conf.default 来引入。
