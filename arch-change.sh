# Add some text to XCode's architecture list so it appears in the interface, please
# I'm too lazy to script it...

cat <<DELIM
Almost done. Now paste this in the right place in your editor...

{
  Type = Architecture;
  Identifier = ppc;
  Name = "Minimal (32-bit PowerPC only)";
  Description = "32-bit PowerPC";
  PerArchBuildSettingName = "PowerPC";
  ByteOrder = big;
  ListInEnum = No;
  SortNumber = 201;
},
DELIM

cd "$XCODE4/Platforms/MacOSX.platform/Developer/Library/Xcode/Specifications"
(which mate && mate "MacOSX Architectures.xcspec") || (which bbedit && bbedit "MacOSX Architectures.xcspec")
