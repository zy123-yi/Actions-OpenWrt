
#!/bin/bash
# 添加 PassWall 和 daed 所在的源
echo 'src-git daed https://github.com/dae-universe/dae-openwrt' >> feeds.conf.default
# Add third-party feeds
echo 'src-git passwall_luci https://github.com/Openwrt-Passwall/openwrt-passwall' feeds.conf.default
echo 'src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages' feeds.conf.default
echo 'src-git helloworld https://github.com/fw876/helloworld.git' feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' feeds.conf.default
echo 'src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default
