ReactNative打包package.json补充说明

1. build_android :

	react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res

2. build_ios :

	react-native bundle --platform ios --dev false --entry-file index.js --bundle-output ios/bundle/main.bundle --assets-dest ios/bundle

3. build_android_bundle :

	react-native bundle --entry-file index.js --bundle-output root/bundle/android/bundle/index.android.jsbundle --platform android --assets-dest root/bundle/android/bundle/ --dev false

4. build_ios_bundle : 

	react-native bundle --entry-file index.js --bundle-output root/bundle/ios/bundle/main.jsbundle --platform ios --assets-dest root/bundle/ios/bundle/ --dev false

