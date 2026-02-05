#!/bin/bash
# 彻底清空所有第三方源，防止 feeds 脚本去尝试克隆它们

#!/bin/bash
# 1. 添加 helloworld (SSR Plus+) 源
echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default

# 2. 如果你还想要更多插件（可选），可以添加这个常用库
# echo 'src-git small https://github.com/kenzok8/small' >> feeds.conf.default
