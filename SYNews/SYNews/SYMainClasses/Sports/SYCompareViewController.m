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
@interface SYCompareViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTabelView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) NSArray *categoryDatas;
//@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) SYGameDetailView *detailView;
@property (nonatomic, strong) SYSelectBox *box;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray *statistics;
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
    
    if (_datas == nil) {
        [[SYSportDataManager sharedSYSportDataManager] requestDatasBySYListType:self.type Completion:^(NSArray *datas) {
            _datas = datas;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self calculatorData];
            });
            [self segmentChange];
        }];
    }else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self calculatorData];
        });
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

- (UITableView *)rightTableView {
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 10 * SYGameTableCellWidth, ScreenH - 164) style:UITableViewStylePlain];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.tableFooterView = [UIView new];
    }
    return _rightTableView;
}

//- (UIBarButtonItem *)rightItem {
//    if (_rightItem == nil) {
//        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"数据" style:UIBarButtonItemStyleDone target:self action:@selector(dataAction)];
//        _rightItem.tintColor = [UIColor whiteColor];
//    }
//    return _rightItem;
//}

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

- (UISegmentedControl *)segment {
    if (_segment == nil) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"  时间   ",@"  交易   "]];
        _segment.tintColor = [UIColor whiteColor];
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
    
- (void)calculatorData {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSInteger gb = 0,gm = 0,gs = 0,pb = 0,pm = 0,ps = 0,kb = 0,km = 0,ks = 0;
    
    for (SYGameListModel *model in self.datas) {
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
        NSArray *pay_array = [self gameDataStatisticsWithArray:@[@(model.BfAmountHome/model.totalPAmount),@(model.BfAmountDraw/model.totalPAmount),@(model.BfAmountAway/model.totalPAmount)]];
        NSArray *kelly_array = [self gameDataStatisticsWithArray:@[@(model.KellyHome),@(model.KellyDraw),@(model.KellyAway)]];
        NSArray *gl_array = [self gameDataStatisticsWithArray:@[@(model.BfIndexHome/100),@(model.BfIndexDraw/100),@(model.BfIndexAway/100)]];
        SYGameScoreType type = SYGameScoreTypeHome;
        
        if ([model.homeScore integerValue] == [model.awayScore integerValue]) {
            type = SYGameScoreTypeDraw;
        }else if ([model.homeScore integerValue] < [model.awayScore integerValue]) {
            type = SYGameScoreTypeAway;
        }
        
        for (int i = 0; i < 3; i++) {
            SYNumberModel *pay = pay_array[i];
            for (int j = 0; j < 3; j++) {
                SYNumberModel *kelly = kelly_array[j];
                if (pay.status == kelly.status) {
                    SYResultModel *result = [SYResultModel new];
                    result.tag = i * 10 + j;
                    result.red = pay.status == type;
                    [tempArray addObject:result];
                }
            }
        }
        
        if (((SYNumberModel *)gl_array[0]).status == type) {gb ++;}
        if (((SYNumberModel *)gl_array[1]).status == type) {gm ++;}
        if (((SYNumberModel *)gl_array[2]).status == type) {gs ++;}
        if (((SYNumberModel *)pay_array[0]).status == type) {pb ++;}
        if (((SYNumberModel *)pay_array[1]).status == type) {pm ++;}
        if (((SYNumberModel *)pay_array[2]).status == type) {ps ++;}
        if (((SYNumberModel *)kelly_array[0]).status == type) {kb ++;}
        if (((SYNumberModel *)kelly_array[1]).status == type) {km ++;}
        if (((SYNumberModel *)kelly_array[2]).status == type) {ks ++;}
    }
    
    NSInteger pb_kb = 0,pb_km = 0,pb_ks = 0,
    pm_kb = 0,pm_km = 0,pm_ks = 0,
    ps_kb = 0,ps_km = 0,ps_ks = 0;

    NSInteger pb_kb_red = 0,pb_km_red = 0,pb_ks_red = 0,
    pm_kb_red = 0,pm_km_red = 0,pm_ks_red = 0,
    ps_kb_red = 0,ps_km_red = 0,ps_ks_red = 0;
    
    for (SYResultModel *result in tempArray) {
        switch (result.tag) {
            case 0:
            pb_kb ++;
            if (result.red) {
                pb_kb_red ++;
            }
            break;
            case 1:
            pb_km ++;
            if (result.red) {
                pb_km_red ++;
            }
            break;
            case 2:
            pb_ks ++;
            if (result.red) {
                pb_ks_red ++;
            }
            break;
            case 10:
            pm_kb ++;
            if (result.red) {
                pm_kb_red ++;
            }
            break;
            case 11:
            pm_km ++;
            if (result.red) {
                pm_km_red ++;
            }
            break;
            case 12:
            pm_ks ++;
            if (result.red) {
                pm_ks_red ++;
            }
            break;
            case 20:
            ps_kb ++;
            if (result.red) {
                ps_kb_red ++;
            }
            break;
            case 21:
            ps_km ++;
            if (result.red) {
                ps_km_red ++;
            }
            break;
            case 22:
            ps_ks ++;
            if (result.red) {
                ps_ks_red ++;
            }
            break;
            
            default:
            break;
        }
    }
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"   概率%zd-%zd-%zd 交易%zd-%zd-%zd 方差%zd-%zd-%zd ",gb,gm,gs,pb,pm,ps,kb,km,ks];
    
    [str appendFormat:@"   大大 : %@\n",[self calculatorStatisticsWithTotal:pb_kb red:pb_kb_red]];
    [str appendFormat:@"   大中 : %@   ",[self calculatorStatisticsWithTotal:pb_km red:pb_km_red]];
    [str appendFormat:@"   大小 : %@\n",[self calculatorStatisticsWithTotal:pb_ks red:pb_ks_red]];
    [str appendFormat:@"   中大 : %@   ",[self calculatorStatisticsWithTotal:pm_kb red:pm_kb_red]];
    [str appendFormat:@"   中中 : %@\n",[self calculatorStatisticsWithTotal:pm_km red:pm_km_red]];
    [str appendFormat:@"   中小 : %@   ",[self calculatorStatisticsWithTotal:pm_ks red:pm_ks_red]];
    [str appendFormat:@"   小大 : %@\n",[self calculatorStatisticsWithTotal:ps_kb red:ps_kb_red]];
    [str appendFormat:@"   小中 : %@   ",[self calculatorStatisticsWithTotal:ps_km red:ps_km_red]];
    [str appendFormat:@"   小小 : %@   ",[self calculatorStatisticsWithTotal:ps_ks red:ps_ks_red]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topLabel.text = str;
    });
}
    
- (NSArray *)gameDataStatisticsWithArray:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    SYNumberModel *home = [SYNumberModel modelWithStatus:SYGameScoreTypeHome num:[array.firstObject doubleValue]];
    SYNumberModel *draw = [SYNumberModel modelWithStatus:SYGameScoreTypeDraw num:[array[1] doubleValue]];
    SYNumberModel *away = [SYNumberModel modelWithStatus:SYGameScoreTypeAway num:[array.lastObject doubleValue]];
    [tempArray addObjectsFromArray:@[home,draw,away]];
    NSSortDescriptor *numSD = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:NO];
    return [[tempArray sortedArrayUsingDescriptors:@[numSD]] mutableCopy];
}
    
- (NSString *)calculatorStatisticsWithTotal:(NSInteger)total red:(NSInteger)redcount {
    
    if (total == 0 || redcount == 0) {
        return @"0  0";
    }else {
        return [NSString stringWithFormat:@"%.2f  %.2f  (%zd/%zd/%zd)",redcount*1.0/total,redcount*1.0/self.datas.count,redcount,total,self.datas.count];
    }
}
    
- (NSMutableArray *)statistics {
    if (_statistics == nil) {
        _statistics = [[NSMutableArray alloc] init];
    }
    return _statistics;
}

@end

@implementation SYResultModel

@end
