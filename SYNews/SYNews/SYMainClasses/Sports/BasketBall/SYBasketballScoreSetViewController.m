//
//  SYBasketballScoreSetViewController.m
//  SYNews
//
//  Created by leju_esf on 2019/1/4.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYBasketballScoreSetViewController.h"
#import "SYDatePickerTool.h"
#import "SYScoreSetCell.h"

@interface SYBasketballScoreSetViewController ()
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic, strong) NSIndexPath *seletedGame;
@property (nonatomic, strong) NSIndexPath *seletedResult;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) SYDatePickerTool *datePicker;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *rightItem2;
@end

@implementation SYBasketballScoreSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initalTableView:self.leftTableView];
    [self initalTableView:self.rightTableView];
    self.navigationItem.rightBarButtonItems = @[self.rightItem2,self.rightItem];
    
    [[SYNBADataManager sharedSYNBADataManager] requestDatasByType:SYNBAListTypeNoScore Completion:^(NSArray * _Nonnull datas) {
        self.leftArray = datas;
        [self reloadData];
    }];
    
    [self requestDataWithDate:[[NSDate date] sy_yesterday]];
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

- (void)AIAnalize {
    for (SYBasketBallModel *game in self.leftArray) {
        if (game.homeScore.length > 0) {
            continue;
        }
        NSString *homeName = [[SYNBADataManager sharedSYNBADataManager].gameIdToResultGameName objectForKey:game.HomeTeam];
        NSString *awayName = [[SYDataAnalyzeManager sharedSYDataAnalyzeManager].gameIdToResultGameName objectForKey:game.AwayTeam];

        for (SYBasketBallModel *result in self.rightArray) {
            BOOL homeStatus = [result.HomeTeam isEqualToString:homeName] || [result.HomeTeam isEqualToString:game.HomeTeam];
            BOOL awayStatus = [result.AwayTeam isEqualToString:awayName] || [result.AwayTeam isEqualToString:game.AwayTeam];
            if (labs(result.dateSeconds - game.dateSeconds) < 36000 && (homeStatus || awayStatus)) {
                [[SYNBADataManager sharedSYNBADataManager] copyScoreFrom:result toGame:game];
            }
        }
    }
}

- (void)saveScores {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (SYBasketBallModel *model in self.leftArray) {
        if (model.homeScore.length > 0) {
            [tempArray addObject:model];
        }
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SYNBADataManager sharedSYNBADataManager] changeScoreWithModels:tempArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"存储完毕" toView:nil];
        });
    });
    
}

#pragma mark - 网络请求
- (void)requestDataWithDate:(NSDate *)date {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    
    [[SYNBADataManager sharedSYNBADataManager] requestResultByDate:date completion:^(id  _Nonnull result) {
        if (result) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            weakSelf.rightArray = result;
            [weakSelf AIAnalize];
            [weakSelf reloadData];
        }
    }];
}

- (void)reloadData {
    [self.rightTableView reloadData];
    [self.leftTableView reloadData];
}

#pragma mark - tableView DataSource

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (tableView == self.leftTableView) {
//        NSArray *array = self.leftArray[section];
//        SYGameListModel *model = array.firstObject;
//        return model.SortName;
//    }else {
//        NSArray *array = self.rightArray[section];
//        SYGameResultModel *model = array.firstObject;
//        return model.sortName;
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.leftArray.count;
    }else {
        return self.rightArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYScoreSetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYScoreSetCell class])];
    if (tableView == self.leftTableView) {
        cell.model = self.leftArray[indexPath.row];
        cell.accessoryType = self.seletedGame == indexPath ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }else {
        cell.model = self.rightArray[indexPath.row];
        cell.accessoryType = self.seletedResult == indexPath ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.leftTableView) {
        if (self.seletedGame == indexPath) {
            self.seletedGame = nil;
        }else {
            self.seletedGame = indexPath;
        }
    }else {
        if (self.seletedResult == indexPath) {
            self.seletedResult = nil;
        }else {
            self.seletedResult = indexPath;
        }
    }
    
    [self reloadData];
    if (self.seletedGame && self.seletedResult) {
        
        SYBasketBallModel *game = self.leftArray[self.seletedGame.row];
        SYBasketBallModel *result = self.rightArray[self.seletedResult.row];

        [[SYNBADataManager sharedSYNBADataManager] copyScoreFrom:result toGame:game];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.seletedGame = nil;
            self.seletedResult = nil;
            [self reloadData];
        });
    }
    
}

#pragma mark - 懒加载
- (SYDatePickerTool *)datePicker {
    if (_datePicker == nil) {
        _datePicker = [[SYDatePickerTool alloc] initWithDatePickerMode:UIDatePickerModeDate];
        _datePicker.maximumDate = [[NSDate date] sy_yesterday];
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
