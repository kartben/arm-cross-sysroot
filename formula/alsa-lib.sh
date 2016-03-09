#!/bin/bash

GV_url="ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.0.tar.bz2"
GV_sha1="94b9af685488221561a73ae285c4fddaa93663e4"

GV_depend=()

FU_tools_get_names_from_url
FU_tools_installed "alsa.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=(
		"--host=${GV_host}"
		"--prefix=${GV_prefix}" 
		"--program-prefix=${UV_target}-"
		"--libdir=${UV_sysroot_dir}/lib"
		"--includedir=${UV_sysroot_dir}/include"
		"--enable-shared"
		"--disable-static"
		"--disable-python"
	)
	
	FU_file_get_download
	FU_file_extract_tar
		
	FU_build_configure
	FU_build_make
	FU_build_install "install-strip"
	FU_build_finishinstall
fi
