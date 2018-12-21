//
//  SYFootballScoreSetViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/12/18.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYFootballScoreSetViewController.h"
#import "SYDatePickerTool.h"
#import "SYScoreSetCell.h"
@interface SYFootballScoreSetViewController ()
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UIButton *AIBtn;
@property (nonatomic, strong) NSIndexPath *seletedGame;
@property (nonatomic, strong) NSIndexPath *seletedResult;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) SYDatePickerTool *datePicker;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *rightItem2;
@end

@implementation SYFootballScoreSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.AIBtn.layer.cornerRadius = 25;
    self.AIBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.AIBtn.layer.borderWidth = 0.5;
    [self initalTableView:self.leftTableView];
    [self initalTableView:self.rightTableView];
    
    __weak typeof(self) weakSelf = self;
    [[SYSportDataManager sharedSYSportDataManager] requestDatasBySYListType:SYListTypeNoScore Completion:^(NSArray *datas) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSArray *games in datas) {
            NSSortDescriptor *timeSD=[NSSortDescriptor sortDescriptorWithKey:@"dateSeconds" ascending:YES];
            [tempArray addObject:[[games sortedArrayUsingDescriptors:@[timeSD]] mutableCopy]];
        }
        
        weakSelf.leftArray = tempArray;
        [weakSelf reloadData];
    }];
    
    self.navigationItem.rightBarButtonItems = @[self.rightItem2,self.rightItem];
    
    [self requestDataWithDate:[NSDate date]];
}

- (void)initalTableView:(UITableView *)tableView {
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [tableView sy_registerNibWithClass:[SYScoreSetCell class]];
}

- (void)datePick {
    [self.datePicker show];
}

- (IBAction)AIAction {
    self.AIBtn.selected = !self.AIBtn.selected;
    if (self.AIBtn.selected) {
        self.AIBtn.backgroundColor = [UIColor redColor];
        [self.AIBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        self.AIBtn.backgroundColor = [UIColor clearColor];
        [self.AIBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [self AIAnalize];
}

- (void)AIAnalize {
    for (NSArray *games in self.leftArray) {
        SYGameListModel *model = games.firstObject;
        NSString *sclassID = [[SYDataAnalyzeManager sharedSYDataAnalyzeManager].sportIdToResultSprorId objectForKey:model.LeagueId];
    
        NSArray *resultArray = nil;
        for (NSArray *results in self.rightArray) {
            SYGameResultModel *result = results.firstObject;
            if ([sclassID isEqualToString:result.sclassID] || [model.SortName isEqualToString:result.sortName]) {
                resultArray = results;
                break;
            }
        }
        if (resultArray) {
            for (SYGameListModel *game in games) {
                if (game.score.length > 0) {
                    continue;
                }
                NSString *homeName = [[SYDataAnalyzeManager sharedSYDataAnalyzeManager].gameIdToResultGameName objectForKey:[game.HomeTeam stringByAppendingString:game.HomeTeamId]];
                NSString *awayName = [[SYDataAnalyzeManager sharedSYDataAnalyzeManager].gameIdToResultGameName objectForKey:[game.AwayTeam stringByAppendingString:game.AwayTeamId]];
                
                for (SYGameResultModel *result in resultArray) {
                    BOOL homeStatus = [result.hTeam isEqualToString:homeName] || [result.hTeam isEqualToString:game.HomeTeam];
                    BOOL awayStatus = [result.gTeam isEqualToString:awayName] || [result.gTeam isEqualToString:game.AwayTeam];
                    NSString *gameTime = [[game.MatchTime componentsSeparatedByString:@"T"].firstObject stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    if ([result.time hasPrefix:gameTime] && (homeStatus || awayStatus)) {
                        game.homeScore = result.hScore;
                        game.awayScore = result.gScore;
                        game.score = [NSString stringWithFormat:@"%@:%@",result.hScore,result.gScore];
                    }
                }
            }
        }
    }
    [self reloadData];
}

- (void)saveScores {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSArray *games in self.leftArray) {
        for (SYGameListModel *model in games) {
            if (model.score.length > 0) {
                [tempArray addObject:model];
            }
        }
    }
    [[SYSportDataManager sharedSYSportDataManager] changeScoreWithModels:tempArray];
    [MBProgressHUD showSuccess:@"存储完毕" toView:nil];
}

#pragma mark - 网络请求
- (void)requestDataWithDate:(NSDate *)date {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[SYDataAnalyzeManager sharedSYDataAnalyzeManager] requestResultByDate:date completion:^(id  _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (result) {
            weakSelf.rightArray = result;
            if (weakSelf.AIBtn.selected) {
                [weakSelf AIAnalize];
            }
            [weakSelf reloadData];
        }
    }];
}

- (void)reloadData {
    [self.rightTableView reloadData];
    [self.leftTableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.rightTableView.contentOffset.y > 0) {
            [self.rightTableView setContentOffset:CGPointZero animated:YES];
        }
    });
}
#pragma mark - tableView DataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        NSArray *array = self.leftArray[section];
        SYGameListModel *model = array.firstObject;
        return model.SortName;
    }else {
        NSArray *array = self.rightArray[section];
        SYGameResultModel *model = array.firstObject;
        return model.sortName;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) {
        return self.leftArray.count;
    }else {
        return self.rightArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        NSArray *array = self.leftArray[section];
        return array.count;
    }else {
        NSArray *array = self.rightArray[section];
        return array.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYScoreSetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYScoreSetCell class])];
    if (tableView == self.leftTableView) {
        NSArray *array = self.leftArray[indexPath.section];
        cell.model = array[indexPath.row];
        cell.accessoryType = self.seletedGame == indexPath ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }else {
        NSArray *array = self.rightArray[indexPath.section];
        cell.model = array[indexPath.row];
        cell.accessoryType = self.seletedResult == indexPath ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.leftTableView) {
        self.seletedGame = indexPath;
    }else {
        self.seletedResult = indexPath;
    }
    
    [self reloadData];
    if (self.seletedGame && self.seletedResult) {
        
        NSArray *games = self.leftArray[self.seletedGame.section];
        SYGameListModel *game = games[self.seletedGame.row];
        
        NSArray *results = self.rightArray[self.seletedResult.section];
        SYGameResultModel *result = results[self.seletedResult.row];
        
        [[SYDataAnalyzeManager sharedSYDataAnalyzeManager] copyScoreFrom:result toGame:game];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.seletedGame = nil;
            self.seletedResult = nil;
            [self reloadData];
        });
    }
    
}

- (SYDatePickerTool *)datePicker {
    if (_datePicker == nil) {
        _datePicker = [[SYDatePickerTool alloc] initWithDatePickerMode:UIDatePickerModeDate];
        __weak typeof(self) weakSelf = self;
        [_datePicker setDoneAction:^(NSDate *date) {
            [weakSelf requestDataWithDate:date];
        }];
    }
    return _datePicker;
}

- (UIBarButtonItem *)rightItem2 {
    if (_rightItem2 == nil) {
        _rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"日期" style:UIBarButtonItemStyleDone target:self action:@selector(datePick)];
        _rightItem2.tintColor = [UIColor whiteColor];
    }
    return _rightItem2;
}

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"存储" style:UIBarButtonItemStyleDone target:self action:@selector(saveScores)];
        _rightItem.tintColor = [UIColor whiteColor];
    }
    return _rightItem;
}
@end
