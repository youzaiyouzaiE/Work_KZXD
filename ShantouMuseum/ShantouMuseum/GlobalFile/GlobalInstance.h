//
//  GlobalInstance.h
//  BaiJiaCar
//
//  Created by jiahui on 15/1/18.
//  Copyright (c) 2015年 jiahui. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GlobalInstance : NSObject

+ (instancetype)sharedManager;


- (void)showMessageToView:(UIView *)view message:(NSString *)message;
- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide;

+ (NSString *)intervalSinceNow:(NSString *)theDate;
+ (float)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt;
+(float)APPVersion;

@end
