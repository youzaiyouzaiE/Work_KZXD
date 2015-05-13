//
//  LeafListViewController.h
//  ShantouMuseum
//
//  Created by jiahui on 15/5/12.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChannelTree;

@interface LeafListViewController : UIViewController

@property (nonatomic, strong) ChannelTree *fatherChannel;
@property (nonatomic, strong) NSArray *arrayContents;

@end
