## 1.4.0

- Fix iOS crashes and missing permission issues by switching to latest full VideoIDSDK v1.2.0
- Update minimum iOS version from 11 to 12 to support VideoIDSDK v1.2.0
- Add defaultDocument parameter to VideoIDConfiguration to allow setting default document (Android only for now).

## 1.3.0

- Update minSdkVersion to 21

## 1.2.0

- Migrate from VideoIDSDK to VideoIDLiteSDK so the plugin can run in Xcode 14 which dropped bitcode support.
- Support VideoID `checkRequirements` on iOS

## 1.1.0

### Update VideoIDSDK to 1.0.17

Fixes compilation issues with newer versions of Xcode that use Swift 5.7.

## 1.0.0

- Initial release with basic support for running Video ID and checking Video ID requirements on Android and iOS. 
