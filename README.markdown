Legacy XCode Scripts
--------------------

This is a set of scripts to restore PPC support to XCode 4. Although pretty thoroughly tested by the author, these like all scripts have the potential to be dangerous, so use with caution or step through them to minimize issues with _set -x_ or _bash -x script.sh_.

There are three separate scripts included:

- _restore-with-xcode3.sh_ : Make symbolic links to items in your XCode 3 installation.

- _restore-with-xcode3-copying.sh_ : First copy the items from your XCode 3 installation to a new folder within your XCode 4 installation, then make symbolic links to items in the local copy.

- _restore-with-xcode4.sh_ : Make symbolic links to items in your XCode 4 installation, in particular the binaries in the iPhoneOS.platform folder that happen to support PPC.

These scripts are provided under the MIT License and are entirely free for all uses.