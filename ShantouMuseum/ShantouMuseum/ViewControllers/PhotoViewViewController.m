//
//  PhotoViewViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/14.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "PhotoViewViewController.h"

@interface PhotoViewViewController ()


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentW;

@end

@implementation PhotoViewViewController


- (void)updateViewConstraints {
    [super updateViewConstraints];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
