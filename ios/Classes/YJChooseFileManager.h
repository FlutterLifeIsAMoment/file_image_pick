//
//  YJChooseFileManager.h
//  FileImagePick
//
//  Created by 冯英杰 on 2020/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^YJFileResultBlock)(BOOL isSuccess, NSData *_Nullable data, NSString *_Nullable url, NSString *_Nullable fileName, NSString *_Nullable failureStr);

@interface YJChooseFileManager : NSObject
@property(nonatomic, strong) YJFileResultBlock resultBlock;

+ (instancetype)shareInstance;

//获取文件
- (void)getFileWithVC:(UIViewController *)vc resultBlock:(YJFileResultBlock)resultBlock;
@end

NS_ASSUME_NONNULL_END
