//
//  SYCompareViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/9/28.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYCompareViewController.h"
#import "SYGameTableCell.h"
#import "SYGameTableTitleCell.h"
#import "SYSelectBox.h"
#import "SYGameDetailView.h"
#import "SYDataAnalysisView.h"
@interface SYCompareViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTabelView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSArray *categoryDatas;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) SYGameDetailView *detailView;
@property (nonatomic, strong) SYSelectBox *box;
@property (nonatomic, strong) SYSelectBox *dataAnalysisbox;
@property (nonatomic, strong) SYDataAnalysisView *dataAnalysis;
@property (nonatomic, strong) UISegmentedControl *segment;
@end

@implementation SYCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scrollView addSubview:self.rightTableView];
    NSArray *titles = @[@"概率大",@"概率中",@"概率小",@"交易大",@"交易中",@"交易小",@"方差大",@"方差中",@"方差小",@"单注(万)"];
    CGFloat w = SYGameTableCellWidth;
    CGFloat h = 20;
    for (int i = 0; i < 10; i++) {
        NSString *title = titles[i];
        SYDataLabel *label = [[SYDataLabel alloc] initWithFrame:CGRectMake(i*w, 0, w, h)];
        label.tag = i;
        label.text = title;
        [self.scrollView addSubview:label];
    }
    self.scrollView.contentSize = CGSizeMake(self.rightTableView.sy_width, 0);
    [self.rightTableView sy_registerCellWithClass:[SYGameTableCell class]];
    [self.leftTabelView sy_registerNibWithClass:[SYGameTableTitleCell class]];
//    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.leftTabelView.tableFooterView = [UIView new];
    self.navigationItem.titleView = self.segment;
    self.navigationItem.rightBarButtonItem = self.rightItem;
    if (_datas == nil) {
        [[SYSportDataManager sharedSYSportDataManager] requestDatasBySYListType:self.type Completion:^(NSArray *datas) {
            _datas = datas;
            [self segmentChange];
        }];
    }else {
        [self segmentChange];
    }
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
    
    [self.leftTabelView reloadData];
    [self.rightTableView reloadData];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListModel *model = self.datas[indexPath.row];
    if (tableView == self.leftTabelView) {
        SYGameTableTitleCell *cell =  [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameTableTitleCell class])];
        cell.model = model;
        return cell;
    }else {
        SYGameTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameTableCell class])];
        cell.model = model;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SYGameTableCellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.leftTabelView) {
        [self.rightTableView setContentOffset:scrollView.contentOffset];
    }else {
        [self.leftTabelView setContentOffset:scrollView.contentOffset];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.leftTabelView) {
        SYGameListModel *model = self.datas[indexPath.row];
        SYGameTableTitleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.detailView.model = model;
        [self.box showDependentOnView:cell.contentView];
    }
}

- (void)dataAction {
    [self.dataAnalysisbox showDependentOnView:self.navigationItem.titleView];
}

- (UITableView *)rightTableView {
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 10 * SYGameTableCellWidth, ScreenH - 84) style:UITableViewStylePlain];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.tableFooterView = [UIView new];
    }
    return _rightTableView;
}

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"数据" style:UIBarButtonItemStyleDone target:self action:@selector(dataAction)];
        _rightItem.tintColor = [UIColor whiteColor];
    }
    return _rightItem;
}

- (SYGameDetailView *)detailView {
    if (_detailView == nil) {
        _detailView = [SYGameDetailView viewFromNib];
    }
    return _detailView;
}

- (SYSelectBox *)box {
    if (_box == nil) {
        _box = [[SYSelectBox alloc] initWithSize:CGSizeMake(100, 80) direction:SYSelectBoxArrowPositionLeftCenter andCustomView:self.detailView];
    }
    return _box;
}

- (SYSelectBox *)dataAnalysisbox {
    if (_dataAnalysisbox == nil) {
        _dataAnalysisbox = [[SYSelectBox alloc] initWithSize:CGSizeMake(ScreenW, 400) direction:SYSelectBoxArrowPositionTopCenter andCustomView:self.dataAnalysis];
    }
    return _dataAnalysisbox;
}

- (SYDataAnalysisView *)dataAnalysis {
    if (_dataAnalysis == nil) {
        _dataAnalysis = [SYDataAnalysisView viewFromNib];
        _dataAnalysis.datas = self.datas;
    }
    return _dataAnalysis;
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

/*
 //        NSMutableArray *temp_pay = [NSMutableArray array];
 //        NSMutableArray *temp_kelly = [NSMutableArray array];
 //        NSMutableArray *temp_gl = [NSMutableArray array];
 //
 //        SYNumberModel *pay_home = [SYNumberModel modelWithStatus:SYGameScoreTypeHome num:model.BfAmountHome/model.totalPAmount];
 //        SYNumberModel *pay_draw = [SYNumberModel modelWithStatus:SYGameScoreTypeDraw num:model.BfAmountDraw/model.totalPAmount];
 //        SYNumberModel *pay_away = [SYNumberModel modelWithStatus:SYGameScoreTypeAway num:model.BfAmountAway/model.totalPAmount];
 //        [temp_pay addObjectsFromArray:@[pay_home,pay_draw,pay_away]];
 //
 //        SYNumberModel *kelly_home = [SYNumberModel modelWithStatus:SYGameScoreTypeHome num:model.KellyHome];
 //        SYNumberModel *kelly_draw = [SYNumberModel modelWithStatus:SYGameScoreTypeDraw num:model.KellyDraw];
 //        SYNumberModel *kelly_away = [SYNumberModel modelWithStatus:SYGameScoreTypeAway num:model.KellyAway];
 //        [temp_kelly addObjectsFromArray:@[kelly_home,kelly_draw,kelly_away]];
 //
 //        SYNumberModel *gl_home = [SYNumberModel modelWithStatus:SYGameScoreTypeHome num:model.BfIndexHome/100];
 //        SYNumberModel *gl_draw = [SYNumberModel modelWithStatus:SYGameScoreTypeDraw num:model.BfIndexDraw/100];
 //        SYNumberModel *gl_away = [SYNumberModel modelWithStatus:SYGameScoreTypeAway num:model.BfIndexAway/100];
 //        [temp_gl addObjectsFromArray:@[gl_home,gl_draw,gl_away]];
 //        NSSortDescriptor *numSD = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:NO];
 //        NSArray *pay_array = [[temp_pay sortedArrayUsingDescriptors:@[numSD]] mutableCopy];
 //        NSArray *kelly_array = [[temp_kelly sortedArrayUsingDescriptors:@[numSD]] mutableCopy];
 //        NSArray *gl_array = [[temp_gl sortedArrayUsingDescriptors:@[numSD]] mutableCopy];
 */


