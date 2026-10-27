# Orange-Pi-Zero-3-Openwrt

香橙派 **Orange Pi Zero 3**（全志 H618，Cortex-A53）自动云编译 OpenWrt 固件。

## 说明

- 源码：[ImmortalWrt](https://github.com/immortalwrt/immortalwrt) master 分支（内核 6.18）
- **Wi-Fi 已支持**：板载 AW859A（Unisoc UWE5622）芯片。ImmortalWrt 内置该驱动的 OpenWrt 移植包（`kmod-uwe5622` + `uwe5622-firmware`）以及 Zero 3 的 Wi-Fi 设备树补丁，固件开箱即有 `wlan0`（支持 2.4G/5G，802.11 a/b/g/n/ac），已附带 `wpad` 无线配置组件。
- 插件与 [Orange-Pi-Zero-ZeroPlus-Openwrt](https://github.com/7noemo/Orange-Pi-Zero-ZeroPlus-Openwrt) 保持一致：OpenClash、PassWall / PassWall2、SSR+、aria2 / AriaNg、Docker、Samba、adbyby、网易云音乐解锁、ttyd 等，另外新增了 UPnP、WOL 网络唤醒、ZeroTier、htop、iperf3。
- **iStoreOS 风格新手友好体验**：
  - **iStore 应用商店**（`luci-app-store`）：LuCI 内一键安装/卸载插件，依赖自动处理，商店保持空置、按需安装
  - **快捷向导首页**（`luci-app-quickstart`）：网络向导 + 常用功能快捷入口，新手不碰命令行也能完成组网
  - **默认中文界面**：LuCI 简体中文语言包开箱即用
  - 1GB 及以上内存版本可直接在商店安装 Docker 类应用；固件本身已内置 Docker
- 固件下载请前往 **Releases** 列表
- 默认 IP：`192.168.1.1`

## 自动编译

- 源码有更新时每 18 小时自动检查并触发编译（Update Checker）
- 也可在 Actions 页面手动运行 `Build OpenWrt Zero 3`
- 编译完成后自动上传 Release（仅编译成功才发布），自动保留最近 3 个版本

## 自定义插件

Fork 后修改 `orange-pi-zero3.config` 中的 `CONFIG_PACKAGE_*` 即可。

## 致谢

- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [kenzok8/openwrt-packages](https://github.com/kenzok8/openwrt-packages)

## License

[MIT](./LICENSE)
