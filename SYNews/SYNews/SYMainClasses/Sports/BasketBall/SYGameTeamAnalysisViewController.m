//
//  SYGameTeamAnalysisViewController.m
//  SYNews
//
//  Created by leju_esf on 2019/1/29.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYGameTeamAnalysisViewController.h"
#import "SYGameTeamAnalysisCell.h"

@interface SYGameTeamAnalysisViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation SYGameTeamAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self.tableView sy_registerNibWithClass:[SYGameTeamAnalysisCell class]];
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}


- (void)refreshAction {
    
    [[SYNBADataManager sharedSYNBADataManager] requestDatasByType:SYNBAListTypeHasScore Completion:^(NSArray * _Nonnull datas) {
        [self.tableView.mj_header endRefreshing];
        [self handelResult:datas];
    }];
}

- (void)handelResult:(NSArray *)datas {
    if (datas.count == 0) {
        return;
    }
    
    NSMutableDictionary *datesTempDict = [NSMutableDictionary dictionary];
    
    for (SYBasketBallModel *model in datas) {
        NSMutableArray *homeDataTemp = [datesTempDict objectForKey:model.HomeTeam];
        if (homeDataTemp == nil) {
            homeDataTemp = [NSMutableArray array];
        }
        [homeDataTemp addObject:model];
        [datesTempDict setObject:homeDataTemp forKey:model.HomeTeam];
        
        NSMutableArray *awayDataTemp = [datesTempDict objectForKey:model.AwayTeam];
        if (awayDataTemp == nil) {
            awayDataTemp = [NSMutableArray array];
        }
        [awayDataTemp addObject:model];
        [datesTempDict setObject:awayDataTemp forKey:model.AwayTeam];
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (int i = 1; i < 31; i++) {
        NSString *rankkey = nil;
        if (i < 16) {
            rankkey = [NSString stringWithFormat:@"东%d",i];
        }else {
            rankkey = [NSString stringWithFormat:@"西%d",i-15];
        }
        
        for (NSString *key in [SYNBADataManager sharedSYNBADataManager].ranks) {
            if([[SYNBADataManager sharedSYNBADataManager].ranks[key] isEqualToString:rankkey]) {
                NSArray *array = [datesTempDict objectForKey:key];
                
                NSInteger homeCount = 0;
                NSInteger home_push = 0;
                NSInteger home_push_red = 0;
                NSInteger home_push_normal_red = 0;
                
                NSInteger home_unpush = 0;
                NSInteger home_unpush_red = 0;
                NSInteger home_unpush_normal_red = 0;
                
                NSInteger awayCount = 0;
                NSInteger away_push = 0;
                NSInteger away_push_red = 0;
                NSInteger away_push_normal_red = 0;
                
                NSInteger away_unpush = 0;
                NSInteger away_unpush_red = 0;
                NSInteger away_unpush_normal_red = 0;
                
                for (SYBasketBallModel *model in array) {
                    BOOL isHome = [model.HomeTeam isEqualToString:key];
                    if (isHome) {
                        homeCount++;
                        
                        if (model.BfAmountHome > model.BfAmountAway && model.BfIndexHome > model.BfIndexAway) {
                            home_push++;
                            //主
                            if (model.homeScore.integerValue > model.awayScore.integerValue) {
                                home_push_normal_red++;
                            }
                            
                            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                                home_push_red++;
                            }
                            
                        }else {
                            home_unpush++;
                            if (model.homeScore.integerValue > model.awayScore.integerValue) {
                                home_unpush_normal_red++;
                            }
                            
                            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                                home_unpush_red++;
                            }
                        }
                        
                    }else {
                        awayCount++;
                        
                        if (model.BfAmountHome < model.BfAmountAway && model.BfIndexHome < model.BfIndexAway) {
                            //客
                            away_push++;
                            if (model.homeScore.integerValue < model.awayScore.integerValue) {
                                away_push_normal_red++;
                            }
                            
                            if (model.homeScore.integerValue < model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                                away_push_red++;
                            }
                            
                        }else {
                            away_unpush++;
                            if (model.homeScore.integerValue < model.awayScore.integerValue) {
                                away_unpush_normal_red++;
                            }
                            
                            if (model.homeScore.integerValue < model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                                away_unpush_red++;
                            }
                        }
                        
                    }
                }
                
                SYGameTeamModel *pushModel = [SYGameTeamModel new];
                
                pushModel.homeCount = homeCount;
                pushModel.awayCount = awayCount;
                
                pushModel.homePush = home_push;
                pushModel.awayPush = away_push;
                pushModel.homePush_red = home_push_red;
                pushModel.awayPush_red = away_push_red;
                pushModel.homePush_normal_red = home_push_normal_red;
                pushModel.awayPush_normal_red = away_push_normal_red;
                
                pushModel.homeUnPush = home_unpush;
                pushModel.awayUnPush = away_unpush;
                pushModel.homeUnPush_red = home_unpush_red;
                pushModel.awayUnPush_red = away_unpush_red;
                pushModel.homeUnPush_normal_red = home_unpush_normal_red;
                pushModel.awayUnPush_normal_red = away_unpush_normal_red;
                
                pushModel.name = key;
                pushModel.rank = rankkey;
                
                [tempArray addObject:pushModel];
            }
        }
    }
    
    self.datas = tempArray;
    [self.tableView reloadData];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameTeamAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameTeamAnalysisCell class])];
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
        _tableView.rowHeight = 70;
        //        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = [UIColor sy_colorWithRGB:0xf4f4f4];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


@end
