---
title: xrandr notes
date: Tue 29 Aug 2023 14:33:44 CST
author: xeonds
toc: true
excerpt: (￣﹃￣)
---

## reason

Can't use multi screens. When loading xrandr, only get 2 DPs and 1 eDP.

## process

use lspci, have no hdmi.

```bash
00:00.0 Host bridge: Intel Corporation 12th Gen Core Processor Host Bridge/DRAM Registers (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Alder Lake-P Integrated Graphics Controller (rev 0c)
00:04.0 Signal processing controller: Intel Corporation Alder Lake Innovation Platform Framework Processor Participant (rev 02)
00:06.0 PCI bridge: Intel Corporation 12th Gen Core Processor PCI Express x4 Controller #0 (rev 02)
00:06.2 PCI bridge: Intel Corporation 12th Gen Core Processor PCI Express x4 Controller #2 (rev 02)
00:0a.0 Signal processing controller: Intel Corporation Platform Monitoring Technology (rev 01)
00:0d.0 USB controller: Intel Corporation Alder Lake-P Thunderbolt 4 USB Controller (rev 02)
00:14.0 USB controller: Intel Corporation Alder Lake PCH USB 3.2 xHCI Host Controller (rev 01)
00:14.2 RAM memory: Intel Corporation Alder Lake PCH Shared SRAM (rev 01)
00:14.3 Network controller: Intel Corporation Alder Lake-P PCH CNVi WiFi (rev 01)
00:15.0 Serial bus controller: Intel Corporation Alder Lake PCH Serial IO I2C Controller #0 (rev 01)
00:16.0 Communication controller: Intel Corporation Alder Lake PCH HECI Controller (rev 01)
00:1f.0 ISA bridge: Intel Corporation Alder Lake PCH eSPI Controller (rev 01)
00:1f.3 Multimedia audio controller: Intel Corporation Alder Lake PCH-P High Definition Audio Controller (rev 01)
00:1f.4 SMBus: Intel Corporation Alder Lake PCH-P SMBus Host Controller (rev 01)
00:1f.5 Serial bus controller: Intel Corporation Alder Lake-P PCH SPI Controller (rev 01)
01:00.0 Non-Volatile memory controller: Sandisk Corp WD Green SN350 NVMe SSD 240GB (DRAM-less) (rev 01)
02:00.0 Non-Volatile memory controller: Intel Corporation SSD 660P Series (rev 03)
```

use dmesg, GuC/Huc works ok.

use `inxi -SMGxxxz`:

```bash
System:
  Kernel: 6.4.12-arch1-1 arch: x86_64 bits: 64 compiler: gcc
    v: 13.2.1 clocksource: tsc Desktop: KDE Plasma v: 5.27.7 tk: Qt
    v: 5.15.10 info: latte-dock wm: kwin_x11 vt: 2 dm: SDDM
    Distro: Arch Linux
Machine:
  Type: Laptop System: MECHREVO product: WUJIE 16 v: N/A
    serial: <superuser required> Chassis: type: 10
    serial: <superuser required>
  Mobo: MECHREVO model: WUJIE 16 serial: <superuser required>
    UEFI: American Megatrends v: Q3AWJ.10 date: 03/15/2022
Graphics:
  Device-1: Intel Alder Lake-P Integrated Graphics driver: i915
    v: kernel arch: Gen-12.2 ports: active: eDP-1 empty: DP-1,DP-2
    bus-ID: 00:02.0 chip-ID: 8086:46a6 class-ID: 0300
  Device-2: SunplusIT MTD Camera driver: uvcvideo type: USB
    rev: 2.0 speed: 480 Mb/s lanes: 1 bus-ID: 3-5:6
    chip-ID: 13d3:784b class-ID: 0e02 serial: <filter>
  Display: x11 server: X.Org v: 21.1.8 with: Xwayland v: 23.2.0
    compositor: kwin_x11 driver: X: loaded: modesetting
    unloaded: vesa alternate: fbdev,intel dri: iris gpu: i915
    display-ID: :0 screens: 1
  Screen-1: 0 s-res: 2560x1600 s-dpi: 96
    s-size: 677x423mm (26.65x16.65") s-diag: 798mm (31.43")
  Monitor-1: eDP-1 model: BOE Display 0x0997 res: 2560x1600
    hz: 120 dpi: 188 size: 345x215mm (13.58x8.46") diag: 407mm (16")
    modes: 2560x1600
  API: OpenGL v: 4.6 Mesa 23.1.6 renderer: Mesa Intel Graphics
    (ADL GT2) direct-render: Yes
```

trying to open device 'i915'...done
Connectors:
id	encoder	status		name		size (mm)	modes	encoders
236	235	connected	eDP-1          	340x220		1	235
  modes:
	index name refresh (Hz) hdisp hss hse htot vdisp vss vse vtot
  #0 2560x1600 120.00 2560 2608 2640 2720 1600 1603 1609 1695 553250 flags: phsync, nvsync; type: preferred, driver
  props:
	1 EDID:
		flags: immutable blob
		blobs:

		value:
			00ffffffffffff0009e5970900000000
			1c1e0104a5221678078235a5534a9e26
			0f505400000001010101010101010101
			0101010101011dd800a0a0405f603020
			360059d71000001a000000fd003078cb
			cb37010a20202020201a000000fe0042
			4f452043510a202020202020000000fe
			004e4531363051444d2d4e59320a00a6
	2 DPMS:
		flags: enum
		enums: On=0 Standby=1 Suspend=2 Off=3
		value: 0
	5 link-status:
		flags: enum
		enums: Good=0 Bad=1
		value: 0
	6 non-desktop:
		flags: immutable range
		values: 0 1
		value: 0
	4 TILE:
		flags: immutable blob
		blobs:

		value:
	238 scaling mode:
		flags: enum
		enums: Full=1 Center=2 Full aspect=3
		value: 3
	239 panel orientation:
		flags: immutable enum
		enums: Normal=0 Upside Down=1 Left Side Up=2 Right Side Up=3
		value: 0
	240 Broadcast RGB:
		flags: enum
		enums: Automatic=0 Full=1 Limited 16:235=2
		value: 0
	241 max bpc:
		flags: range
		values: 6 12
		value: 12
	242 Colorspace:
		flags: enum
		enums: Default=0 RGB_Wide_Gamut_Fixed_Point=13 RGB_Wide_Gamut_Floating_Point=14 opRGB=7 DCI-P3_RGB_D65=11 BT2020_RGB=9 BT601_YCC=15 BT709_YCC=2 XVYCC_601=3 XVYCC_709=4 SYCC_601=5 opYCC_601=6 BT2020_CYCC=8 BT2020_YCC=10
		value: 0
	7 HDR_OUTPUT_METADATA:
		flags: blob
		blobs:

		value:
	243 vrr_capable:
		flags: immutable range
		values: 0 1
		value: 1
245	244	connected	DP-1           	0x0		18	244
  modes:
	index name refresh (Hz) hdisp hss hse htot vdisp vss vse vtot
  #0 1920x1080 60.00 1920 2008 2052 2200 1080 1082 1087 1125 148500 flags: phsync, pvsync; type: driver
  #1 1920x1080 60.00 1920 2008 2052 2200 1080 1084 1089 1125 148500 flags: phsync, pvsync; type: driver
  #2 1920x1080 59.94 1920 2008 2052 2200 1080 1084 1089 1125 148352 flags: phsync, pvsync; type: driver
  #3 1920x1080 50.00 1920 2448 2492 2640 1080 1084 1089 1125 148500 flags: phsync, pvsync; type: driver
  #4 1680x1050 59.88 1680 1728 1760 1840 1050 1053 1059 1080 119000 flags: phsync, nvsync; type: driver
  #5 1440x900 59.90 1440 1488 1520 1600 900 903 909 926 88750 flags: phsync, nvsync; type: driver
  #6 1280x960 60.00 1280 1376 1488 1800 960 961 964 1000 108000 flags: phsync, pvsync; type: driver
  #7 1280x800 59.91 1280 1328 1360 1440 800 803 809 823 71000 flags: phsync, nvsync; type: driver
  #8 1280x720 60.00 1280 1390 1430 1650 720 725 730 750 74250 flags: phsync, pvsync; type: driver
  #9 1280x720 59.94 1280 1390 1430 1650 720 725 730 750 74176 flags: phsync, pvsync; type: driver
  #10 1280x720 50.00 1280 1720 1760 1980 720 725 730 750 74250 flags: phsync, pvsync; type: driver
  #11 1280x720 48.00 1280 2240 2280 2500 720 725 730 750 90000 flags: phsync, pvsync; type: driver
  #12 1280x720 47.95 1280 2240 2280 2500 720 725 730 750 89910 flags: phsync, pvsync; type: driver
  #13 1024x768 60.00 1024 1048 1184 1344 768 771 777 806 65000 flags: nhsync, nvsync; type: driver
  #14 800x600 60.32 800 840 968 1056 600 601 605 628 40000 flags: phsync, pvsync; type: driver
  #15 800x600 56.25 800 824 896 1024 600 601 603 625 36000 flags: phsync, pvsync; type: driver
  #16 640x480 60.00 640 656 752 800 480 490 492 525 25200 flags: nhsync, nvsync; type: driver
  #17 640x480 59.94 640 656 752 800 480 490 492 525 25175 flags: nhsync, nvsync; type: driver
  props:
	1 EDID:
		flags: immutable blob
		blobs:

		value:
			00ffffffffffff004a8b211980102019
			001e010380000078ecee91a3544c9926
			0f5054230800d1c0b300950081006140
			4540814081c0023a801871382d40582c
			250058c31000001e000000fc00000a20
			20202020202020202020000000ff0000
			0a2020202020202020202020000000fd
			00383f545413000a20202020202001a2
			020332f24f10100413131f6c6c6c6c6c
			6c6c4b4ce200d5e30500002309070783
			01000067030c0010000048e606000000
			0000023a801871382d40582c250058c3
			1000001e011d007251d01e206e285500
			58c31000001e00000000000000000000
			00000000000000000000000000000000
			0000000000000000000000000000007e
	2 DPMS:
		flags: enum
		enums: On=0 Standby=1 Suspend=2 Off=3
		value: 0
	5 link-status:
		flags: enum
		enums: Good=0 Bad=1
		value: 0
	6 non-desktop:
		flags: immutable range
		values: 0 1
		value: 0
	4 TILE:
		flags: immutable blob
		blobs:

		value:
	250 subconnector:
		flags: immutable enum
		enums: Unknown=0 VGA=1 DVI-D=3 HDMI=11 DP=10 Wireless=18 Native=15
		value: 15
	251 audio:
		flags: enum
		enums: force-dvi=18446744073709551614 off=18446744073709551615 auto=0 on=1
		value: 0
	240 Broadcast RGB:
		flags: enum
		enums: Automatic=0 Full=1 Limited 16:235=2
		value: 0
	252 max bpc:
		flags: range
		values: 6 12
		value: 12
	253 Colorspace:
		flags: enum
		enums: Default=0 RGB_Wide_Gamut_Fixed_Point=13 RGB_Wide_Gamut_Floating_Point=14 opRGB=7 DCI-P3_RGB_D65=11 BT2020_RGB=9 BT601_YCC=15 BT709_YCC=2 XVYCC_601=3 XVYCC_709=4 SYCC_601=5 opYCC_601=6 BT2020_CYCC=8 BT2020_YCC=10
		value: 0
	7 HDR_OUTPUT_METADATA:
		flags: blob
		blobs:

		value:
	254 vrr_capable:
		flags: immutable range
		values: 0 1
		value: 0
	255 Content Protection:
		flags: enum
		enums: Undesired=0 Desired=1 Enabled=2
		value: 0
	256 HDCP Content Type:
		flags: enum
		enums: HDCP Type0=0 HDCP Type1=1
		value: 0
258	0	disconnected	DP-2           	0x0		0	257
  props:
	1 EDID:
		flags: immutable blob
		blobs:

		value:
	2 DPMS:
		flags: enum
		enums: On=0 Standby=1 Suspend=2 Off=3
		value: 3
	5 link-status:
		flags: enum
		enums: Good=0 Bad=1
		value: 0
	6 non-desktop:
		flags: immutable range
		values: 0 1
		value: 0
	4 TILE:
		flags: immutable blob
		blobs:

		value:
	250 subconnector:
		flags: immutable enum
		enums: Unknown=0 VGA=1 DVI-D=3 HDMI=11 DP=10 Wireless=18 Native=15
		value: 0
	251 audio:
		flags: enum
		enums: force-dvi=18446744073709551614 off=18446744073709551615 auto=0 on=1
		value: 0
	240 Broadcast RGB:
		flags: enum
		enums: Automatic=0 Full=1 Limited 16:235=2
		value: 0
	263 max bpc:
		flags: range
		values: 6 12
		value: 12
	264 Colorspace:
		flags: enum
		enums: Default=0 RGB_Wide_Gamut_Fixed_Point=13 RGB_Wide_Gamut_Floating_Point=14 opRGB=7 DCI-P3_RGB_D65=11 BT2020_RGB=9 BT601_YCC=15 BT709_YCC=2 XVYCC_601=3 XVYCC_709=4 SYCC_601=5 opYCC_601=6 BT2020_CYCC=8 BT2020_YCC=10
		value: 0
	7 HDR_OUTPUT_METADATA:
		flags: blob
		blobs:

		value:
	265 vrr_capable:
		flags: immutable range
		values: 0 1
		value: 0
	255 Content Protection:
		flags: enum
		enums: Undesired=0 Desired=1 Enabled=2
		value: 0
	256 HDCP Content Type:
		flags: enum
		enums: HDCP Type0=0 HDCP Type1=1
		value: 0

## 解决
最后解决了，似乎是在更新了内核后，i915也就是intel的核显驱动得到了更新，所以能正确识别外部的hdmi和dp接口了。

之前从kali切过来就是因为显示驱动的问题，不过现在已经再也回不去了。毕竟arch比kali香多了。
