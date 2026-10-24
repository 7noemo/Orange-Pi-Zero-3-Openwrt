#!/bin/bash
#
# OpenWrt DIY script part 1 (Before Update feeds)
# Based on P3TERX/Actions-OpenWrt
#

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

git clone --depth 1 https://github.com/messense/aliyundrive-fuse.git package/aliyundrive-fuse
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone --depth 1 https://github.com/linkease/docker_ddnsto.git package/docker_ddnsto

# Note: Wi-Fi (AW859A / UWE5622) driver and firmware are built into
# ImmortalWrt (package/kernel/uwe5622 + package/firmware/armbian-firmware),
# and the Zero 3 Wi-Fi DTS patch is already applied in the sunxi target.
