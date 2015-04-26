#!/bin/sh
#
# Install Arduino SDK 1.6.0 on CentOS
#
# Author: maik@mahiso.de
#

VERSION=1.6.3
INSTALLDIR=/opt
ARCHIVE=arduino-$VERSION-linux64.tar.xz

i=$(cat /proc/$PPID/cmdline)
if [[ $UID != 0 ]]; then
    echo "Please type sudo $0 $*to use this."
    exit 1
fi

# Download
if [ ! -d "$INSTALLDIR/arduino-$VERSION" ];
then
	echo "Download install archive."
	wget -O - http://downloads.arduino.cc/$ARCHIVE | tar -xJ
	mv arduino-$VERSION $INSTALLDIR/arduino-$VERSION
	chown -R root:root $INSTALLDIR/arduino-$VERSION
else
	echo "Arduino SDK $VERSION already installed in $INSTALLDIR. Skipped."
fi

# Create/modify link
echo "Link $INSTALLDIR/arduino to $INSTALLDIR/arduino-$VERSION"
rm -f $INSTALLDIR/arduino
ln -sf arduino-$VERSION $INSTALLDIR/arduino

# Add path to SDK to env
if grep -q $INSTALLDIR/arduino /etc/bashrc;
then
	echo "Path to Arduino already in PATH variable. Skipped."
else
	echo "Set PATH variable."
	echo "export PATH=\$PATH:$INSTALLDIR/arduino" >> /etc/bashrc
fi
