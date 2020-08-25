# !/bin/bash

appName=应用名称
workspace=xxx.xcworkspace
target=xxx
versionName=0.0.2
versionCode=2
api=http://192.168.0.11:3000/api/
identity="Apple Development: xxxx"
profile="xxxxxx"
exportPlist=xxxx/exportOptions.plist
# 如果使用zip压缩成ipa的方式，需要提供logo
logo=xxxxx/logo.png

CUR=`pwd`
DEP=root/deploy/ios
TMSP=`date +%Y%m%d%H%M%S`
GVER=`git log -1 --pretty=%h`
VERS=${TMSP}_${GVER}
infoList=$target/Info.plist

pod install

/usr/libexec/PlistBuddy -c "Set CFBundleShortVersionString $versionName" "$infoList"
/usr/libexec/PlistBuddy -c "Set CFBundleVersion $versionCode" "$infoList"
/usr/libexec/PlistBuddy -c "Set CFBundleDisplayName $appName" "$infoList"


xcodebuild -workspace $workspace -scheme $target -configuration Release -archivePath build/$target.xcarchive clean archive build CODE_SIGN_IDENTITY="${identity}" PROVISIONING_PROFILE="${profile}"

if [ ! -d "$DEP" ]; then
    mkdir -p $DEP
fi

# xcodebuild  -exportArchive -archivePath build/$target.xcarchive -exportOptionsPlist ${PLIST} -exportPath $DEP/$VERS.ipa

# 下面的打包方式是通过zip压缩的方式打包成ipa
mkdir $DEP/Payload
cp -r build/$target.xcarchive/Products/Applications/$target.app $DEP/Payload/$target.app
cp $logo $DEP/iTunesArtwork
cd $DEP
zip -r ${VERS}.ipa Payload iTunesArtwork






