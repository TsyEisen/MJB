//
//  SYDiscoverViewController.m
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYDiscoverViewController.h"
#import "SYDiscoverCell.h"
#import "MJRefresh.h"
#import "SYDiscoverDetailViewController.h"

@interface SYDiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation SYDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView sy_registerNibWithClass:[SYDiscoverCell class]];
    [self setUpRefresh];
}

- (void)setUpRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestData {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    [APIRequest requestDistoverDataWithPage:self.page completion:^(id result, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.isLoading = NO;
        if (result) {
            if (self.page == 1) {
                [self.list removeAllObjects];
            }
            [self.list addObjectsFromArray:result];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYDiscoverCell class])];
    cell.model = self.list[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYDiscoverNewsModel *model = self.list[indexPath.section];
    SYDiscoverDetailViewController *detailVc = [SYDiscoverDetailViewController instancetFromNib];
    detailVc.newid = model.VoaId;
    detailVc.title = model.Title;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.list.count - 2 && self.isLoading == NO) {
        self.page ++;
        [self requestData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (NSMutableArray *)list {
    if (_list == nil) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}
@end
