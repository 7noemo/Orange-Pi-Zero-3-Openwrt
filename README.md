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

## 1GB / 1.5GB 内存版（起不来先看这里）

1GB、1.5GB、2GB、4GB 是同一块板子的不同内存容量，固件是**同一份镜像**，不需要按容量选版本。
真正容易出问题的是 U-Boot 的 DRAM 探测，不是 OpenWrt 本身：

- 老 U-Boot（OpenWrt 23.05 / 24.10 用的 2024.01）经常把 **1GB 认成 2GB**，内核按 2GB 建页表，
  一碰到 1GB 以上的地址就 panic / 卡死；1.5GB 板更典型（已知问题，见 OpenWrt #18087、DietPi #7242）。
- 本仓用的 U-Boot 是 **2026.04**，已换成自动探测 rank / 位宽 / 行列地址，并对 1.5GB 这类
  非 2 的幂容量做截断，上述误判基本消失。所以"1GB 版本一律不能刷"这个说法对现在的镜像是**不成立**的。

仍然起不来时，接串口（**115200 8N1**，Zero 3 的 debug UART 是板边 3 pin）看前几行，按现象分三类：

| 串口现象 | 结论 | 处理 |
|---|---|---|
| 完全没有输出，或只有 `U-Boot SPL 20xx.xx` 一行就停 | SPL 阶段 DRAM 初始化失败（时序/供电） | 换 5V/2A 以上电源、换卡重写；仍不行需要 720MHz 版 U-Boot（见下） |
| 打印 `DRAM: 2048 MiB` 而板子是 1GB | 容量仍是误判 | 用新版 U-Boot；临时可在 bootargs 里加 `mem=1024M` 救急 |
| 打印 `DRAM: 1024 MiB` 后卡住 | 不是内存问题 | 见下面三条刷写错误 |

刷写最常见的三个错：

1. **没解压**：直接把 `.img.gz` 写进卡（要写解压后的 `.img`）。
2. **卡太小**：镜像是 16MB FAT + 2GB rootfs，原始大小约 2.1GB，**2GB 卡写一半就断**，用 4GB 以上。
3. **写错文件**：`initramfs-kernel.bin` 是内存运行镜像，不是 SD 镜像，写了也起不来。

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
