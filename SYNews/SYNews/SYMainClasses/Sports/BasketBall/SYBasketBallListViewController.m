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
    [[SYNBADataManager sharedSYNBADataManager] requestDatasByType:SYNBAListTypeHistory Completion:^(NSArray * _Nonnull datas) {
        [self.tableView.mj_header endRefreshing];
        self.datas = datas;
        [self.tableView reloadData];
    }];
}

- (void)dataAction {
    [self.dataAnalysisbox showDependentOnPoint:CGPointMake(ScreenW,64)];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYBasketballListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYBasketballListCell class])];
    //    cell.recommend = self.type == SYListTypeNear && self.segment.selectedSegmentIndex == 2;
    cell.model = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        _dataAnalysisbox = [[SYSelectBox alloc] initWithSize:CGSizeMake(ScreenW, 400) direction:SYSelectBoxArrowPositionTopRight andCustomView:self.dataAnalysis];
    }
    return _dataAnalysisbox;
}

- (SYBasketballAnalysisView *)dataAnalysis {
    if (_dataAnalysis == nil) {
        _dataAnalysis = [SYBasketballAnalysisView viewFromNib];
        _dataAnalysis.datas = self.datas;
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
