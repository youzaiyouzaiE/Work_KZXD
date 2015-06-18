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
        NSMutableArray *mutableArray = [NSMutableArray array];
        mutableArray = [NSMutableArray arrayWithArray:sourceArray];
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

#pragma mark- NavigationSet
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

+ (void)navigationBackButtonTitle:(NSString *)backButtonTitle action:(SEL)action target:(UIViewController *)viewController {
//    UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//    NSString *backButtonTitle = previousViewController.navigationItem.backBarButtonItem ? previousViewController.navigationItem.backBarButtonItem.title : previousViewController.title;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle style:UIBarButtonItemStylePlain target:viewController action:action];
    // Appearance
    if ([UIBarButtonItem respondsToSelector:@selector(appearance)]) {
        [newBackButton setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [newBackButton setBackButtonBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
        [newBackButton setBackButtonBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [newBackButton setBackButtonBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsLandscapePhone];
        [newBackButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateNormal];
        [newBackButton setTitleTextAttributes:[NSDictionary dictionary] forState:UIControlStateHighlighted];
    }
    viewController.navigationItem.backBarButtonItem = newBackButton;
}

@end
