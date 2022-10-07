#import "FlutterElectronicIdPlugin.h"
#if __has_include(<flutter_electronicid/flutter_electronicid-Swift.h>)
#import <flutter_electronicid/flutter_electronicid-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_electronicid-Swift.h"
#endif

@implementation FlutterElectronicIdPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterElectronicIdPlugin registerWithRegistrar:registrar];
}
@end
