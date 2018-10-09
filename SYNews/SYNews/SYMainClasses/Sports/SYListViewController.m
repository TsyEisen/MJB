//
//  SYListViewController.m
//  SYNews
//
//  Created by 唐绍禹 on 2018/9/23.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYListViewController.h"
#import "SYGameListCell.h"
#import "SYSportDataManager.h"
#import "SYInputScoreViewController.h"

@interface SYListViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,assign)SYListType type;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation SYListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self.tableView sy_registerNibWithClass:[SYGameListCell class]];
    if (self.type == SYListTypeCategory) {
        [[SYSportDataManager sharedSYSportDataManager] reuqestAllSportsCompletion:^{
            [self.tableView reloadData];
        }];
    }
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

- (void)setUpUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

- (void)refreshAction {
    if (self.type == SYListTypeCollection) {
        _datas = nil;
        [self.tableView reloadData];
    }else {
        [[SYSportDataManager sharedSYSportDataManager] reuqestAllSportsCompletion:^{
            _datas = nil;
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - tableView DataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.type == SYListTypeCategory) {
        SYGameListModel *model = [[[SYSportDataManager sharedSYSportDataManager].categaryList objectAtIndex:section] objectAtIndex:0];
        return model.SortName;
    }else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == SYListTypeCategory) {
        return [SYSportDataManager sharedSYSportDataManager].categaryList.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == SYListTypeCategory) {
        return [self.datas[section] count];
    }else {
        return self.datas.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameListCell class])];
    cell.model = [self modelFromIndexPath:indexPath];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == self.manager.datas.count - 1) {
//        [self.manager loadMoreData];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SYGameDataViewController *vc = [SYGameDataViewController instancetFromNib];
//    SYGameListModel *model = self.manager.datas[indexPath.row];
//    vc.eventId = model.EventId;
//    [self.navigationController pushViewController:vc animated:YES];
    SYGameListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"输入比分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SYInputScoreViewController *vc = [SYInputScoreViewController instancetFromNib];
        vc.model = [self modelFromIndexPath:indexPath];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [alert addAction:action1];
    if (self.type != SYListTypeCollection) {
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[SYSportDataManager sharedSYSportDataManager] saveHotGame:cell.model];
        }];
        [alert addAction:action2];
    }
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action3];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListModel *model = [self modelFromIndexPath:indexPath];
    if (self.type == SYListTypeCollection) {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [[SYSportDataManager sharedSYSportDataManager] deleteHotGame:model];
            [self.tableView reloadData];
        }];
        return @[action];
    }else {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"复制" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@ %@VS%@",model.SortName,model.HomeTeam,model.AwayTeam];
            [MBProgressHUD showSuccess:@"复制成功" toView:nil];
        }];
        return @[action];
    }
    
}

- (SYGameListModel *)modelFromIndexPath:(NSIndexPath *)indexPath {
    SYGameListModel *model = nil;
    if (self.type == SYListTypeCategory) {
        model = self.datas[indexPath.section][indexPath.row];
    }else {
        model = self.datas[indexPath.row];
    }
    return model;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [UIView new];
//}

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

- (SYListType)type {
    if (_type == 0) {
        if ([self.title isEqualToString:@"赛事"]) {
            _type = SYListTypeCategory;
        }else if ([self.title isEqualToString:@"临近"]) {
            _type = SYListTypeNear;
        }else if ([self.title isEqualToString:@"交易"]) {
            _type = SYListTypePayTop;
        }else if ([self.title isEqualToString:@"历史"]) {
            _type = SYListTypeHistory;
        }else {
            _type = SYListTypeCollection;
        }
    }
    return _type;
}

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refreshAction)];
        _rightItem.tintColor = [UIColor whiteColor];
    }
    return _rightItem;
}

- (NSArray *)datas {
    if (_datas == nil) {
        if (self.type == SYListTypeCategory) {
            _datas = [SYSportDataManager sharedSYSportDataManager].categaryList;
        }else if (self.type == SYListTypeNear){
            _datas = [SYSportDataManager sharedSYSportDataManager].nearList;
        }else if (self.type == SYListTypePayTop){
            _datas = [SYSportDataManager sharedSYSportDataManager].payTopList;
        }else if (self.type == SYListTypeHistory){
            _datas = [[SYSportDataManager sharedSYSportDataManager] getAllHistoryGames];
        }else {
            _datas = [SYSportDataManager sharedSYSportDataManager].hotGameList;
        };
    }
    return _datas;
}
@end
