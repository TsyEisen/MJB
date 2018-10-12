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
#import "MJRefresh.h"
#import "SYPickerTool.h"
#import "SYScorePicker.h"
#import "SYRecommendPicker.h"

@interface SYListViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SYScorePicker *scorePicker;
@property (nonatomic, strong) SYRecommendPicker *recommendPicker;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) SYGameListModel *selectedModel;
@property (nonatomic, assign) BOOL exit;
@end

@implementation SYListViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.exit = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.exit && self.type != SYListTypeCategory) {
        NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"SYListViewControllerLastRefreshTime_%zd",self.type]];
        if (date && ([date timeIntervalSinceNow] < - 1800)) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self.tableView sy_registerNibWithClass:[SYGameListCell class]];
    [self setupMJRefresh];
    if (self.type == SYListTypeCategory) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:@"dataNeedRefresh" object:nil];
    }
    
}

- (void)setupMJRefresh {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshAction];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setUpUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

- (void)refreshAction {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[NSString stringWithFormat:@"SYListViewControllerLastRefreshTime_%zd",self.type]];
    [[SYSportDataManager sharedSYSportDataManager] requestDatasBySYListType:self.type Completion:^(NSArray *datas) {
        [self.tableView.mj_header endRefreshing];
        self.datas = datas;
        [self.tableView reloadData];
    }];
}

#pragma mark - tableView DataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.type == SYListTypeCategory) {
        NSArray *item = self.datas[section];
        SYGameListModel *model = item.firstObject;
        return model.SortName;
    }else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == SYListTypeCategory) {
        return self.datas.count;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedModel = [self modelFromIndexPath:indexPath];
    if (self.type == SYListTypeHistory) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"输入比分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.scorePicker show];
        }];
        [alert addAction:action1];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"推介" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.recommendPicker show];
        }];
        [alert addAction:action2];
    
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
        }];
        [alert addAction:action3];
    
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }else if(self.type == SYListTypeNoScore){
        [self.scorePicker show];
    }else {
        self.recommendPicker.model = [self modelFromIndexPath:indexPath];
        [self.recommendPicker show];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListModel *model = [self modelFromIndexPath:indexPath];
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"复制" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@ %@VS%@",model.SortName,model.HomeTeam,model.AwayTeam];
        [MBProgressHUD showSuccess:@"复制成功" toView:nil];
    }];
    return @[action];
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

#pragma mark - 懒加载

- (SYScorePicker *)scorePicker {
    if (_scorePicker == nil) {
        _scorePicker = [[SYScorePicker alloc] init];
        __weak typeof(self) weakSelf = self;
        [_scorePicker setScoreAction:^(NSString *homeScore, NSString *awayScore) {
            weakSelf.selectedModel.homeScore = homeScore;
            weakSelf.selectedModel.awayScore = awayScore;
            weakSelf.selectedModel.score = [NSString stringWithFormat:@"%@:%@",homeScore,awayScore];
            [[SYSportDataManager sharedSYSportDataManager] changeScoreModel:weakSelf.selectedModel];
            [weakSelf.tableView reloadData];
        }];
    }
    return _scorePicker;
}

- (SYRecommendPicker *)recommendPicker {
    if (_recommendPicker == nil) {
        _recommendPicker = [[SYRecommendPicker alloc] init];
    }
    return _recommendPicker;
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
@end
