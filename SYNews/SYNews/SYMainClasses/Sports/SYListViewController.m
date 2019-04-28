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
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *leftItem;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) SYGameListModel *selectedModel;
@property (nonatomic, strong) NSArray *startDatas;
@property (nonatomic, strong) NSArray *unStartDatas;
@property (nonatomic, strong) NSArray *recommend_AI;
@property (nonatomic, assign) BOOL exit;
@property (nonatomic, assign) BOOL isWatching;

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
    if (self.type == SYListTypeCategory) {
        self.navigationItem.rightBarButtonItem = self.rightItem;
        self.navigationItem.leftBarButtonItem = self.leftItem;
    }
}

- (void)dataAction {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SYDataAnalyzeManager sharedSYDataAnalyzeManager] calculatorDatas];
    });
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

- (void)watchRefresh {
    self.isWatching = !self.isWatching;
    if (self.isWatching) {
        [self.leftItem setTitle:@"监控中"];
        [[SYSportDataManager sharedSYSportDataManager].timer fire];
        [[SYNBADataManager sharedSYNBADataManager].timer fire];
    }else {
        [self.leftItem setTitle:@"监控"];
        
        [[SYSportDataManager sharedSYSportDataManager].timer invalidate];
        [[SYNBADataManager sharedSYNBADataManager].timer invalidate];
        
        [SYSportDataManager sharedSYSportDataManager].timer = nil;
        [SYNBADataManager sharedSYNBADataManager].timer = nil;
    }
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
    NSMutableArray *tempArrayAI = [NSMutableArray array];
    for (SYGameListModel *model in self.datas) {
        if (model.dateSeconds <= [[NSDate date] timeIntervalSince1970]) {
            [tempArrayStart insertObject:model atIndex:0];
        }else {
            [tempArrayUnStart addObject:model];
        }
        
        SYGameListModel *model_AI = [SYGameListModel mj_objectWithKeyValues:model.mj_keyValues];
        
        if (model_AI.probability.gl_home > 0.6) {
            model_AI.recommendType = SYGameScoreTypeHome;
        }else if (model_AI.probability.gl_draw > 0.6) {
            model_AI.recommendType = SYGameScoreTypeDraw;
        }else if (model_AI.probability.gl_away > 0.6) {
            model_AI.recommendType = SYGameScoreTypeAway;
        }else if ([model_AI.AsianAvrLet doubleValue] > 0 && (model_AI.probability.gl_home + model_AI.probability.gl_draw > 0.6)) {
            model_AI.recommendType = SYGameScoreTypeHome|SYGameScoreTypeDraw;
        }else if ([model_AI.AsianAvrLet doubleValue] < 0 && (model_AI.probability.gl_away + model_AI.probability.gl_draw > 0.6)) {
            model_AI.recommendType = SYGameScoreTypeAway|SYGameScoreTypeDraw;
        }
        
        if (model_AI.recommendType > 0) {
            [tempArrayAI addObject:model_AI];
        }
    }

    self.recommend_AI = tempArrayAI;
    self.startDatas = tempArrayStart;
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
        if (self.segment.selectedSegmentIndex == 0) {
            return self.startDatas.count;
        } else if (self.segment.selectedSegmentIndex == 1) {
            return self.unStartDatas.count;
        }else {
            return self.recommend_AI.count;
        }
    }else {
        return self.datas.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameListCell class])];
    cell.recommend = self.type == SYListTypeNear && self.segment.selectedSegmentIndex == 2;
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
        if (self.segment.selectedSegmentIndex == 0) {
            model = self.startDatas[indexPath.row];
        } else if (self.segment.selectedSegmentIndex == 1) {
            model = self.unStartDatas[indexPath.row];
        }else {
            model = self.recommend_AI[indexPath.row];
        }
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
        [[SYSportDataManager sharedSYSportDataManager] replaceNameForTeamId:self.selectedModel.HomeTeamId.integerValue byName:renameView.homeTextField.text];
        [[SYSportDataManager sharedSYSportDataManager] replaceNameForTeamId:self.selectedModel.AwayTeamId.integerValue byName:renameView.awayTextField.text];
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
            [[SYSportDataManager sharedSYSportDataManager] changeScoreWithModels:@[weakSelf.selectedModel]];
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
        _segment = [[UISegmentedControl alloc] initWithItems:@[@" 滚球 ",@" 即将开始 ",@" AI推荐 "]];
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

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"计算" style:UIBarButtonItemStyleDone target:self action:@selector(dataAction)];
        _rightItem.tintColor = [UIColor whiteColor];
    }
    return _rightItem;
}

- (UIBarButtonItem *)leftItem {
    if (_leftItem == nil) {
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"监控" style:UIBarButtonItemStyleDone target:self action:@selector(watchRefresh)];
        _leftItem.tintColor = [UIColor whiteColor];
    }
    return _leftItem;
}

@end
