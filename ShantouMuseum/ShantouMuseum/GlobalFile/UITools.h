//
//  UITools.h
//  SmartLift-iPhone
//
//  Created by jiahui on 14-9-25.
//  Copyright (c) 2014年 wdz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ChannelTree;

@interface UITools : NSObject


+ (instancetype)getInstancet;

- (void)showAutoDismissAlretView:(NSString *)message Timer:(CGFloat)time;
+ (UIImage *)imageWithName:(NSString *)name andType:(NSString *)type;
- (void)showAlertViewTitle:(NSString *)title message:(NSString *)msg;

#pragma UIDate
- (BOOL)hasTheFileInDirectory:(NSString *)documentName ;
- (NSString *)pathForDocumentName:(NSString *)documentName;
- (BOOL)saveImageToFileParth:parth image:(UIImage *)image inFileName:(NSString *)fileName;
//+ (NSArray *)getFilesInDocumentPath:(NSString *)path;
+ (NSString *)getImageNameForContentImg:(NSString *)imageUrl;
+ (NSString *)getSavePathFormLeafNod:(ChannelTree *)leafNod;

- (void)showMessageToView:(UIView *)view message:(NSString *)message;
- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide;
- (MBProgressHUD *)showLoadingViewAddToView:(UIView *)view autoHide:(BOOL)autoHide;
@end
