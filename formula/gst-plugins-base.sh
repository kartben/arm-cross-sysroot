#!/bin/bash

GV_url="http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-0.10.36.tar.bz2"

DEPEND=(
	"gstreamer"
	"glib"
	"libogg"
	"libtheora"
	"libvorbis"
	"liborc"
	"libvisual"
	"libxml2"
	"zlib"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--program-prefix=${UV_target}-"
	"--disable-nls"
	"--disable-examples"
	"--disable-largefile"
	"--disable-gtk-doc"
	"--disable-app"
	"--disable-alsa" # alsa mixer?
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datadir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "gstreamer-plugins-base-0.10.pc"

if [ $? == 1 ]; then
	
	if [ -f "${UV_sysroot_dir}/bin/glib-genmarshal" ]; then 
		mv "${UV_sysroot_dir}/bin/glib-genmarshal" "${UV_sysroot_dir}/bin/glib-genmarshal_bak"
	fi
	
	TMP_LIBS=$LIBS
	export LIBS="${LIBS} -lpthread -ldl -lXv -lXau -lXext -lX11 -lxcb"
	
	FU_get_download
	FU_extract_tar
	FU_build
	
	unset LIBS
	export LIBS=$TMP_LIBS

	if [ -f "${UV_sysroot_dir}/bin/glib-genmarshal_bak" ]; then 
		mv "${UV_sysroot_dir}/bin/glib-genmarshal_bak" "${UV_sysroot_dir}/bin/glib-genmarshal"
	fi
fi
