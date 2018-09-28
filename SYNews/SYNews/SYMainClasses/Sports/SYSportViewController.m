//
//  SYSportViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYSportViewController.h"
#import "SYGameListViewController.h"
#import "SYSportModel.h"
#import "SYSportDataManager.h"

@interface SYSportViewController ()

@end

@implementation SYSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager.type = ListRequestPageTypeHomeSport;
//    [self.tableView cxt_registerCellWithClass:[RPYLiveListCell class]];
    [self requestData];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.manager.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *temp = self.manager.datas[section];
    return temp.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    NSArray *temp = self.manager.datas[indexPath.section];
    SYSportModel *model = temp[indexPath.row];
    cell.textLabel.text = model.FullName;
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == self.manager.datas.count - 1) {
//        [self.manager loadMoreData];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYGameListViewController *vc = [SYGameListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    NSArray *temp = self.manager.datas[indexPath.section];
    SYSportModel *model = temp[indexPath.row];
    vc.sportId = model.Id;
    vc.title = model.SortName;
    [self.navigationController pushViewController:vc animated:YES];
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

@end
