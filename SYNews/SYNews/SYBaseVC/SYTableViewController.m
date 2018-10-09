//
//  SYTableViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYTableViewController.h"

@interface SYTableViewController ()

@end

@implementation SYTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setupMJRefresh];
}

- (void)setUpUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

- (void)setupMJRefresh {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.manager loadNewData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestData {
    [self.tableView.mj_header beginRefreshing];
}

- (void)reloadData {
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = [UIColor sy_colorWithRGB:0xf4f4f4];
    }
    return _tableView;
}

- (ListRequestManager *)manager {
    if (_manager == nil) {
        _manager = [[ListRequestManager alloc] init];
        __weak typeof(self) weakSelf = self;
        [_manager setReloadData:^(NSIndexPath *indexPath) {
            [weakSelf reloadData];
        }];
    }
    return _manager;
}
@end
