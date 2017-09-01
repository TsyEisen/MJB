//
//  SYHomeNewsViewController.m
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYHomeNewsViewController.h"
#import "SYNewsDetailViewController.h"
#import "SYHomeNewsCell.h"
#import "SYCarouselView.h"

@interface SYHomeNewsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) SYCarouselView *carouselView;
@end

@implementation SYHomeNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestDataWithSection:self.section];
    [self.tableView sy_registerNibWithClass:[SYHomeNewsCell class]];
    self.tableView.tableHeaderView = self.carouselView;
}

- (void)requestDataWithSection:(NSInteger)section {
    [APIRequest requestHomeDataWithSection:section completion:^(id result, NSError *error) {
        self.list = result;
        self.carouselView.adList = self.list;
        [self.tableView reloadData];
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
    SYHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYHomeNewsCell class])];
    cell.model = self.list[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYHomeNewsModel *model = self.list[indexPath.row];
    [self pushToDetailVcWithNewsId:model.newsId];
}

- (void)pushToDetailVcWithNewsId:(NSString *)newsId {
    SYNewsDetailViewController *newsDetailVc = [SYNewsDetailViewController instancetFromNib];
    newsDetailVc.newsId = newsId;
    newsDetailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsDetailVc animated:YES];
}

#pragma mark - 懒加载

- (NSArray *)list {
    if (_list == nil) {
        _list = [[NSArray alloc] init];
    }
    return _list;
}

- (SYCarouselView *)carouselView {
    if (_carouselView == nil) {
        _carouselView = [[SYCarouselView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*0.5)];
        __weak typeof(self) weakSelf = self;
        [_carouselView setClickAction:^(NSString *newId) {
            [weakSelf pushToDetailVcWithNewsId:newId];
        }];
    }
    return _carouselView;
}

@end
