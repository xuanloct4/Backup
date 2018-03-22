#!/bin/bash
#My First Script

#Info to be configured

target_name="$appname"
sdk="iphoneos"
certificate="iPhone Distribution: Aron Bury"
project_dir="$HOME/Documents/Apps/iOS/awesomeapp/$appname"
build_location="$Home/Builds/$appname
current_path=$(pwd)
appName="jamesApp"
jamesApp_workspace="jamesAppV2.xcworkspace"


if [ ! -d "$build_location" ]; then
mkdir -p "$build_location"
fi

cd "$project_dir"
xcodebuild -target "$appname" OBJROOT="$build_location/obj.root" SYMROOT="$build_location/sym.root"

xcrun -sdk iphoneos PackageApplication -v "$build_location/sym.root/Release-iphoneos/$appname.app" -o "$build_location/$appname.ipa" --sign "$certificate"
