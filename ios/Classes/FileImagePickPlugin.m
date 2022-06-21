#import "FileImagePickPlugin.h"
#import "YJChooseFileManager.h"
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
  // [SwiftFileImagePickPlugin registerWithRegistrar:registrar];
   FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"fw.file.image.pick"
            binaryMessenger:[registrar messenger]];
  FileImagePickPlugin* instance = [[FileImagePickPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"openChooseFile" isEqualToString:call.method]) {
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[YJChooseFileManager shareInstance] getFileWithVC:rootVC resultBlock:^(BOOL isSuccess,NSData * _Nullable data, NSString * _Nullable url, NSString * _Nullable fileName, NSString * _Nullable failureStr) {
      [dic setObject:@(isSuccess) forKey:@"isSuccess"];
      if(data != nil){
       [dic setObject:data forKey:@"fileData"];
      }
      [dic setObject:url forKey:@"filePath"];
      [dic setObject:fileName forKey:@"fileName"];
      [dic setObject:failureStr forKey:@"failure"];
      result(dic);
    }];
  } else if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
