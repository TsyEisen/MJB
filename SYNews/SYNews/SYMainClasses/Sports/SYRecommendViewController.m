//
//  SYRecommendViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/10/10.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYRecommendViewController.h"
#import "SYGameListCell.h"
#import "SYGameTableCell.h"
#import "ERSwitchView.h"
@interface SYRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ERSwitchView *switchView;
@end

@implementation SYRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.title = @"推介";
   
}

- (void)setUpUI {
    [self.view addSubview:self.switchView];
    [self.view addSubview:self.tableView];
    [self.tableView sy_registerNibWithClass:[SYGameListCell class]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@50);
    }];
//    [self.view addSubview:self.scrollView];
//    CGFloat w = ScreenW;
//    CGFloat h = 50;
//    for (int i = 0; i < [SYSportDataManager sharedSYSportDataManager].recommends.count; i++) {
//        SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[i];
//        SYDataLabel *label = [[SYDataLabel alloc] initWithFrame:CGRectMake(i*w, 0, w, h)];
//        label.font = [UIFont boldSystemFontOfSize:15];
//        label.text = model.name;
//        [self.scrollView addSubview:label];
//
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*w, 20, w, ScreenH - 64-h)];
//        tableView.dataSource = self;
//        tableView.delegate = self;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.rowHeight = UITableViewAutomaticDimension;
//        tableView.estimatedRowHeight = 100;
//        tableView.backgroundColor = [UIColor sy_colorWithRGB:0xf4f4f4];
//        tableView.tag = i;
//        [tableView sy_registerNibWithClass:[SYGameListCell class]];
//        [self.scrollView addSubview:tableView];
//    }
//
//    [self.scrollView setContentSize:CGSizeMake(w * [SYSportDataManager sharedSYSportDataManager].recommends.count, 0)];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[self.switchView.index];
    return model.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameListCell class])];
    cell.recommend = YES;
    SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[self.switchView.index];
    cell.model = model.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[self.switchView.index];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [model deleteModel:model.datas[indexPath.row]];
        [weakSelf.tableView reloadData];
    }];
    return @[action];
}

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

- (ERSwitchView *)switchView {
    if (_switchView == nil) {
        _switchView = [[ERSwitchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _switchView.minMargin = 30;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (SYRecommendModel *model in [SYSportDataManager sharedSYSportDataManager].recommends) {
            [tempArray addObject:model.name];
        }
        __weak typeof(self) weakSelf = self;
        [_switchView setButtonAciton:^(NSInteger index) {
            [weakSelf.tableView reloadData];
            SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[index];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:model.datas.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }];
        _switchView.titles = tempArray;
    }
    return _switchView;
}
//- (UIScrollView *)scrollView {
//    if (_scrollView == nil) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.pagingEnabled = YES;
//    }
//    return _scrollView;
//}
@end
