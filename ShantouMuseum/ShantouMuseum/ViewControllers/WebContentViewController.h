//
//  WebContentViewController.h
//  ShantouMuseum
//
//  Created by jiahui on 15/5/13.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const WebImageDocmentName    = @"webViewImage";
@class ContentNode;

@interface WebContentViewController : UIViewController

@property (strong, nonatomic) ContentNode *nodeLeaf;

@end
