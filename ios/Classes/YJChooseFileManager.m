//
//  YJChooseFileManager.m
//  FileImagePick
//
//  Created by 冯英杰 on 2020/11/20.
//
#define WeakSelf __weak typeof(self) weakSelf = self;

#import "YJChooseFileManager.h"
#import <UIKit/UIKit.h>
@interface YJChooseFileManager()<UIDocumentPickerDelegate>
@property (nonatomic, strong) UIDocumentPickerViewController *documentPickerVC;
@property (nonatomic, strong) UIViewController *selfVc;
@end
@implementation YJChooseFileManager
static YJChooseFileManager *instance = nil;

+(instancetype)shareInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[YJChooseFileManager alloc] init];
	});
	return instance;
}
//获取文件
-(void)getFileWithVC:(UIViewController *)vc resultBlock:(YJFileResultBlock)resultBlock
{
	_selfVc = vc;
	_resultBlock = resultBlock;
	[vc presentViewController:self.documentPickerVC animated:YES completion:nil];
}
/**
 初始化 UIDocumentPickerViewController
 
  allowedUTIs 支持的文件类型数组
 "public.content",
 "public.text",
 "public.source-code",
 "public.image",
 "public.audiovisual-content",
 "com.adobe.pdf",
 "com.apple.keynote.key",
 "com.microsoft.word.doc",
 "com.microsoft.excel.xls",
 "com.microsoft.powerpoint.ppt"
  支持的共享模式
 */
- (UIDocumentPickerViewController *)documentPickerVC {
	if (!_documentPickerVC) {
		NSArray *types = @[@"com.adobe.pdf",@"com.microsoft.word.doc",@"com.microsoft.excel.xls",@"com.microsoft.powerpoint.​ppt",@"org.openxmlformats.wordprocessingml.document",@"org.openxmlformats.presentationml.presentation",@"org.openxmlformats.spreadsheetml.sheet",@"public.image"];
		self.documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
		// 设置代理
		_documentPickerVC.delegate = self;
		// 设置模态弹出方式
		_documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	return _documentPickerVC;
}
 
#pragma mark - UIDocumentPickerDelegate
 
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
	// 获取授权
	BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    __weak typeof(self) weakSelf = self;
	if (fileUrlAuthozied) {
		// 通过文件协调工具来得到新的文件地址，以此得到文件保护功能
		NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
		NSError *error;
		[fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
			// 读取文件
			NSString *fileName = [newURL lastPathComponent];
			NSError *error = nil;
			NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
			if (error) {
				// 读取出错
				NSString *str = [NSString stringWithFormat:@"读取文件出错:%@",error.localizedDescription];
				!weakSelf.resultBlock?:weakSelf.resultBlock(NO,nil,nil,nil,str);
			} else {
				// 上传
				NSLog(@"fileName : %@,url:%@", fileName,newURL.absoluteString);
				NSString *url = newURL.absoluteString;
				!weakSelf.resultBlock?:weakSelf.resultBlock(YES,fileData,url,fileName,@"");
			}
			[self.selfVc dismissViewControllerAnimated:YES completion:NULL];
		}];
		[urls.firstObject stopAccessingSecurityScopedResource];
	} else {
		// 授权失败
		!weakSelf.resultBlock?:weakSelf.resultBlock(NO,nil,nil,nil,@"授权失败");
	}
}
#pragma mark - 保存文件到 "文件"
///
- (void)downLoadWithFilePath:(NSString *)filePath {
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 11) {
		
	} else {
		// SHOW_HUD(@"下载文件要求手机系统版本在11.0以上");
		return;
	}
	/**
	/// 保存网络文件到沙盒一
	NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:filePath]];
	NSData *fileData = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
	NSString *temp = NSTemporaryDirectory();
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *fullPath = [self getNativeFilePath:[filePath componentsSeparatedByString:@"/"].lastObject];
	BOOL downResult = [fm createFileAtPath:fullPath contents:fileData attributes:nil];
	*/

	/// 保存网络文件到沙盒二
	NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
	NSString *fullPath = [self getNativeFilePath:[filePath componentsSeparatedByString:@"/"].lastObject];
	BOOL downResult = [fileData writeToFile:fullPath atomically:YES];
	if (downResult) {
		UIDocumentPickerViewController *documentPickerVC = [[UIDocumentPickerViewController alloc] initWithURL:[NSURL fileURLWithPath:fullPath] inMode:UIDocumentPickerModeExportToService];
		// 设置代理
		documentPickerVC.delegate = self;
		// 设置模态弹出方式
		documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
		[self.selfVc.navigationController presentViewController:documentPickerVC animated:YES completion:nil];
	}
}
 
// 获得文件沙盒地址
- (NSString *)getNativeFilePath:(NSString *)fileName {
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSString *munu = [NSString stringWithFormat:@"%@/%@",@"downLoad",fileName];
	NSString *filePath = [path stringByAppendingPathComponent:munu];
	// 判断是否存在,不存在则创建
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir = NO;
	NSMutableArray *theArr = [[filePath componentsSeparatedByString:@"/"] mutableCopy];
	[theArr removeLastObject];
	NSString *thePath = [theArr componentsJoinedByString:@"/"];
	// fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
	BOOL existed = [fileManager fileExistsAtPath:thePath isDirectory:&isDir];
	if ( !(isDir == YES && existed == YES) ) { // 如果文件夹不存在
		[fileManager createDirectoryAtPath:thePath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return filePath;
}

@end
