#!/bin/bash

GV_url="http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/3.1.0/opencv-3.1.0.zip?r=&ts=1457551989&use_mirror=netcologne"
GV_sha1="8c932b68fe2e1575e88dde759ab1ed1d53d6f41b"

GV_depend=(
	"cryptodev"
)

FU_tools_get_names_from_url
GV_version=${GV_version%.zip}
FU_tools_installed "opencv.pc"

if [ $? == 1 ]; then
	
	FU_tools_check_depend

	GV_args=()
	
	FU_file_get_download
	FU_file_extract_tar
	
	GV_dir_name="opencv-3.1.0"

	GV_name=${GV_dir_name%-*}
	GV_version=${GV_dir_name##$GV_name*-}
	GV_extension="zip"
	
	$SED -i 's/4.6/'$($UV_target-gcc -dumpversion)'/g' \
		"${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake"
	
	$SED -i 's/-${GCC_COMPILER_VERSION}//g' \
		"${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake"
	
	replace="${UV_toolchain_dir//\//\\/}"
	$SED -i "s/\/usr\/arm-linux-gnueabi\${FLOAT_ABI_SUFFIX}/${replace}/g" \
		"${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake"

	if [ -d "${GV_source_dir}/${GV_dir_name}/build" ]; then 
		rm -rf "${GV_source_dir}/${GV_dir_name}/build"
	fi
	
	mkdir -p "${GV_source_dir}/${GV_dir_name}/build"
	
	cd "${GV_source_dir}/${GV_dir_name}/build"
	
	if [ "${UV_board}" == "beaglebone" ]; then 
		softfp="OFF"
		hardfp="ON"
		enable_neon="ON"
		
	elif [ "${UV_board}" == "raspi" ]; then 
		softfp="OFF"
		hardfp="ON"
		enable_neon="OFF"
		$SED -i 's/-mthumb//g' \
			"${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake"
		
	elif [ "${UV_board}" == "hardfloat" ]; then 
		softfp="OFF"
		hardfp="ON"
		enable_neon="OFF"
		
	else
		softfp="ON"
		hardfp="OFF"
		enable_neon="OFF"
	fi
	
	GV_args=(
		"-DSOFTFP=${softfp}"
		"-DCMAKE_TOOLCHAIN_FILE='${GV_source_dir}/${GV_dir_name}/platforms/linux/arm-gnueabi.toolchain.cmake'"
		"-DCMAKE_SYSTEM_LIBRARY_PATH:PATH='${UV_sysroot_dir}/lib'"
		"-DCMAKE_SYSTEM_INCLUDE_PATH:PATH='${UV_sysroot_dir}/include'"
		"-DCMAKE_LIBRARY_PATH:PATH='${UV_sysroot_dir}/lib'"
		"-DCMAKE_INCLUDE_PATH:PATH='${UV_sysroot_dir}/include'"
		"-DCMAKE_INSTALL_PREFIX='$UV_sysroot_dir'"
		"-DENABLE_VFPV3=${hardfp}"
		"-DENABLE_NEON=${enable_neon}"
		"${GV_source_dir}/${GV_dir_name}"
	)
	

	FU_build_configure_cmake
	FU_build_make
	FU_build_install
	
fi
