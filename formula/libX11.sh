#!/bin/bash

GV_url="http://xorg.freedesktop.org/releases/individual/lib/libX11-1.5.0.tar.bz2"

DEPEND=()

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--disable-composecache"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "x11.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	FU_build
fi

#export CFLAGS="${CFLAGS} -I${GV_prefix}/include/X11"
#export CPPFLAGS=$CFLAGS
#export CXXFLAGS=$CPPFLAGS
