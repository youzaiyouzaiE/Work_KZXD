//
//  ChildTrunkViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/12.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "ChildTrunkViewController.h"
#import "ChannelTree.h"
#import "ContentNode.h"

@interface ChildTrunkViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ChildTrunkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayContents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"onlyLabelsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChannelTree *selectChannel = _arrayContents[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (selectChannel.hasContent) {
        NSLog(@"有文章,要显示 html ? ");
    } else {
        NSLog(@"没有文章，要显示 txt, \ntext:%@",selectChannel.text);
    }
    
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
