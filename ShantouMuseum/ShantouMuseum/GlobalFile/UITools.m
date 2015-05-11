//
//  UITools.m
//  SmartLift-iPhone
//
//  Created by jiahui on 14-9-25.
//  Copyright (c) 2014年 wdz. All rights reserved.
//

#import "UITools.h"

@interface UITools  (){
    UIAlertView *_autoDismissAlert;
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

-(void)performAlretDismiss:(id)sender
{
    [(UIAlertView*)sender dismissWithClickedButtonIndex:0 animated:NO];
    [(UIAlertView*)sender removeFromSuperview];
}

+ (UIImage *)imageWithName:(NSString *)name andType:(NSString *)type
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (void)setNavigationTitlViewString:(NSString *)title andTitleColor:(UIColor *)color forViewController:(UIViewController *)controller
{
    UILabel *titleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 168, 44)];
    titleTextLabel.backgroundColor = [UIColor clearColor];
    titleTextLabel.textColor = [UIColor whiteColor];
    titleTextLabel.font = [UIFont fontWithName:@"黑体" size:80];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.text = title;
    controller.navigationItem.titleView = titleTextLabel;
}

#define NAVIGATION_COLOR [UIColor colorWithRed:255.0f/255.0f green:173.0f/255.0f blue:104.0f/255.0f alpha:1.0]

+ (void)setNavigationLeftButtonTitle:(NSString *)leftBtnStr leftAction:(SEL)action rightBtnStr:(NSString *)rightBtnStr rightAction:(SEL)rightAction rightBtnSelected:(NSString *)rightBtnStateName navigationTitleStr:(NSString *)title forViewController:(UIViewController *)controller
{
    if ( IOS7_OR_LATER )
    {
        controller.edgesForExtendedLayout = UIRectEdgeNone;
        controller.extendedLayoutIncludesOpaqueBars = NO;
        controller.modalPresentationCapturesStatusBarAppearance = NO;
        [controller.navigationController.navigationBar setBarTintColor:NAVIGATION_COLOR];
    }
    else{
        [[UINavigationBar appearance] setTintColor:NAVIGATION_COLOR];
    }
    
    UILabel *titleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 168, 44)];
    titleTextLabel.backgroundColor = [UIColor clearColor];
//    titleTextLabel.textColor = [UIColor whiteColor];
    titleTextLabel.font = [UIFont fontWithName:@"黑体" size:80];
    titleTextLabel.textAlignment = NSTextAlignmentCenter;
    titleTextLabel.text = title;
    controller.navigationItem.titleView = titleTextLabel;
    
    UIView *navigationLeftItem_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
    navigationLeftItem_view.backgroundColor = [UIColor clearColor];
    UIButton * navigationLeftItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
    [navigationLeftItemBtn setTitle:leftBtnStr forState:UIControlStateNormal];
    if ([controller respondsToSelector:action]) {
        [navigationLeftItemBtn addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [navigationLeftItem_view addSubview:navigationLeftItemBtn];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:navigationLeftItem_view];
    controller.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIView *navigationRightItem_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
    navigationRightItem_view.backgroundColor = [UIColor clearColor];
    UIButton * navigationRightItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
    [navigationRightItemBtn setTitle:rightBtnStr forState:UIControlStateNormal];
    [navigationRightItemBtn setTitle:rightBtnStateName forState:UIControlStateSelected];
    if ([controller respondsToSelector:rightAction]) {
        [navigationRightItemBtn addTarget:controller action:rightAction forControlEvents:UIControlEventTouchUpInside];
    }
    [navigationRightItem_view addSubview:navigationRightItemBtn];
    UIBarButtonItem *_rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:navigationRightItemBtn];
    _rightBarButton.enabled = YES;
    controller.navigationItem.rightBarButtonItem = _rightBarButton;
}

@end
