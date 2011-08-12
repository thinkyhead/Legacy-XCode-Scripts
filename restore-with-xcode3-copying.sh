#!/bin/bash
#
# Add legacy support to XCode 4 using only XCode 4
# This version makes a local copy to reduce the chance future updates can break it
#
# Author: Scott Lahteine
# License: MIT
# Notice: Use at your own risk. Tested on my system and it worked.
#
# Derived from http://tumblr.splhack.org/post/7866228357/enable-powerpc-toolchain-on-xcode-4-1
#
# TODO: If source and archive are on the same volume make hardlinks instead of copies
#

GCCVER=4.2.1

# request and process arguments
read -p "XCode 4 install path (/Developer): " -e XCODE4
if [ ! -n "$XCODE4" ]; then XCODE4="/Developer"; fi
XCODE4=`echo "$XCODE4" | sed -e "s/\/*$//"`

if [ ! -d "$XCODE4/Applications/XCode.app" ]; then
  echo "XCode can't be found at $XCODE4"
  exit 0
fi

PPCARCHIVE="$XCODE4/PPCRestored"
sudo rm -r "$PPCARCHIVE"

IOSPATH=Platforms/iPhoneOS.platform/Developer/usr
IOSUSR="$XCODE4/$IOSPATH"
IOSARC="$PPCARCHIVE/$IOSPATH"
PPC10=bin/powerpc-apple-darwin10
PPC11=usr/bin/powerpc-apple-darwin11

# make an archive folder with iOS bin path
sudo mkdir -p "$IOSARC/bin"

# copy gcc libexec items
LGD=libexec/gcc/darwin
GCCPATH="$IOSARC/$LGD"
sudo mkdir -p $GCCPATH
sudo cp -R "$IOSUSR/$LGD/ppc" $GCCPATH

# copy gcc bin items
for ITEM in cpp gcc g++; do
  sudo cp "$IOSUSR/$PPC10-$ITEM-$GCCVER" "$IOSARC/$PPC10-$ITEM-$GCCVER"
done

# copy gcc include items
INCATOM=include/gcc/darwin
GCCINC="$IOSARC/$INCATOM"
sudo mkdir -p $GCCINC
sudo cp -R "$IOSUSR/$INCATOM/4.2" $GCCINC

# copy gcc lib items
LIBGCC=lib/gcc
GCCLIB="$IOSARC/$LIBGCC"
sudo mkdir -p $GCCLIB
sudo cp -R "$IOSUSR/$LIBGCC/powerpc-apple-darwin10" $GCCLIB

# now that everything's copied, make all necessary links

for DIR in "$XCODE4" ""; do
  sudo rm "$DIR/usr/$LGD/ppc"
  sudo ln -s "$IOSARC/$LGD/ppc" "$DIR/usr/$LGD/ppc"
  for ITEM in cpp gcc g++; do
    sudo rm "$DIR/$PPC11-$ITEM-$GCCVER"
    sudo ln -s "$IOSARC/$PPC10-$ITEM-$GCCVER" "$DIR/$PPC11-$ITEM-$GCCVER"
  done
done

sudo rm "$XCODE4/SDKs/MacOSX10.6.sdk/usr/lib/gcc/powerpc-apple-darwin10"
sudo ln -s "$IOSARC/lib/gcc/powerpc-apple-darwin10" "$XCODE4/SDKs/MacOSX10.6.sdk/usr/lib/gcc/powerpc-apple-darwin10"

# "edit" the architecture list
source `dirname $0`/arch-change.sh
