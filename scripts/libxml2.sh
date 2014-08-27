#!/bin/bash

TITLE="libxml2 - XML C parser"

build_libxml2(){

	cd $WORKING_DIR/src
	
	NAME=libxml2
	ARCHIV=$NAME
	URL=git://git.gnome.org/$ARCHIV
 
	# Clone archiv is dir not exists
	if ! [ -d "$WORKING_DIR/src/$NAME" ]; then
	
		echo -n "Cloning $NAME... "
		git clone $URL >/dev/null 2>&1 || exit 1
		echo "done"

	fi
	
	cd $WORKING_DIR/src/$NAME
	
	echo -n "Configure $NAME... "
	if ! [ -f "$WORKING_DIR/src/$NAME/.configured" ]; then

		./autogen.sh >/dev/null 2>&1 || exit 1
		./configure --prefix=$PREFIX --host=$HOST --without-python 2>&1 || exit 1
		touch $WORKING_DIR/src/$NAME/.configured >/dev/null 2>&1 || exit 1
		echo "done"
		
	else 
		echo "skipped"
	fi
	
	echo -n "Make $NAME... "
	if ! [ -f "$WORKING_DIR/src/$NAME/.made" ]; then
		
		make >/dev/null 2>&1 || exit 1
		touch $WORKING_DIR/src/$NAME/.made
		echo "done"
		
	else 
		echo "skipped"
	fi
	
	echo -n "Install $NAME... "
	if ! [ -f "$WORKING_DIR/src/$NAME/.installed" ]; then
		
		make install >/dev/null 2>&1 || exit 1
		touch $WORKING_DIR/src/$NAME/.installed
		echo "done"
		
	else 
		echo "skipped"
	fi	
	
	cd $WORKING_DIR
}