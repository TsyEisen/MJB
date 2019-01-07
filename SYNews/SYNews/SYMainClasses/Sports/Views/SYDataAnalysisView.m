//
//  SYDataAnalysisView.m
//  SYNews
//
//  Created by 冯娇娇 on 2018/11/4.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYDataAnalysisView.h"
#import "SYDataAnalysisCell.h"
@interface SYDataAnalysisView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *analysisDatas;
@end

@implementation SYDataAnalysisView

+ (instancetype)viewFromNib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView sy_registerNibWithClass:[SYDataAnalysisCell class]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    if (datas.count > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self calculatorData];
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.analysisDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYDataAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYDataAnalysisCell class])];
    SYDataAnalysisModel *model = self.analysisDatas[indexPath.row];
    cell.firstLabel.text = model.oneStr;
    cell.secondLabel.text = model.twoStr;
    cell.thirdLabel.text = model.threeStr;
    cell.forthLabel.text = model.fourStr;
    return cell;
}

#pragma mark - 足球计算
- (void)calculatorData {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    NSInteger gb = 0,gm = 0,gs = 0,pb = 0,pm = 0,ps = 0,kb = 0,km = 0,ks = 0;
    
    NSInteger HDA = 0,HAD = 0,AHD = 0,ADH = 0,DHA = 0,DAH = 0;
    NSInteger HDA_H = 0,HDA_D = 0,HDA_A = 0;
    NSInteger HAD_H = 0,HAD_D = 0,HAD_A = 0;
    NSInteger AHD_H = 0,AHD_D = 0,AHD_A = 0;
    NSInteger ADH_H = 0,ADH_D = 0,ADH_A = 0;
    NSInteger DHA_H = 0,DHA_D = 0,DHA_A = 0;
    NSInteger DAH_H = 0,DAH_D = 0,DAH_A = 0;
    
    for (SYGameListModel *model in self.datas) {
        
        NSArray *pay_array = [self gameDataStatisticsWithArray:@[@(model.BfAmountHome/model.totalPAmount),@(model.BfAmountDraw/model.totalPAmount),@(model.BfAmountAway/model.totalPAmount)]];
        NSArray *kelly_array = [self gameDataStatisticsWithArray:@[@(model.KellyHome),@(model.KellyDraw),@(model.KellyAway)]];
        NSArray *gl_array = [self gameDataStatisticsWithArray:@[@(model.BfIndexHome/100),@(model.BfIndexDraw/100),@(model.BfIndexAway/100)]];
        
        SYGameScoreType type = SYGameScoreTypeHome;
        
        if ([model.homeScore integerValue] == [model.awayScore integerValue]) {
            type = SYGameScoreTypeDraw;
        }else if ([model.homeScore integerValue] < [model.awayScore integerValue]) {
            type = SYGameScoreTypeAway;
        }
        
        if (((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeHome &&
            ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeDraw &&
            ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeAway) {
            HDA++;
            if (type == SYGameScoreTypeHome) {HDA_H++;}
            if (type == SYGameScoreTypeDraw) {HDA_D++;}
            if (type == SYGameScoreTypeAway) {HDA_A++;}
        }else if (((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeAway){
            HAD++;
            if (type == SYGameScoreTypeHome) {HAD_H++;}
            if (type == SYGameScoreTypeDraw) {HAD_D++;}
            if (type == SYGameScoreTypeAway) {HAD_A++;}
        }else if (((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeAway){
            AHD++;
            if (type == SYGameScoreTypeHome) {AHD_H++;}
            if (type == SYGameScoreTypeDraw) {AHD_D++;}
            if (type == SYGameScoreTypeAway) {AHD_A++;}
        }else if (((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeAway){
            ADH++;
            if (type == SYGameScoreTypeHome) {ADH_H++;}
            if (type == SYGameScoreTypeDraw) {ADH_D++;}
            if (type == SYGameScoreTypeAway) {ADH_A++;}
        }else if (((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeAway){
            DHA++;
            if (type == SYGameScoreTypeHome) {DHA_H++;}
            if (type == SYGameScoreTypeDraw) {DHA_D++;}
            if (type == SYGameScoreTypeAway) {DHA_A++;}
        }else if (((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeAway){
            DAH++;
            if (type == SYGameScoreTypeHome) {DAH_H++;}
            if (type == SYGameScoreTypeDraw) {DAH_D++;}
            if (type == SYGameScoreTypeAway) {DAH_A++;}
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
    
    _analysisDatas = [NSMutableArray array];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"概率" statusGL:@(gb*1.0/self.datas.count) globalGL:@(gm*1.0/self.datas.count) gameCount:[NSString stringWithFormat:@"%.2f",gs*1.0/self.datas.count]]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"方差" statusGL:@(kb*1.0/self.datas.count) globalGL:@(km*1.0/self.datas.count) gameCount:[NSString stringWithFormat:@"%.2f",ks*1.0/self.datas.count]]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交易" statusGL:@(pb*1.0/self.datas.count) globalGL:@(pm*1.0/self.datas.count) gameCount:[NSString stringWithFormat:@"%.2f",ps*1.0/self.datas.count]]];
    
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"大大" statusCount:pb_kb statusRedCount:pb_kb_red total:self.datas.count]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"大中" statusCount:pb_km statusRedCount:pb_km_red total:self.datas.count]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"大小" statusCount:pb_ks statusRedCount:pb_ks_red total:self.datas.count]];
    
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"中大" statusCount:pm_kb statusRedCount:pm_kb_red total:self.datas.count]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"中中" statusCount:pm_km statusRedCount:pm_km_red total:self.datas.count]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"中小" statusCount:pm_ks statusRedCount:pm_ks_red total:self.datas.count]];
    
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"小大" statusCount:ps_kb statusRedCount:ps_kb_red total:self.datas.count]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"小中" statusCount:ps_km statusRedCount:ps_km_red total:self.datas.count]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"小小" statusCount:ps_ks statusRedCount:ps_ks_red total:self.datas.count]];
    
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithOne:@"" two:@"主" three:@"和" four:@"客"]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"主和客" home:HDA_H draw:HDA_D away:HDA_A total:HDA]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"主客和" home:HAD_H draw:HAD_D away:HAD_A total:HAD]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"客主和" home:AHD_H draw:AHD_D away:AHD_A total:AHD]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"客和主" home:ADH_H draw:ADH_D away:ADH_A total:ADH]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"和主客" home:DHA_H draw:DHA_D away:DHA_A total:DHA]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"和客主" home:DAH_H draw:DAH_D away:DAH_A total:DAH]];
    
//    [str appendFormat:@"   大大 : %@\n",[self calculatorStatisticsWithTotal:pb_kb red:pb_kb_red]];
//    [str appendFormat:@"   大中 : %@   ",[self calculatorStatisticsWithTotal:pb_km red:pb_km_red]];
//    [str appendFormat:@"   大小 : %@\n",[self calculatorStatisticsWithTotal:pb_ks red:pb_ks_red]];
//    [str appendFormat:@"   中大 : %@   ",[self calculatorStatisticsWithTotal:pm_kb red:pm_kb_red]];
//    [str appendFormat:@"   中中 : %@\n",[self calculatorStatisticsWithTotal:pm_km red:pm_km_red]];
//    [str appendFormat:@"   中小 : %@   ",[self calculatorStatisticsWithTotal:pm_ks red:pm_ks_red]];
//    [str appendFormat:@"   小大 : %@\n",[self calculatorStatisticsWithTotal:ps_kb red:ps_kb_red]];
//    [str appendFormat:@"   小中 : %@   ",[self calculatorStatisticsWithTotal:ps_km red:ps_km_red]];
//    [str appendFormat:@"   小小 : %@   ",[self calculatorStatisticsWithTotal:ps_ks red:ps_ks_red]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
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

@end

@implementation SYResultModel

@end

@implementation SYDataAnalysisModel

+ (instancetype)modelWithTitle:(NSString *)title statusCount:(NSInteger)status statusRedCount:(NSInteger)statusRedCount total:(NSInteger)total {
    return [SYDataAnalysisModel modelWithTitle:title statusGL:status == 0 ?@(0):@(statusRedCount*1.0/status) globalGL:@(statusRedCount*1.0/total) gameCount:[NSString stringWithFormat:@"%zd/%zd",statusRedCount,status]];
}

+ (instancetype)modelWithTitle:(NSString *)title statusGL:(NSNumber *)statusGL globalGL:(NSNumber *)globalGL gameCount:(NSString *)gameCount {
    SYDataAnalysisModel *model = [SYDataAnalysisModel new];
    model.oneStr = title;
    model.twoStr = [NSString stringWithFormat:@"%.2f",statusGL.doubleValue];
    model.threeStr = [NSString stringWithFormat:@"%.2f",globalGL.doubleValue];
    model.fourStr = gameCount;
    return model;
}

+ (instancetype)modelWithOne:(NSString *)one two:(NSString *)two three:(NSString *)three four:(NSString *)four {
    SYDataAnalysisModel *model = [SYDataAnalysisModel new];
    model.oneStr = one;
    model.twoStr = two;
    model.threeStr = three;
    model.fourStr = four;
    return model;
}

+ (instancetype)modelWithTitle:(NSString *)title home:(NSInteger)home draw:(NSInteger)draw away:(NSInteger)away total:(NSInteger)total{
    SYDataAnalysisModel *model = [SYDataAnalysisModel new];
    model.oneStr = title;
    model.twoStr = total == 0 ? @"0":[NSString stringWithFormat:@"%.2f(%zd)",home*1.0/total,home];
    model.threeStr = total == 0 ? @"0":[NSString stringWithFormat:@"%.2f(%zd)",draw*1.0/total,draw];
    model.fourStr = total == 0 ? @"0":[NSString stringWithFormat:@"%.2f(%zd)",away*1.0/total,away];
    return model;
}

+ (instancetype)modelWithTitle:(NSString *)title home:(NSInteger)home away:(NSInteger)away {
    NSInteger total = home + away;
    SYDataAnalysisModel *model = [SYDataAnalysisModel new];
    model.oneStr = title;
    model.twoStr = total == 0 ? @"0":[NSString stringWithFormat:@"%.2f(%zd)",home*1.0/total,home];
    model.threeStr = total == 0 ? @"0":[NSString stringWithFormat:@"%.2f(%zd)",away*1.0/total,away];
    return model;
}
@end
