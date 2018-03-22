#Configurations.
#This script designed for Mac OS X command-line, so does not use Xcode build variables.
#But you can use it freely if you want.

TARGET=sns
ACTION="clean build"
FILE_NAME=libsns.a

DEVICE=iphoneos3.2
SIMULATOR=iphonesimulator3.2






#Build for all platforms/configurations.

xcodebuild -configuration Debug -target ${TARGET} -sdk ${DEVICE} ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO
xcodebuild -configuration Debug -target ${TARGET} -sdk ${SIMULATOR} ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO
xcodebuild -configuration Release -target ${TARGET} -sdk ${DEVICE} ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO
xcodebuild -configuration Release -target ${TARGET} -sdk ${SIMULATOR} ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO







#Merge all platform binaries as a fat binary for each configurations.

DEBUG_DEVICE_DIR=${SYMROOT}/Debug-iphoneos
DEBUG_SIMULATOR_DIR=${SYMROOT}/Debug-iphonesimulator
DEBUG_UNIVERSAL_DIR=${SYMROOT}/Debug-universal

RELEASE_DEVICE_DIR=${SYMROOT}/Release-iphoneos
RELEASE_SIMULATOR_DIR=${SYMROOT}/Release-iphonesimulator
RELEASE_UNIVERSAL_DIR=${SYMROOT}/Release-universal

rm -rf "${DEBUG_UNIVERSAL_DIR}"
rm -rf "${RELEASE_UNIVERSAL_DIR}"
mkdir "${DEBUG_UNIVERSAL_DIR}"
mkdir "${RELEASE_UNIVERSAL_DIR}"

#xcodebuild -sdk iphoneos
#xcodebuild -sdk iphonesimulator
#lipo -create -output libJsonKit.a build/Release-iphoneos/libJsonKit.a build/Release-iphonesimulator/libJsonKit.a

lipo -create -output "${DEBUG_UNIVERSAL_DIR}/${FILE_NAME}" "${DEBUG_DEVICE_DIR}/${FILE_NAME}" "${DEBUG_SIMULATOR_DIR}/${FILE_NAME}"
lipo -create -output "${RELEASE_UNIVERSAL_DIR}/${FILE_NAME}" "${RELEASE_DEVICE_DIR}/${FILE_NAME}" "${RELEASE_SIMULATOR_DIR}/${FILE_NAME}"

