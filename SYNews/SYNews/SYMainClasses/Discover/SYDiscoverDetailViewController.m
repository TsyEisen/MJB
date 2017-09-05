//
//  SYDiscoverDetailViewController.m
//  SYNews
//
//  Created by leju_esf on 2017/9/4.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYDiscoverDetailViewController.h"
#import "SYDiscoverDetailCell.h"

@interface SYDiscoverDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *list;
@end

@implementation SYDiscoverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView sy_registerNibWithClass:[SYDiscoverDetailCell class]];
    [self requestData];
}

- (void)requestData {
    [APIRequest requestDistoverDetailWithNewId:self.newid completion:^(id result, NSError *error) {
        if (result) {
            self.list = result;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYDiscoverDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYDiscoverDetailCell class])];
    cell.model = self.list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 懒加载
- (NSArray *)list {
    if (_list == nil) {
        _list = [[NSArray alloc] init];
    }
    return _list;
}

@end
