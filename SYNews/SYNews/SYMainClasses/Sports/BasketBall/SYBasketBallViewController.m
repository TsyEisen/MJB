//
//  SYBasketBallViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/12/13.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYBasketBallViewController.h"
#import "MJRefresh.h"
#import "SYBasketballListCell.h"
#import "SYNBADataManager.h"
@interface SYBasketBallViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *startDatas;
@property (nonatomic, strong) NSArray *unStartDatas;
@property (nonatomic, strong) NSArray *recommend_AI;
@end

@implementation SYBasketBallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self.tableView sy_registerNibWithClass:[SYBasketballListCell class]];
    [self setupMJRefresh];
    
    self.navigationItem.titleView = self.segment;
}

- (void)setupMJRefresh {
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshAction];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshAction {
    [[SYNBADataManager sharedSYNBADataManager] requestDatasByType:SYNBAListTypeToday Completion:^(NSArray * _Nonnull datas) {
        [self.tableView.mj_header endRefreshing];
        self.datas = datas;
        [self segmentChange];
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
        
//        SYGameListModel *model_AI = [SYGameListModel mj_objectWithKeyValues:model.mj_keyValues];
//
//        if (model_AI.probability.gl_home > 0.6) {
//            model_AI.recommendType = SYGameScoreTypeHome;
//        }else if (model_AI.probability.gl_draw > 0.6) {
//            model_AI.recommendType = SYGameScoreTypeDraw;
//        }else if (model_AI.probability.gl_away > 0.6) {
//            model_AI.recommendType = SYGameScoreTypeAway;
//        }else if ([model_AI.AsianAvrLet doubleValue] > 0 && (model_AI.probability.gl_home + model_AI.probability.gl_draw > 0.6)) {
//            model_AI.recommendType = SYGameScoreTypeHome|SYGameScoreTypeDraw;
//        }else if ([model_AI.AsianAvrLet doubleValue] < 0 && (model_AI.probability.gl_away + model_AI.probability.gl_draw > 0.6)) {
//            model_AI.recommendType = SYGameScoreTypeAway|SYGameScoreTypeDraw;
//        }
        
//        if (model_AI.recommendType > 0) {
//            [tempArrayAI addObject:model_AI];
//        }
    }
    
//    self.recommend_AI = tempArrayAI;
    self.startDatas = tempArrayStart;
    self.unStartDatas = tempArrayUnStart;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segment.selectedSegmentIndex == 0) {
        return self.startDatas.count;
    } else if (self.segment.selectedSegmentIndex == 1) {
        return self.unStartDatas.count;
    }else {
        return self.recommend_AI.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYBasketballListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYBasketballListCell class])];
//    cell.recommend = self.type == SYListTypeNear && self.segment.selectedSegmentIndex == 2;
    cell.model = [self modelFromIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (SYBasketBallModel *)modelFromIndexPath:(NSIndexPath *)indexPath {
    SYBasketBallModel *model = nil;
    if (self.segment.selectedSegmentIndex == 0) {
        model = self.startDatas[indexPath.row];
    } else if (self.segment.selectedSegmentIndex == 1) {
        model = self.unStartDatas[indexPath.row];
    }else {
        model = self.recommend_AI[indexPath.row];
    }
    return model;
}

#pragma mark - 懒加载

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
@end
