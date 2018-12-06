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
#import "MJRefresh.h"
#import "SYPickerTool.h"
#import "SYScorePicker.h"
#import "SYRecommendPicker.h"
#import "SYAlertView.h"
#import "SYRenameView.h"
@interface SYListViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SYScorePicker *scorePicker;
@property (nonatomic, strong) SYRecommendPicker *recommendPicker;
//@property (nonatomic, strong) SYRenameView *renameView;
@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) SYGameListModel *selectedModel;
@property (nonatomic, strong) NSArray *startDatas;
@property (nonatomic, strong) NSArray *unStartDatas;
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
    
    if (self.type == SYListTypeNear) {
        self.navigationItem.titleView = self.segment;
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
        
        if (self.type == SYListTypeCategory) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSArray *item in self.datas) {
                SYGameListModel *model = item.firstObject;
                [tempArray addObject:[model.SortName substringToIndex:2]];
                self.titles = tempArray;
            }
        }
        
        if (self.type == SYListTypeNear) {
            [self segmentChange];
        }
        [self.tableView reloadData];
    }];
}

- (void)segmentChange {
    NSMutableArray *tempArrayStart = [NSMutableArray array];
    NSMutableArray *tempArrayUnStart = [NSMutableArray array];
    for (SYGameListModel *model in self.datas) {
        if (model.dateSeconds <= [[NSDate date] timeIntervalSince1970]) {
            [tempArrayStart addObject:model];
        }else {
            [tempArrayUnStart addObject:model];
        }
    }
    self.startDatas = [tempArrayStart reverseObjectEnumerator];
    self.unStartDatas = tempArrayUnStart;
    [self.tableView reloadData];
}

#pragma mark - tableView DataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.type == SYListTypeCategory || self.type == SYListTypeNoScore) {
        NSArray *item = self.datas[section];
        SYGameListModel *model = item.firstObject;
        return model.SortName;
    }else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == SYListTypeCategory || self.type == SYListTypeNoScore) {
        return self.datas.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == SYListTypeCategory || self.type == SYListTypeNoScore) {
        return [self.datas[section] count];
    }else if (self.type == SYListTypeNear){
        return self.segment.selectedSegmentIndex == 0 ? self.startDatas.count : self.unStartDatas.count;
    }else {
        return self.datas.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameListCell class])];
    cell.model = [self modelFromIndexPath:indexPath];
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.titles;
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
            self.recommendPicker.model = [self modelFromIndexPath:indexPath];
            [self.recommendPicker show];
        }];
        [alert addAction:action2];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *deleteAlertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *deleteAlertAction2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[SYSportDataManager sharedSYSportDataManager] deleteModel:self.selectedModel];
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.datas];
                [tempArray removeObjectAtIndex:indexPath.row];
                self.datas = tempArray;
                [self.tableView reloadData];
            }];
            [deleteAlert addAction:deleteAlertAction1];
            [deleteAlert addAction:deleteAlertAction2];
            [self.navigationController presentViewController:deleteAlert animated:YES completion:nil];
            
        }];
        [alert addAction:action3];
    
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
        }];
        [alert addAction:action4];
    
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
    if (self.type == SYListTypeNoScore) {
        __weak typeof(self) weakSelf = self;
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.datas[indexPath.section]];
            [tempArray removeObjectAtIndex:indexPath.row];
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.datas];
            if (tempArray.count == 0) {
                [temp removeObjectAtIndex:indexPath.section];
            }else {
                [temp replaceObjectAtIndex:indexPath.section withObject:tempArray];
            }
            [[SYSportDataManager sharedSYSportDataManager] deleteModel:model];
            self.datas = temp.copy;
            [weakSelf.tableView reloadData];
        }];
        
        UITableViewRowAction *renameaction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"命名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            weakSelf.selectedModel = model;
            [weakSelf renameAction];
            [weakSelf.tableView reloadData];
        }];
        return @[action,renameaction];
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
    if (self.type == SYListTypeCategory || self.type == SYListTypeNoScore) {
        model = self.datas[indexPath.section][indexPath.row];
    }else if (self.type == SYListTypeNear){
        model = self.segment.selectedSegmentIndex == 0 ? self.startDatas[indexPath.row] : self.unStartDatas[indexPath.row];
    }else{
        model = self.datas[indexPath.row];
    }
    return model;
}

- (void)renameAction {
   SYRenameView *renameView = [SYRenameView viewFromNib];
    renameView.homeLabel.text = self.selectedModel.HomeTeam;
    renameView.awayLabel.text = self.selectedModel.AwayTeam;
    SYAlertView *alert = [[SYAlertView alloc] initWithCustom:renameView cancelButtonTitle:@"取消" conformButtonTitle:@"确定" size:CGSizeMake(260, 140)];
    [alert setConformAction:^{
        [[SYSportDataManager sharedSYSportDataManager] replaceNameForTeamId:self.selectedModel.HomeTeamId byName:renameView.homeTextField.text];
        [[SYSportDataManager sharedSYSportDataManager] replaceNameForTeamId:self.selectedModel.AwayTeamId byName:renameView.awayTextField.text];
    }];
    alert.allowTapBackgroundDismiss = YES;
    [alert show];
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

- (UISegmentedControl *)segment {
    if (_segment == nil) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"  滚球   ",@"  即将开始  "]];
        _segment.tintColor = [UIColor whiteColor];
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

//- (SYRenameView *)renameView {
//    if (_renameView == nil) {
//        _renameView = [SYRenameView viewFromNib];
//    }
//    return _renameView;
//}

- (NSArray *)startDatas {
    if (_startDatas == nil) {
        _startDatas = [[NSArray alloc] init];
    }
    return _startDatas;
}

- (NSArray *)unStartDatas {
    if (_unStartDatas == nil) {
        _unStartDatas = [[NSArray alloc] init];
    }
    return _unStartDatas;
}

@end
