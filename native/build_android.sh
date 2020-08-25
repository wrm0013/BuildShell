# !/bin/bash

appName=应用名称
api=http://192.168.0.11:3000/api/
keystoreFile=debug.keystore
storePassword=android
alias=androiddebugkey
keyPassword=android
versionName=0.0.3
versionCode=3
buildType=Release

CUR=`pwd`
TMSP=`date +%Y%m%d%H%M%S`
GVER=`git log -1 --pretty=%h`
VERS=${TMSP}_${GVER}
DEP=root/deploy

sed -i '' -e 's|storeFile .*|storeFile file("'${keystoreFile}'")|' \
-e 's|storePassword .*|storePassword "'${storePassword}'"|' \
-e 's|keyAlias = .*|keyAlias = "'${alias}'"|' \
-e 's|keyPassword .*|keyPassword "'${keyPassword}'"|' \
-e 's|versionName .*|versionName "'${versionName}'"|' \
-e 's|versionName .*|versionCode ${versionCode}|' \
./app/build.gradle

if [ ! -d "$DEP" ]; then
    mkdir -p $DEP
fi

./gradlew clean
if [ $buildType == 'Release' ]; then
    ./gradlew app:assembleRelease
    mv ./app/build/outputs/apk/release/app-release.apk $DEP/${buildType}_${VERS}.apk
else
    ./gradlew app:assembleDebug
    mv ./app/build/outputs/apk/debug/app-debug.apk $DEP/${buildType}_${VERS}.apk
fi




