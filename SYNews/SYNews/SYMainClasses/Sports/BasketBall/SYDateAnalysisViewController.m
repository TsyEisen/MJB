//
//  SYDateAnalysisViewController.m
//  SYNews
//
//  Created by leju_esf on 2019/1/28.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYDateAnalysisViewController.h"
#import "SYDateAnalysisCell.h"

@interface SYDateAnalysisViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation SYDateAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self.tableView sy_registerNibWithClass:[SYDateAnalysisCell class]];
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
    
    [[SYNBADataManager sharedSYNBADataManager] requestDatasByType:SYNBAListTypeHistory Completion:^(NSArray * _Nonnull datas) {
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
        
        if (model.homeScore.length == 0 || model.homeScore.integerValue == 0) {
            continue;
        }
        
        NSString *dateStrKey = [model.MatchTime componentsSeparatedByString:@"T"].firstObject;
        NSMutableArray *dataTemp = [datesTempDict objectForKey:dateStrKey];
        if (dataTemp == nil) {
            dataTemp = [NSMutableArray array];
        }
        [dataTemp addObject:model];
        [datesTempDict setObject:dataTemp forKey:dateStrKey];
    }
    
//    NSInteger rangfen = 0;
//    NSInteger total = 0;
    
    NSDate *date = [NSDate sy_dateWithString:@"20181213010101" formate:@"yyyyMMddHHmmss"];
    NSMutableArray *tempArray = [NSMutableArray array];
    do {
        NSString *dateKey = [date sy_stringWithFormat:@"yyyy-MM-dd"];
        NSArray *array = datesTempDict[dateKey];
        
        NSInteger push_home = 0;
        NSInteger push_away = 0;
        
        NSInteger redCount_home = 0;
        NSInteger normalRedCount_home = 0;
        
        NSInteger redCount_away = 0;
        NSInteger normalRedCount_away = 0;
        
        if (array == nil) {
            date = [date sy_tomorrow];
            continue;
        }
        
        NSInteger single_score = 0; NSInteger double_score = 0;
        
        for (SYBasketBallModel *model in array) {
            
            if ((model.homeScore.integerValue + model.awayScore.integerValue)%2 == 0) {
                double_score++;
            }else {
                single_score++;
            }
            
            if (model.BfAmountHome > model.BfAmountAway && model.BfIndexHome > model.BfIndexAway) {
                
                push_home++;
                //主
                if (model.homeScore.integerValue > model.awayScore.integerValue) {
                    normalRedCount_home++;
                }
                
                if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                    redCount_home++;
                }
            }
            
            if (model.BfAmountHome < model.BfAmountAway && model.BfIndexHome < model.BfIndexAway) {
                //客
                
//                if (model.AsianAvrLet.floatValue < 0) {
//                    rangfen++;
//                }
                push_away++;
                
                if (model.homeScore.integerValue < model.awayScore.integerValue) {
                    normalRedCount_away++;
                }
                
                if (model.homeScore.integerValue < model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                    redCount_away++;
                }
            }
            
        }
        
        SYHomeAwayPushModel *pushModel = [SYHomeAwayPushModel new];
        pushModel.homePush_red = redCount_home;
        pushModel.awayPush_red = redCount_away;
        pushModel.homePush_normal_red = normalRedCount_home;
        pushModel.awayPush_normal_red = normalRedCount_away;
        pushModel.homePush = push_home;
        pushModel.awayPush = push_away;
        pushModel.total = array.count;
        pushModel.time = [date sy_stringWithFormat:@"MM-dd"];
        [tempArray insertObject:pushModel atIndex:0];
//        NSLog(@"%@--%zd(主%zd客%zd)%@/%zd(主%zd客%zd)%@/%zd",
//              dateKey,
//              redCount_away + redCount_home,
//              redCount_home,
//              redCount_away,
//              redCount_away + redCount_home > array.count * 0.5 ? @"红":@"黑",
//              normalRedCount_home + normalRedCount_away,
//              normalRedCount_home,
//              normalRedCount_away,
//              normalRedCount_home + normalRedCount_away > array.count * 0.5 ? @"红":@"黑",
//              array.count);
        NSLog(@"单%zd 双%zd %@",single_score,double_score,single_score > double_score ? @"单":@"双");
        date = [date sy_tomorrow];
    } while (![date sy_isTomorrow]);
    
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
    SYDateAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYDateAnalysisCell class])];
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
        _tableView.rowHeight = 50;
//        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = [UIColor sy_colorWithRGB:0xf4f4f4];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
