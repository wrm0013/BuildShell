# !/bin/bash
platform=ios # android
DEP=root/bundle/$platform
TMSP=`date +%Y%m%d%H%M%S`
GVER=`git log -1 --pretty=%h`
VERS=${TMSP}_${GVER}
bundleVersion=0.0.3
api=http://192.168.0.111:3001/api/

# 修改成发布环境地址
sed -i '' -e "s|BaseApi .*|BaseApi = '${api}'|" \
-e "s|BundleVersion .*|BundleVersion = '${bundleVersion}'|" \
./src/config/config.js

if [ ! -d "$DEP/bundle" ]; then
    mkdir -p $DEP/bundle
fi
if [ $platform == 'android' ]; then
    yarn build_android_bundle
else
    yarn build_ios_bundle
fi

cd $DEP
zip -r ./${VERS}.zip ./bundle