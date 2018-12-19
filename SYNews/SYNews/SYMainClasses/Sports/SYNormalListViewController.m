//
//  SYNormalListViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/10/19.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYNormalListViewController.h"
#import "SYGameListCell.h"
#import "SYScorePicker.h"
#import "SYRecommendPicker.h"

@interface SYNormalListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SYScorePicker *scorePicker;
@property (nonatomic, strong) SYRecommendPicker *recommendPicker;
@property (nonatomic, strong) SYGameListModel *selectedModel;
@property (nonatomic, strong) UISegmentedControl *segment;
@end

@implementation SYNormalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self.tableView sy_registerNibWithClass:[SYGameListCell class]];
    self.navigationItem.titleView = self.segment;
    [self segmentChange];
}

- (void)setUpUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}
    
- (void)segmentChange {
    NSSortDescriptor *contidion = nil;
    if (self.segment.selectedSegmentIndex == 0) {
        //时间
        contidion = [NSSortDescriptor sortDescriptorWithKey:@"dateSeconds" ascending:NO];
    }else {
        contidion = [NSSortDescriptor sortDescriptorWithKey:@"totalPAmount" ascending:NO];
    }
    self.datas = [self.datas sortedArrayUsingDescriptors:@[contidion]];
    
    [self.tableView reloadData];
}
    
#pragma mark - tableView DataSource
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
    
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameListCell class])];
    cell.model = self.datas[indexPath.row];
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedModel = self.datas[indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"输入比分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.scorePicker show];
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"推介" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.recommendPicker.model = self.datas[indexPath.row];
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
}
    
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
    
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListModel *model = self.datas[indexPath.row];
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"复制" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (model.score.length > 0) {
            pasteboard.string = [NSString stringWithFormat:@"%@ %@VS%@  %@",model.SortName,model.HomeTeam,model.AwayTeam,model.score];
        }else {
            pasteboard.string = [NSString stringWithFormat:@"%@ %@VS%@",model.SortName,model.HomeTeam,model.AwayTeam];
        }
        
        [MBProgressHUD showSuccess:@"复制成功" toView:nil];
    }];
    return @[action];
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
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"  时间   ",@"  交易   "]];
        _segment.tintColor = [UIColor whiteColor];
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
    

@end
