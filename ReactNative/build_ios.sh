# !/bin/bash

appName=应用名称
workspace=xxxx.xcworkspace
target=xxxx
identity="xxxx"
profile="xxxx"
exportPlist=xxxx/exportOptions.plist
api=http://192.168.0.111:3000/api/
# iconFile=/Users/ruisi/Desktop/Images.xcassets
bundleVersion=0.0.1
versionName=0.0.2
versionCode=2
# 如果通过zip压缩的方式打包ipa，需要提供logo
logo=xxxx/logo.png

CUR=`pwd`
APP=${CUR##*/}
PRJ=${APP%%-*}
DEP=root/deploy/$PRJ/$APP/ios
TMSP=`date +%Y%m%d%H%M%S`
GVER=`git log -1 --pretty=%h`
VERS=${TMSP}_${GVER}
bundleFile=./ios/bundle
infoList=$target/Info.plist

yarn install

cd ios && pod install && cd ..
if [ -d $bundleFile ]; then
    rm -rf $bundleFile
fi
mkdir $bundleFile
sed -i '' -e "s|BaseApi .*|BaseApi = '${api}'|" \
-e "s|BundleVersion .*|BundleVersion = '${bundleVersion}'|" \
./src/config/config.js
yarn build_ios

cd ios
# cp -a $iconFile/. ./$target/Images.xcassets
/usr/libexec/PlistBuddy -c "Set CFBundleShortVersionString $versionName" "$infoList"
/usr/libexec/PlistBuddy -c "Set CFBundleVersion $versionCode" "$infoList"
/usr/libexec/PlistBuddy -c "Set CFBundleDisplayName $appName" "$infoList"

xcodebuild -workspace $workspace -scheme $target -configuration Release -archivePath build/$target.xcarchive clean archive build CODE_SIGN_IDENTITY="${identity}" PROVISIONING_PROFILE="${profile}"

if [ ! -d "../$DEP" ]; then
    mkdir -p ../$DEP
fi

# xcodebuild  -exportArchive -archivePath build/$target.xcarchive -exportOptionsPlist ${PLIST} -exportPath ../$DEP/$VERS.ipa

# 一下这种方式是通过zip压缩的方式打成ipa包，需要提供logo
mkdir ../$DEP/Payload
cp -r build/$target.xcarchive/Products/Applications/$target.app ../$DEP/Payload/$target.app
cp $logo ../$DEP/iTunesArtwork
cd ../$DEP
zip -r ${VERS}.ipa Payload iTunesArtwork