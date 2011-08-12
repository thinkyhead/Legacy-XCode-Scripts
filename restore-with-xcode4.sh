#!/bin/bash
#
# Add legacy support to XCode 4 using only XCode 4
# This version just links to the items in-place.
#
# Author: Scott Lahteine
# License: MIT
# Notice: Use at your own risk. Tested on my system and it worked.
#
# Derived from http://tumblr.splhack.org/post/7866228357/enable-powerpc-toolchain-on-xcode-4-1
#   and http://stackoverflow.com/questions/5333490/how-can-we-restore-ppc-ppc64-as-well-as-full-10-4-10-5-sdk-support-to-xcode-4/5348547
#

GCCVER=4.2.1

# request and process arguments
read -p "XCode 4 install path (/Developer): " -e XCODE4
if [ ! -n "$XCODE4" ]; then XCODE4="/Developer"; fi
XCODE4=`echo "$XCODE4" | sed -e "s/\/*$//"`

if [ ! -d "$XCODE4/Applications/XCode.app" ]; then
  echo "XCode can't be found in $XCODE4"
  exit 0
fi

IOSPATH=Platforms/iPhoneOS.platform/Developer/usr
IOSUSR="$XCODE4/$IOSPATH"
PPC10=bin/powerpc-apple-darwin10
PPC11=usr/bin/powerpc-apple-darwin11

for DIR in "$XCODE4" ""; do
  sudo ln -sf "$IOSUSR/libexec/gcc/darwin/ppc" "$DIR/usr/libexec/gcc/darwin/ppc"
  for ITEM in cpp gcc g++; do
    sudo ln -sf "$IOSUSR/$PPC10-$ITEM-$GCCVER" "$DIR/$PPC11-$ITEM-$GCCVER"
  done
done

sudo ln -sf "$IOSUSR/lib/gcc/powerpc-apple-darwin10" "$XCODE4/SDKs/MacOSX10.6.sdk/usr/lib/gcc/powerpc-apple-darwin10"

# "edit" the architecture list
source `dirname $0`/arch-change.sh
