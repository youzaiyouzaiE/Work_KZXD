//
//  UITools.m
//  SmartLift-iPhone
//
//  Created by jiahui on 14-9-25.
//  Copyright (c) 2014年 wdz. All rights reserved.
//

#import "UITools.h"
#import "ChannelTree.h"

@interface UITools  (){
    UIAlertView *_autoDismissAlert;
    UIAlertView *_msgAlert;
}

@end

@implementation UITools

SHARE_INSTANCET(UITools)

- (void)showAutoDismissAlretView:(NSString *)message Timer:(CGFloat)time
{
    if (message == nil || message.length < 1 || [message isEqualToString:@""]) {
        return ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_autoDismissAlert) {
            _autoDismissAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        }
        _autoDismissAlert.message = message;
        [_autoDismissAlert show];
        [self performSelector:@selector(performAlretDismiss:) withObject:_autoDismissAlert afterDelay:time];
    });
}

- (void)performAlretDismiss:(id)sender {
    [(UIAlertView*)sender dismissWithClickedButtonIndex:0 animated:NO];
    [(UIAlertView*)sender removeFromSuperview];
}

- (void)showAlertViewTitle:(NSString *)title message:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_msgAlert) {
             _msgAlert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        }
        _msgAlert.title = title;
        _msgAlert.message = msg;
        [_msgAlert show];
    });
   
}


+ (UIImage *)imageWithName:(NSString *)name andType:(NSString *)type
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return [UIImage imageWithContentsOfFile:filePath];
}

#pragma mark - documentFile option
- (BOOL)hasTheFileInDirectory:(NSString *)documentName {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *imageDir = [paths[0] stringByAppendingPathComponent:FORMAT(@"%@",documentName)];
    if ([fm fileExistsAtPath:imageDir]) {
        return YES;
    } else
        return NO;
}

- (NSString *)pathForDocumentName:(NSString *)documentName////获取 doment下文件路径
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *imageDir = [paths[0] stringByAppendingPathComponent:FORMAT(@"%@",documentName)];
    if ([fm fileExistsAtPath:imageDir]) {
//        NSLog(@"文件夾已经存在");
        return imageDir;
    } else {
//        NSLog(@"文件夾不存在");
        BOOL creat = [[NSFileManager defaultManager] createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (creat) {
//             NSLog(@"创建%@文件成功！",documentName);
            return imageDir;
        }else {
            NSLog(@"创建%@文件失败！",documentName);
            return @"-1";
        }
    }
}

+ (NSArray *)getFilesInDocumentPath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *pathName = [paths[0] stringByAppendingPathComponent:path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathName]) {
        NSArray *sourceArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathName error:nil];
//        NSMutableArray *mutableArray = [NSMutableArray array];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:sourceArray];
        return mutableArray;
    } else
        return nil;
}

- (BOOL)saveImageToFileParth:parth image:(UIImage *)image inFileName:(NSString *)fileName
{
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *pathName = [self pathForDocumentName:parth];
    if ([pathName isEqualToString:@"-1"]) {
        NSLog(@"创建文件夾失败");
        return NO;
    }
    NSString *filePath = [pathName stringByAppendingPathComponent:fileName];
    return [imgData writeToFile:filePath atomically:YES];
}

+ (NSString *)getImageNameForContentImg:(NSString *)imageUrl {
    NSArray *array =[imageUrl componentsSeparatedByString:@"/"];
    NSString *string = @"";
    for (NSString *str in array) {
        string = [string stringByAppendingString:str];
    }
    return string;
}

+ (NSString *)getSavePathFormLeafNod:(ChannelTree *)leafNod {
    NSMutableArray *nameArray = [NSMutableArray array];
    while (leafNod.parent != nil) {
        if (leafNod.name != nil) {
            [nameArray addObject:leafNod.name];
        }
        leafNod = leafNod.parent;
    }
    if (leafNod.parent == nil && leafNod.name != nil) {
        [nameArray addObject:leafNod.name];
    }
    NSString *pathName = @"";
    for (NSInteger i = nameArray.count -1; i >= 0; i--) {
        pathName = [pathName stringByAppendingPathComponent:nameArray[i]];
    }
    return pathName;
}

- (void)showMessageToView:(UIView *)view message:(NSString *)message
{
    [self showMessageToView:view message:message autoHide:YES];
}

- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    if (autoHide) {
        [hud hide:YES afterDelay:1.5f];
    }
    return hud;
}

- (MBProgressHUD *)showLoadingViewAddToView:(UIView *)view autoHide:(BOOL)autoHide {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    if (autoHide) {
        [hud hide:YES afterDelay:1.5f];
    }
    return hud;
}


@end
