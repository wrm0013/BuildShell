# !/bin/bash

appName=项目名称
keystoreFile=debug.keystore
storePassword=android
alias=androiddebugkey
keyPassword=android
versionName=0.0.2
versionCode=2
api=http://192.168.0.111:9000/api/
bundleVersion=0.0.1
buildType=Release
CUR=`pwd`
APP=${CUR##*/}
PRJ=${APP%%-*}
DEP=root/deploy/$PRJ/$APP/android
TMSP=`date +%Y%m%d%H%M%S`
GVER=`git log -1 --pretty=%h`
VERS=${TMSP}_${GVER}

yarn install
if [ ! -d "./android/app/src/main/assets" ]; then
    mkdir ./android/app/src/main/assets
fi
sed -i '' -e "s|BaseApi .*|BaseApi = '${api}'|" \
-e "s|BundleVersion .*|BundleVersion = '${bundleVersion}'|" \
./src/config/config.js
yarn build_android

cd android
# cp -a $iconFile/. ./app
sed -i '' -e 's|storeFile .*|storeFile file("'${keystoreFile}'")|' \
-e 's|storePassword .*|storePassword "'${storePassword}'"|' \
-e 's|keyAlias .*|keyAlias "'${alias}'"|' \
-e 's|keyPassword .*|keyPassword "'${keyPassword}'"|' \
-e 's|versionName .*|versionName "'${versionName}'"|' \
-e "s|versionCode .*|versionCode $versionCode|" \
./app/build.gradle
# echo "sdk.dir=$sdk" > ./local.properties
rm -rf ./app/src/main/res/[drawable]*
rm -rf ./app/src/main/res/raw

./gradlew clean
if [ ! -d "../$DEP" ]; then
    mkdir -p ../$DEP
fi

if [ $buildType == 'Release' ]; then
    ./gradlew app:assembleRelease
    mv ./app/build/outputs/apk/release/app-release.apk ../$DEP/${buildType}_${VERS}.apk
else
    ./gradlew app:assembleDebug
    mv ./app/build/outputs/apk/debug/app-debug.apk ../$DEP/${buildType}_${VERS}.apk
fi