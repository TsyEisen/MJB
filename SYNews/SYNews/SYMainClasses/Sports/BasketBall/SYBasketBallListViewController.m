//
//  SYBasketBallListViewController.m
//  SYNews
//
//  Created by leju_esf on 2019/1/3.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYBasketBallListViewController.h"
#import "SYBasketballListCell.h"
#import "SYSelectBox.h"
#import "SYBasketballAnalysisView.h"
@interface SYBasketBallListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) SYSelectBox *dataAnalysisbox;
@property (nonatomic, strong) SYBasketballAnalysisView *dataAnalysis;
@property (nonatomic, strong) NSArray *analysisArray;
@end

@implementation SYBasketBallListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self.tableView sy_registerNibWithClass:[SYBasketballListCell class]];
    [self setupMJRefresh];
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
    self.navigationItem.rightBarButtonItem = self.rightItem;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

- (void)refreshAction{
    if (self.model) {
//        [[SYNBADataManager sharedSYNBADataManager] requestHistoryWithModel:self.model completion:^(id  _Nonnull result) {
//            [self.tableView.mj_header endRefreshing];
//            self.datas = result;
//            [self.tableView reloadData];
//        }];
        
        [[SYNBADataManager sharedSYNBADataManager] requestHistoryWithModel:self.model completion:^(NSArray * _Nonnull result, NSArray * _Nonnull groups) {
            [self.tableView.mj_header endRefreshing];
            self.datas = groups;
            self.analysisArray = result;
            [self.tableView reloadData];
        }];
        
    }else {
        [[SYNBADataManager sharedSYNBADataManager] requestDatasByType:SYNBAListTypeHistory Completion:^(NSArray * _Nonnull datas) {
            [self.tableView.mj_header endRefreshing];
            self.datas = datas;
            self.analysisArray = datas;
            [self.tableView reloadData];
        }];
    }
}

- (void)dataAction {
    [self.dataAnalysisbox showDependentOnPoint:CGPointMake(ScreenW - 40,64)];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return 1+self.datas.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model) {
        if (section == 0) {
            return 1;
        }else {
            NSArray *array = self.datas[section - 1];
            return array.count;
        }
    }else {
        return self.datas.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYBasketballListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYBasketballListCell class])];
    cell.currentGame = self.model;
    cell.model = [self modelWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"正赛";
    }else if (section == 1) {
        return @"交战历史";
    }else if (section == 2) {
        return @"间接对战";
    }else if (section == 3){
        return @"主队历史";
    }else {
        return @"客队历史";
    }
}

- (SYBasketBallModel *)modelWithIndexPath:(NSIndexPath *)indexPath {
    if (self.model) {
        if (indexPath.section == 0) {
            return self.model;
        }else {
            NSArray *array = self.datas[indexPath.section - 1];
            return array[indexPath.row];
        }
    }else {
        return self.datas[indexPath.row];
    }
}

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
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (SYSelectBox *)dataAnalysisbox {
    if (_dataAnalysisbox == nil) {
        _dataAnalysisbox = [[SYSelectBox alloc] initWithSize:CGSizeMake(ScreenW - 20, 280) direction:SYSelectBoxArrowPositionTopRight andCustomView:self.dataAnalysis];
    }
    return _dataAnalysisbox;
}

- (SYBasketballAnalysisView *)dataAnalysis {
    if (_dataAnalysis == nil) {
        _dataAnalysis = [SYBasketballAnalysisView viewFromNib];
        _dataAnalysis.datas = self.analysisArray;
    }
    return _dataAnalysis;
}

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"数据" style:UIBarButtonItemStyleDone target:self action:@selector(dataAction)];
        _rightItem.tintColor = [UIColor whiteColor];
    }
    return _rightItem;
}

@end
