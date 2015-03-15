#!/bin/bash

GV_url="http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz"

DEPEND=(
	"libogg"
)

GV_args=(
	"--host=${GV_host}"
	"--enable-shared"
	"--disable-static"
	"--disable-examples"
	"--program-prefix=${UV_target}-"
	"--sbindir=${GV_base_dir}/tmp/sbin"
	"--libexecdir=${GV_base_dir}/tmp/libexec"
	"--sysconfdir=${GV_base_dir}/tmp/etc"
	"--localstatedir=${GV_base_dir}/tmp/var"
	"--datarootdir=${GV_base_dir}/tmp/share"
)

FU_get_names_from_url
FU_installed "theora.pc"

if [ $? == 1 ]; then
	FU_get_download
	FU_extract_tar
	FU_build "-j1"
fi
