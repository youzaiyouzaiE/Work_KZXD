//
//  AppDelegate.h
//  ShantouMuseum
//
//  Created by jiahui on 15/5/5.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (MainViewController *)getMainViewController;

@end

