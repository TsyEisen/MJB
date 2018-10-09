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
#import "SYPickerViewTool.h"

@interface SYListViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) SYListType type;
@property (nonatomic, strong) SYPickerViewTool *pickerViewTool;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) SYGameListModel *selectedModel;
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
    [self setupMJRefresh];
    
//    self.navigationItem.rightBarButtonItem = self.rightItem;
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"输入比分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        SYInputScoreViewController *vc = [SYInputScoreViewController instancetFromNib];
//        vc.model = [self modelFromIndexPath:indexPath];
//        [self.navigationController pushViewController:vc animated:YES];
        self.selectedModel = [self modelFromIndexPath:indexPath];
        [self show];
    }];
    [alert addAction:action1];
    
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 11;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%zd",row];
}

- (void)show {
    [self.pickerViewTool show];
}

- (void)completScore {
    NSString *homeScore = [self pickerView:self.pickerViewTool.pickerView titleForRow:[self.pickerViewTool.pickerView selectedRowInComponent:0] forComponent:0];
    NSString *awayScore = [self pickerView:self.pickerViewTool.pickerView titleForRow:[self.pickerViewTool.pickerView selectedRowInComponent:1] forComponent:1];
    self.selectedModel.homeScore = homeScore;
    self.selectedModel.awayScore = awayScore;
    self.selectedModel.score = [NSString stringWithFormat:@"%@:%@",homeScore,awayScore];
    [[SYSportDataManager sharedSYSportDataManager] changeScoreModel:self.selectedModel];
    [self.tableView reloadData];
}

#pragma mark - 懒加载

- (SYPickerViewTool *)pickerViewTool {
    if (_pickerViewTool == nil) {
        _pickerViewTool = [[SYPickerViewTool alloc] init];
        _pickerViewTool.delegate = self;
        __weak typeof(self) weakSelf = self;
        [_pickerViewTool setDoneAction:^{
            [weakSelf completScore];
        }];
    }
    return _pickerViewTool;
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
        }
    }
    return _type;
}

//- (UIBarButtonItem *)rightItem {
//    if (_rightItem == nil) {
//        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refreshAction)];
//        _rightItem.tintColor = [UIColor whiteColor];
//    }
//    return _rightItem;
//}

//- (NSArray *)datas {
//    if (_datas == nil) {
//        if (self.type == SYListTypeCategory) {
//            _datas = [SYSportDataManager sharedSYSportDataManager].categaryList;
//        }else if (self.type == SYListTypeNear){
//            _datas = [SYSportDataManager sharedSYSportDataManager].nearList;
//        }else if (self.type == SYListTypePayTop){
//            _datas = [SYSportDataManager sharedSYSportDataManager].payTopList;
//        }else if (self.type == SYListTypeHistory){
//            _datas = [[SYSportDataManager sharedSYSportDataManager] getAllHistoryGames];
//        }else {
//            _datas = [SYSportDataManager sharedSYSportDataManager].hotGameList;
//        };
//    }
//    return _datas;
//}
@end
