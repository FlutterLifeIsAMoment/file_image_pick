#import "FileImagePickPlugin.h"
#if __has_include(<file_image_pick/file_image_pick-Swift.h>)
#import <file_image_pick/file_image_pick-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "file_image_pick-Swift.h"
#endif

@implementation FileImagePickPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFileImagePickPlugin registerWithRegistrar:registrar];
}
@end
