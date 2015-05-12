//
//  LeafListViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/12.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "LeafListViewController.h"
#import "ContentNode.h"

@interface LeafListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    BOOL isHasImage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LeafListViewController

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
    
    NSString *cellIdentifier = nil;
    if (isHasImage) {
        cellIdentifier = @"imageAndLabelCell";
    } else {
        cellIdentifier = @"onlyLabelsCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ContentNode *currentNod = _arrayContents[indexPath.row];
    cell.textLabel.text = currentNod.title;
    if (currentNod.isImg) {
        cell.imageView.backgroundColor = [UIColor yellowColor];
    }
    return cell;
}

#pragma mark - UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
