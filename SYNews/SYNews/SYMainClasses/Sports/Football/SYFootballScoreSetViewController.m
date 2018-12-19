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
@property (nonatomic, strong) NSIndexPath *seletedGame;
@property (nonatomic, strong) NSIndexPath *seletedResult;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;
@property (nonatomic, strong) SYDatePickerTool *datePicker;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@end

@implementation SYFootballScoreSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initalTableView:self.leftTableView];
    [self initalTableView:self.rightTableView];
    
    __weak typeof(self) weakSelf = self;
    [[SYSportDataManager sharedSYSportDataManager] requestDatasBySYListType:SYListTypeNoScore Completion:^(NSArray *datas) {
        weakSelf.leftArray = datas;
        [weakSelf reloadData];
    }];
    
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
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

#pragma mark - 网络请求
- (void)requestDataWithDate:(NSDate *)date {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [[SYDataAnalyzeManager sharedSYDataAnalyzeManager] requestResultByDate:date completion:^(id  _Nonnull result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (result) {
            weakSelf.rightArray = result;
            [weakSelf reloadData];
        }
    }];
}

- (void)reloadData {
    [self.rightTableView reloadData];
    [self.leftTableView reloadData];
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

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"日期" style:UIBarButtonItemStyleDone target:self action:@selector(datePick)];
        _rightItem.tintColor = [UIColor whiteColor];
    }
    return _rightItem;
}
@end
