//
//  SYGameListViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYGameListViewController.h"
#import "SYGameListModel.h"
#import "SYGameDataViewController.h"
#import "SYSportDataManager.h"

@interface SYGameListViewController ()

@end

@implementation SYGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager.type = ListRequestPageTypeCatagorySport;
    //    [self.tableView cxt_registerCellWithClass:[RPYLiveListCell class]];
    self.manager.params = @{
                            @"league":self.sportId,
                            @"class":@"-1"
                            };
    [self requestData];

}


#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    SYGameListModel *model = self.manager.datas[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ vs %@",model.HomeTeam,model.AwayTeam];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == self.manager.datas.count - 1) {
//        [self.manager loadMoreData];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYGameDataViewController *vc = [SYGameDataViewController instancetFromNib];
    SYGameListModel *model = self.manager.datas[indexPath.row];
    vc.eventId = model.EventId;
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
