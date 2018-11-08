//
//  SYRecommendViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/10/10.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYRecommendViewController.h"
#import "SYGameListCell.h"
#import "SYGameTableCell.h"
#import "ERSwitchView.h"
#import "SYAlertView.h"
#import "SYAddNewRecommendView.h"

@interface SYRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ERSwitchView *switchView;
@property (nonatomic, strong) UIBarButtonItem *addBtn;
@property (nonatomic, strong) UIBarButtonItem *deleteBtn;
@end

@implementation SYRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.title = @"推介";
}

- (void)setUpUI {
    [self.view addSubview:self.switchView];
    [self.view addSubview:self.tableView];
    [self.tableView sy_registerNibWithClass:[SYGameListCell class]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@50);
    }];
    self.navigationItem.rightBarButtonItems = @[self.deleteBtn,self.addBtn];
}

- (void)addNewAction {
    SYAddNewRecommendView *recommendView = [SYAddNewRecommendView viewFromNib];
    recommendView.isAdd = YES;
    SYAlertView *alert = [[SYAlertView alloc] initWithCustom:recommendView cancelButtonTitle:@"取消" conformButtonTitle:@"确定" size:CGSizeMake(260, 120)];
    [alert setConformAction:^{
        if (recommendView.textField.text.length > 0) {
            [[SYSportDataManager sharedSYSportDataManager] creatNewRecommend:recommendView.textField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    alert.allowTapBackgroundDismiss = YES;
    [alert show];
}

- (void)deleteAction {
    SYAddNewRecommendView *recommendView = [SYAddNewRecommendView viewFromNib];
    SYAlertView *alert = [[SYAlertView alloc] initWithCustom:recommendView cancelButtonTitle:@"取消" conformButtonTitle:@"确定" size:CGSizeMake(260, 180)];
    [alert setConformAction:^{
        if (recommendView.selectedIndex) {
            [[SYSportDataManager sharedSYSportDataManager] deleteRecommendAtIndex:recommendView.selectedIndex.row];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    alert.allowTapBackgroundDismiss = YES;
    [alert show];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([SYSportDataManager sharedSYSportDataManager].recommends.count == 0) {
        return 0;
    }else {
        SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[self.switchView.index];
        return model.datas.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameListCell class])];
    cell.recommend = YES;
    SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[self.switchView.index];
    cell.model = model.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[self.switchView.index];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [model deleteModel:model.datas[indexPath.row]];
        [weakSelf.tableView reloadData];
    }];
    
    UITableViewRowAction *copyaction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"复制" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        SYGameListModel *item = model.datas[indexPath.row];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@ %@VS%@",item.SortName,item.HomeTeam,item.AwayTeam];
        [MBProgressHUD showSuccess:@"复制成功" toView:nil];
        [weakSelf.tableView reloadData];
    }];
    
    return @[action,copyaction];
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

- (ERSwitchView *)switchView {
    if (_switchView == nil) {
        _switchView = [[ERSwitchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _switchView.minMargin = 30;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (SYRecommendModel *model in [SYSportDataManager sharedSYSportDataManager].recommends) {
            [tempArray addObject:model.name];
        }
        __weak typeof(self) weakSelf = self;
        [_switchView setButtonAciton:^(NSInteger index) {
            [weakSelf.tableView reloadData];
            SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[index];
            if (model.datas.count > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:model.datas.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
                });
            }
        }];
        
        [_switchView setLongPressAction:^(NSInteger index) {
            SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[index];
            NSMutableString *str = [NSMutableString string];
            for (SYGameListModel *item in model.datas) {
                [str appendFormat:@"%@ %@ %@ VS %@ %@ %@ %@ %@\n",item.MatchTime,item.SortName,item.HomeTeam,item.AwayTeam,[weakSelf recommendString:item],item.score,item.AsianAvrLet,item.resultType & item.recommendType ? @"红":@"黑"];
            }
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = str;
            NSLog(@"结果:\n%@",str);
            [MBProgressHUD showSuccess:@"复制成功" toView:nil];
        }];
        
        _switchView.titles = tempArray;
    }
    return _switchView;
}

- (NSString *)recommendString:(SYGameListModel *)model {
    NSString *title = nil;
    switch (model.recommendType) {
        case SYGameScoreTypeHome:
            title = @"胜";
            break;
        case SYGameScoreTypeDraw:
            title = @"平";
            break;
        case SYGameScoreTypeAway:
            title = @"负";
            break;
        case SYGameScoreTypeAway|SYGameScoreTypeDraw:
            title = @"客不败";
            break;
        case SYGameScoreTypeDraw|SYGameScoreTypeHome:
            title = @"主不败";
            break;
        default:
            break;
    }
    return title;
}

- (UIBarButtonItem *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addNewAction)];
        _addBtn.tintColor = [UIColor whiteColor];
    }
    return _addBtn;
}

- (UIBarButtonItem *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteAction)];
        _deleteBtn.tintColor = [UIColor whiteColor];
    }
    return _deleteBtn;
}

//- (UIScrollView *)scrollView {
//    if (_scrollView == nil) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.pagingEnabled = YES;
//    }
//    return _scrollView;
//}
@end
