# Raspberry Pi 软件构建 #

## 目录 ##

script
======
各软件编译脚本.
  - 脚本文件名与软件名相同
  - `软件名-版本` 与 source 目录下源码压缩包解压目录名相同
  - PKG_DEPENDS 列出了该软件直接依赖的下层软件, 没有列出间接依赖的软件.
    手工逐个编译时应保证下层软件均已编译安装. 使用批量编译脚本`mbuild.sh`
    会根据依赖关系递归处理.
  - 其他参数定义用于创建 `.deb` 二进制安装包.
  - 定义编译函数 buildpkg(), 用于设置不同软件自身要求的配置选项及编译命令

source
======
源码解压目录. 源码压缩包须手工解压到此目录下, 解压后的主目录名格式应为
``软件名-版本``. 若目录格式与 script 目录下对应的文件描述不符将导致无法
编译.

target
======
安装目录. 编译后的软件会按规定的目录结构复制到该目录. 其中包括二进制程序、
作为二次开发的库和头文件. 本系统大多数情况只建立共享库, 不建立静态库.

stamp
=====
编译标记. 编译过的软件包会在此目录下生成以软件名命名的空文件, 作为建立编译
依赖关系的依据. 当批量编译多个项目时会检查依赖库是否已编译. 若尚未编译则会
自动递归编译有依赖关系的库

## 文件描述 ##

build.sh
========
编译命令. 编译指定的软件包. 其功能如下:
  - 定义编译器及选项
  - 导入 script 目录下的脚本和 mkpackage 脚本
  - 调用 `buildpkg` 函数编译
  - 调用 mkpackage 创建 `.deb` 安装包
  - 对部分文件做一些后期处理
  - 将编译生成的文件复制到 target 目录.

用法示例:
     > sh build.sh fontconfig

上面的命令单独编译 fontconfig

mbuild.sh
=========
批量编译命令, 根据每个脚本中的 PKG_DEPENDS 递归编译所有依赖库.
用法示例:
     > sh build.sh fontconfig

上面的命令以编译 fontconfig 为目标. 若依赖关系不满足, 则先编译依赖库.
  **此功能尚不完善, 不能进行错误检查**

meson.conf
==========
meson 配置工具使用的脚本, 由 meson 命令的 --cross-file 选项指定
(见script/libdrm)



下面是目录树结构
```
.
├── build.sh
├── install
│   ├── bin
│   ├── etc
│   ├── lib
│   ├── sbin
│   ├── usr
│   └── var
├── mbuild.sh
├── meson.conf
├── mkpackage
├── script
│   ├── adwaita-icon-theme
│   ├── alsa-lib
│   ├── alsa-utils
│   ├── atk
│   ├── at-spi2-atk
│   ├── at-spi2-core
│   ├── bash
│   ├── bigreqsproto
│   ├── binutils
│   ├── bzip2
│   ├── cairo
│   ├── camorama
│   ├── compositeproto
│   ├── curl
│   ├── damageproto
│   ├── dbus
│   ├── dbus-glib
│   ├── dconf
│   ├── dosfstools
│   ├── dpkg
│   ├── dri2proto
│   ├── dri3proto
│   ├── dropbear
│   ├── e2fsprogs
│   ├── enchant
│   ├── evince
│   ├── exo
│   ├── expat
│   ├── ffmpeg
│   ├── ffmpeg.bak
│   ├── file
│   ├── fixesproto
│   ├── flac
│   ├── fontconfig
│   ├── fontsproto
│   ├── freetype
│   ├── fribidi
│   ├── garcon
│   ├── gcc
│   ├── GConf
│   ├── gdk-pixbuf
│   ├── git
│   ├── glib
│   ├── glibc
│   ├── glproto
│   ├── gmp
│   ├── gnome-terminal
│   ├── gsettings-desktop-schemas
│   ├── gspell
│   ├── gtk+
│   ├── harfbuzz
│   ├── hicolor-icon-theme
│   ├── hostapd
│   ├── inputproto
│   ├── ion
│   ├── iptables
│   ├── isl
│   ├── iso-codes
│   ├── jasper
│   ├── jasper.old
│   ├── kbproto
│   ├── lcms2
│   ├── libass
│   ├── libcap
│   ├── libdrm
│   ├── libdrm_conf
│   ├── libepoxy
│   ├── libevdev
│   ├── libexif
│   ├── libffi
│   ├── libfontenc
│   ├── libftdi1
│   ├── libgcrypt
│   ├── libgpg-error
│   ├── libICE
│   ├── libid3tag
│   ├── libIDL
│   ├── libjpeg-turbo
│   ├── libjpeg-turbo.old
│   ├── libmicrohttpd
│   ├── libmnl
│   ├── libnftnl
│   ├── libnl-tiny
│   ├── libnotify
│   ├── libogg
│   ├── libpciaccess
│   ├── libpng
│   ├── libpthread-stubs
│   ├── libressl
│   ├── librsvg
│   ├── libsecret
│   ├── libSM
│   ├── libsndfile
│   ├── libtool
│   ├── libusb
│   ├── libvorbis
│   ├── libwnck
│   ├── libX11
│   ├── libXau
│   ├── libXaw
│   ├── libXaw3d
│   ├── libxcb
│   ├── libXcomposite
│   ├── libXcursor
│   ├── libXdamage
│   ├── libXdmcp
│   ├── libXext
│   ├── libxfce4ui
│   ├── libxfce4util
│   ├── libXfixes
│   ├── libXfont2
│   ├── libXft
│   ├── libXi
│   ├── libXinerama
│   ├── libxkbfile
│   ├── libxml2
│   ├── libXmu
│   ├── libXpm
│   ├── libXrandr
│   ├── libXrender
│   ├── libXres
│   ├── libXScrnSaver
│   ├── libxshmfence
│   ├── libXt
│   ├── libXtst
│   ├── libXxf86vm
│   ├── lirc
│   ├── mesa
│   ├── mesa_conf
│   ├── minidlna
│   ├── motion
│   ├── mpc
│   ├── mpfr
│   ├── mpv
│   ├── mtdev
│   ├── ncurses
│   ├── openjpeg
│   ├── openssh
│   ├── ORBit2
│   ├── pango
│   ├── pcre
│   ├── pcre2
│   ├── pixman
│   ├── poppler
│   ├── presentproto
│   ├── pulseaudio
│   ├── pygame
│   ├── Python
│   ├── python2
│   ├── python3
│   ├── randrproto
│   ├── readline
│   ├── recordproto
│   ├── renderproto
│   ├── resourceproto
│   ├── RPi.GPIO
│   ├── rtmpdump
│   ├── scrnsaverproto
│   ├── SDL2
│   ├── setxkbmap
│   ├── soxr
│   ├── sqlite3
│   ├── systemd
│   ├── tcl
│   ├── Thunar
│   ├── tiff
│   ├── tk
│   ├── tz
│   ├── util-linux
│   ├── util-macros
│   ├── v4l-utils
│   ├── videoproto
│   ├── vim
│   ├── vte
│   ├── webkitgtk
│   ├── wpa_supplicant
│   ├── x11vnc
│   ├── xauth
│   ├── xcb-proto
│   ├── xcmiscproto
│   ├── xextproto
│   ├── xf86dgaproto
│   ├── xf86driproto
│   ├── xf86-input-evdev
│   ├── xf86-video-fbdev
│   ├── xf86vidmodeproto
│   ├── xfce4-appfinder
│   ├── xfce4-icon-theme
│   ├── xfce4-panel
│   ├── xfce4-session
│   ├── xfce4-settings
│   ├── xfce4-terminal
│   ├── xfconf
│   ├── xfdesktop
│   ├── xfwm4
│   ├── xfwm4-themes
│   ├── xineramaproto
│   ├── xkbcomp
│   ├── xkeyboard-config
│   ├── xorgproto
│   ├── xorg-server
│   ├── xproto
│   ├── xset
│   ├── xterm
│   ├── xtrans
│   ├── xz
│   └── zlib
├── source
│   ├── adwaita-icon-theme-3.34.3
│   ├── alsa-lib-1.2.3
│   ├── alsa-utils-1.2.3
│   ├── atk-2.26.1
│   ├── at-spi2-atk-2.26.2
│   ├── at-spi2-core-2.26.3
│   ├── binutils-2.34
│   ├── bzip2-1.0.8
│   ├── cairo-1.16.0
│   ├── compositeproto-0.4.2
│   ├── damageproto-1.2.1
│   ├── dbus-1.13.10
│   ├── dpkg-1.18.24
│   ├── dri2proto-2.8
│   ├── dri3proto-1.0
│   ├── dropbear-2018.76
│   ├── evince-3.34.2
│   ├── exo-0.12.8
│   ├── expat-2.2.9
│   ├── ffmpeg-4.2.3
│   ├── fixesproto-5.0
│   ├── fltk-1.3.5
│   ├── fluxbox-1.3.7
│   ├── flwm-1.02
│   ├── fontconfig-2.13.1
│   ├── freetype-2.10.1
│   ├── garcon-0.6.4
│   ├── gcc-9.2.0
│   ├── gdk-pixbuf-2.36.0
│   ├── git-2.27.0
│   ├── glib-2.53.4
│   ├── glproto-1.4.17
│   ├── gmp-6.2.0
│   ├── gnutls-3.3.0
│   ├── gtk+-3.24.4
│   ├── harfbuzz-2.6.4
│   ├── hostapd-2.8
│   ├── hostapd-2.9
│   ├── inputproto-2.3.2
│   ├── iptables-1.8.4
│   ├── isl-0.15
│   ├── kbproto-1.0.7
│   ├── lcms2-2.8
│   ├── libcap-2.27
│   ├── libdrm-2.4.102
│   ├── libepoxy-1.5.3
│   ├── libffi-3.3
│   ├── libfontenc-1.1.3
│   ├── libftdi1-1.3
│   ├── libgcrypt-1.7.6
│   ├── libgcrypt-1.8.6
│   ├── libgpg-error-1.27
│   ├── libgpg-error-1.38
│   ├── libICE-1.0.10
│   ├── libjpeg-turbo-2.0.3
│   ├── libmicrohttpd-0.9.54
│   ├── libmnl-1.0.4
│   ├── libnftnl-1.1.5
│   ├── libnl-tiny-1.0.1
│   ├── libnotify-0.7.3
│   ├── libpciaccess-0.16
│   ├── libpng-1.6.37
│   ├── libpthread-stubs-0.4
│   ├── libressl-2.7.2
│   ├── libsecret-0.20.1
│   ├── libSM-1.2.3
│   ├── libudev-devd-0.4.2
│   ├── libudev-zero
│   ├── libusb-1.0.21
│   ├── libwnck-3.20.1
│   ├── libX11-1.6.9
│   ├── libXau-1.0.9
│   ├── libxcb-1.14
│   ├── libXcomposite-0.4.5
│   ├── libXcursor-1.2.0
│   ├── libXdamage-1.1.5
│   ├── libXext-1.3.4
│   ├── libxfce4ui-4.14.1
│   ├── libxfce4util-4.14.0
│   ├── libXfixes-5.0.3
│   ├── libXfont2-2.0.4
│   ├── libXft-2.3.2
│   ├── libXi-1.7.10
│   ├── libXinerama-1.1.3
│   ├── libxkbfile-1.1.0
│   ├── libxml2-2.9.4
│   ├── libXmu-1.1.3
│   ├── libXrandr-1.5.2
│   ├── libXrender-0.9.10
│   ├── libxshmfence-1.3
│   ├── libXt-1.2.0
│   ├── libXtst-1.2.3
│   ├── libXxf86vm-1.1.4
│   ├── lirc-0.9.4d
│   ├── mesa-20.3.3
│   ├── motion-4.3
│   ├── mpc-1.1.0
│   ├── mpfr-4.1.0
│   ├── mpv-0.32.0
│   ├── ncurses-6.1
│   ├── ncurses-6.2
│   ├── openssh-7.5p1
│   ├── pango-1.41.0
│   ├── pixman-0.40.0
│   ├── poppler-0.45.0
│   ├── pygame-1.9.1release
│   ├── Python-3.8.2
│   ├── randrproto-1.5.0
│   ├── readline-8.0
│   ├── recordproto-1.14.2
│   ├── renderproto-0.11.1
│   ├── SDL2-2.0.5
│   ├── setxkbmap-1.3.1
│   ├── sqlite-3.32.3
│   ├── systemd-233
│   ├── tcl-8.6.9
│   ├── Thunar-1.8.9
│   ├── tiff-4.0.10
│   ├── tk-8.6.9
│   ├── tz-2019b
│   ├── util-linux-2.33.2
│   ├── v4l-utils-1.14.2
│   ├── vim-8.0
│   ├── webkitgtk-2.30.4
│   ├── x11vnc-0.9.14
│   ├── xauth-1.0.10
│   ├── xbitmaps-1.1.2
│   ├── xcb-proto-1.14
│   ├── xextproto-7.3.0
│   ├── xf86-video-fbdev-0.5.0
│   ├── xfce4-appfinder-4.14.0
│   ├── xfce4-panel-4.14.0
│   ├── xfce4-session-4.14.0
│   ├── xfce4-settings-4.14.0
│   ├── xfconf-4.14.1
│   ├── xfdesktop-4.14.1
│   ├── xfwm4-4.14.0
│   ├── xineramaproto-1.2.1
│   ├── xinit-1.3.4
│   ├── xkbcomp-1.4.0
│   ├── xkeyboard-config-2.20
│   ├── xorgproto-2020.1
│   ├── xorg-server-1.20.6
│   ├── xproto-7.0.31
│   ├── xsetroot-1.1.2
│   ├── xtrans-1.4.0
│   ├── xz-5.2.4
│   └── zlib-1.2.11
├── stamp
│   ├── adwaita-icon-theme
│   ├── atk
│   ├── at-spi2-atk
│   ├── at-spi2-core
│   ├── binutils
│   ├── bzip2
│   ├── cairo
│   ├── compositeproto
│   ├── damageproto
│   ├── dbus
│   ├── dri2proto
│   ├── dri3proto
│   ├── evince
│   ├── expat
│   ├── fixesproto
│   ├── fontconfig
│   ├── freetype
│   ├── gcc
│   ├── gdk-pixbuf
│   ├── glib
│   ├── glproto
│   ├── gtk+
│   ├── harfbuzz
│   ├── hostapd
│   ├── inputproto
│   ├── iptables
│   ├── kbproto
│   ├── libcap
│   ├── libdrm
│   ├── libepoxy
│   ├── libffi
│   ├── libgcrypt
│   ├── libgpg-error
│   ├── libICE
│   ├── libjpeg-turbo
│   ├── libmicrohttpd
│   ├── libmnl
│   ├── libnftnl
│   ├── libnl-tiny
│   ├── libpciaccess
│   ├── libpng
│   ├── libpthread-stubs
│   ├── libressl
│   ├── libsecret
│   ├── libX11
│   ├── libXau
│   ├── libxcb
│   ├── libXcomposite
│   ├── libXdamage
│   ├── libXext
│   ├── libXfixes
│   ├── libXft
│   ├── libXi
│   ├── libXinerama
│   ├── libxml2
│   ├── libXrandr
│   ├── libXrender
│   ├── libxshmfence
│   ├── libXtst
│   ├── mesa
│   ├── ncurses
│   ├── openssh
│   ├── pango
│   ├── pixman
│   ├── pygame
│   ├── Python3
│   ├── randrproto
│   ├── recordproto
│   ├── renderproto
│   ├── sqlite
│   ├── systemd
│   ├── tcl
│   ├── tiff
│   ├── tk
│   ├── util-linux
│   ├── v4l-utils
│   ├── vim
│   ├── xcb-proto
│   ├── xextproto
│   ├── xineramaproto
│   ├── xorgproto
│   ├── xproto
│   ├── xtrans
│   ├── xz
│   └── zlib
└── target
    ├── bin
    ├── etc
    ├── lib
    ├── sbin
    ├── usr
    └── var
```
