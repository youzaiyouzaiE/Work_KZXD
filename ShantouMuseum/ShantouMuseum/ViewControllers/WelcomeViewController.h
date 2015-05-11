//
//  WelcomeViewController.h
//  ShantouMuseum
//
//  Created by jiahui on 15/5/10.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChannelTree;
@protocol wecomViewControllDelegate <NSObject>
- (void)getDataFormServer:(NSMutableArray *)nodeArray andFristNode:(ChannelTree *)fristNode;

@end

@interface WelcomeViewController : UIViewController
@property (assign, nonatomic) id <wecomViewControllDelegate> delegate;

@end
