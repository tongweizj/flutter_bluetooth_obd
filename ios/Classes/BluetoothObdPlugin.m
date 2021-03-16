#import "BluetoothObdPlugin.h"
#if __has_include(<bluetooth_obd/bluetooth_obd-Swift.h>)
#import <bluetooth_obd/bluetooth_obd-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bluetooth_obd-Swift.h"
#endif

@implementation BluetoothObdPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBluetoothObdPlugin registerWithRegistrar:registrar];
}
@end
