#!/bin/bash
#
# Add legacy support to XCode 4 using resources from XCode 3
# Resources are left in place, while this only makes links
#
# Author: Scott Lahteine
# License: MIT
# Notice: Use at your own risk. Tested on my system and it worked.
#
# Based on http://stackoverflow.com/questions/5333490/how-can-we-restore-ppc-ppc64-as-well-as-full-10-4-10-5-sdk-support-to-xcode-4/5348547
#

GCCVER=4.2.1

# request and process arguments
read -p "XCode 3 install path (/XCode3): " -e XCODE3
if [ ! -n "$XCODE3" ]; then XCODE3="/XCode3"; fi
XCODE3=`echo "$XCODE3" | sed -e "s/\/*$//"`

read -p "XCode 4 install path (/Developer): " -e XCODE4
if [ ! -n "$XCODE4" ]; then XCODE4="/Developer"; fi
XCODE4=`echo "$XCODE4" | sed -e "s/\/*$//"`

if [ ! -d "$XCODE3/Applications/XCode.app" ]; then
  echo "XCode 3 can't be found in $XCODE3"
  exit 0
fi
if [ ! -d "$XCODE4/Applications/XCode.app" ]; then
  echo "XCode 4 can't be found in $XCODE4"
  exit 0
fi

cd "$XCODE4"

# Restore 10.4/10.5 SDK Support
for VER in "10.5" "10.4u"; do
  SRC="$XCODE3/SDKs/MacOSX$VER.sdk"
  if [ -e "$SRC" ]; then sudo ln -s "$SRC" SDKs; fi
done

# Restore GCC 4.0 Support
for SRC_FILE in $XCODE3/usr/bin/*4.0*; do sudo ln -s "$SRC_FILE" usr/bin; done

sudo ln -s "$XCODE3/Library/Xcode/Plug-ins/GCC 4.0.xcplugin" \
  "Library/Xcode/PrivatePlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins"

# Restore PPC support for GCC 4.2 (both XCode and CL)
ULG=usr/libexec/gcc
PAD10=powerpc-apple-darwin10
for DIR in "$XCODE4" ""; do
  cd "$DIR"
  sudo ln -sf "$XCODE3/$ULG/$PAD10" "$ULG/$PAD10"
  sudo ln -sf "$XCODE3/usr/lib/gcc/$PAD10" "usr/lib/gcc/$PAD10"
  cd "$ULG/$PAD10/$GCCVER"
  if [ -h as ]; then
    echo "Didn't replace 'as' because it is already a link."
  else
    sudo mv as as.bak
    sudo ln -s "$XCODE3/usr/bin/as" .
  fi
done

# "edit" the architecture list
source `dirname $0`/arch-change.sh
