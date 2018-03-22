#!/bin/bash
#My First Script

#Info to be configured


current_path=$(pwd)
appName="jamesApp"
jamesApp_workspace="jamesAppV2.xcworkspace"

echo "Searching for $jamesApp_workspace workspace..."

if [[ $(ls $jamesApp_workspace) ]];     then
echo "$jamesApp_workspace found in current directory."


echo "Listing all installed and connected devices..."
instruments -s devices

echo "Copy + Paste from above devices"
echo "specify name of your decice to launch $appName"
read d_device_name

echo "building workspace for $d_device_name..."

build_cmd=(xcodebuild -workspace jamesAppV2.xcworkspace -scheme jamesAppV2 -configuration Debug)
destination="'platform=iOS,name=$d_device_name'"

build_cmd+=(-destination "$destination" clean test)

echo "${build_cmd[@]}"
# Here it prints the valid command given above

"${build_cmd[@]}"

else
echo "$jamesApp_workspace workspace not found"
echo "Make sure your current path contains the $jamesApp_workspace workspace"
echo "Place this file i.e deploy.sh within the directory containing $jamesApp_workspace workspace"
fi;
