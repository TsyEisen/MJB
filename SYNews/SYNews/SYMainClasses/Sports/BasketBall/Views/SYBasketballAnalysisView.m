//
//  SYBasketballAnalysisView.m
//  SYNews
//
//  Created by leju_esf on 2019/1/7.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYBasketballAnalysisView.h"
#import "SYTableThreeTextCell.h"
#import "SYDataAnalysisView.h"

@interface SYBasketballAnalysisView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *analysisDatas;
@end

@implementation SYBasketballAnalysisView
+ (instancetype)viewFromNib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil].firstObject;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView sy_registerNibWithClass:[SYTableThreeTextCell class]];
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
    SYTableThreeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYTableThreeTextCell class])];
    SYDataAnalysisModel *model = self.analysisDatas[indexPath.row];
    cell.firstLabel.text = model.oneStr;
    cell.secondLabel.text = model.twoStr;
    cell.thirdLabel.text = model.threeStr;
    return cell;
}

- (void)calculatorData {
    //一种
    NSInteger ph = 0, gh = 0, yh = 0,pa = 0,ga = 0,ya = 0;
    NSInteger ph_h = 0, gh_h = 0, yh_h = 0,pa_h = 0,ga_h = 0,ya_h = 0;
    NSInteger ph_a = 0, gh_a = 0, yh_a = 0,pa_a = 0,ga_a = 0,ya_a = 0;
    //两种
    NSInteger ph_gh = 0, ph_yh = 0, ph_ga = 0, ph_ya = 0,pa_gh = 0, pa_yh = 0, pa_ga = 0, pa_ya = 0, gh_yh = 0,gh_ya = 0,ga_yh = 0,ga_ya = 0;
    NSInteger ph_gh_h = 0, ph_yh_h = 0, ph_ga_h = 0, ph_ya_h = 0,pa_gh_h = 0, pa_yh_h = 0, pa_ga_h = 0, pa_ya_h = 0, gh_yh_h = 0,gh_ya_h = 0,ga_yh_h = 0,ga_ya_h = 0;
    NSInteger ph_gh_a = 0, ph_yh_a = 0, ph_ga_a = 0, ph_ya_a = 0,pa_gh_a = 0, pa_yh_a = 0, pa_ga_a = 0, pa_ya_a = 0, gh_yh_a = 0,gh_ya_a = 0,ga_yh_a = 0,ga_ya_a = 0;
    //三种
    NSInteger ph_gh_yh = 0,ph_gh_ya = 0,ph_ga_yh = 0,ph_ga_ya = 0,pa_gh_yh = 0,pa_gh_ya = 0,pa_ga_yh = 0,pa_ga_ya = 0;
    NSInteger ph_gh_yh_h = 0,ph_gh_ya_h = 0,ph_ga_yh_h = 0,ph_ga_ya_h = 0,pa_gh_yh_h = 0,pa_gh_ya_h = 0,pa_ga_yh_h = 0,pa_ga_ya_h = 0;
    NSInteger ph_gh_yh_a = 0,ph_gh_ya_a = 0,ph_ga_yh_a = 0,ph_ga_ya_a = 0,pa_gh_yh_a = 0,pa_gh_ya_a = 0,pa_ga_yh_a = 0,pa_ga_ya_a = 0;
    
    //不让
    NSInteger ph_h_no = 0, gh_h_no = 0,pa_h_no = 0,ga_h_no = 0,ph_a_no = 0, gh_a_no = 0,pa_a_no = 0,ga_a_no = 0;
    NSInteger ph_gh_h_no = 0, ph_ga_h_no = 0,pa_gh_h_no = 0, pa_ga_h_no = 0,ph_gh_a_no = 0, ph_ga_a_no = 0,pa_gh_a_no = 0, pa_ga_a_no = 0;
    
    for (SYBasketBallModel *model in self.datas) {
        
        if (model.homeScore.length == 0 || model.homeScore.integerValue == 0) {
            continue;
        }
        
//        if (fabs((model.BfAmountHome - model.BfAmountAway)/model.totalPAmount)< 0.6) {
//            continue;
//        }
        
        NSInteger resultNum = 0;
        NSInteger resultNum_no = 0;
        if (model.BfAmountHome >= model.BfAmountAway) {
            resultNum += 100;
            resultNum_no += 10;
        }
        if (model.BfIndexHome >= model.BfIndexAway) {
            resultNum += 10;
            resultNum_no += 1;
        }
        if (model.BfPayoutHome > model.BfPayoutAway) {
            resultNum += 1;
        }
        
        
        if (resultNum_no == 11) {
            if (model.homeScore.integerValue > model.awayScore.integerValue) {
                ph_h_no++,gh_h_no++,ph_gh_h_no++;
            }else {
                ph_a_no++,gh_a_no++,ph_gh_a_no++;
            }
        }else if (resultNum_no == 10){
            if (model.homeScore.integerValue > model.awayScore.integerValue) {
                ph_h_no++,ga_h_no++,ph_ga_h_no++;
            }else {
                ph_a_no++,ga_a_no++,ph_ga_a_no++;
            }
        }else if (resultNum_no == 1){
            if (model.homeScore.integerValue > model.awayScore.integerValue) {
                pa_h_no++,gh_h_no++,pa_gh_h_no++;
            }else {
                pa_a_no++,gh_a_no++,pa_gh_a_no++;
            }
        }else {
            if (model.homeScore.integerValue > model.awayScore.integerValue) {
                pa_h_no++,ga_h_no++,pa_ga_h_no++;
            }else {
                pa_a_no++,ga_a_no++,pa_ga_a_no++;
            }
        }
        
        if (resultNum == 111) {
            ph++,gh++,yh++,ph_gh++,ph_yh++,gh_yh++,ph_gh_yh++;
            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                ph_h++,gh_h++,yh_h++,ph_gh_h++,ph_yh_h++,gh_yh_h++,ph_gh_yh_h++;
            }else {
                ph_a++,gh_a++,yh_a++,ph_gh_a++,ph_yh_a++,gh_yh_a++,ph_gh_yh_a++;
            }
            
        }else if (resultNum == 110) {
            ph++,gh++,ya++,ph_gh++,ph_ya++,gh_ya++,ph_gh_ya++;
            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                ph_h++,gh_h++,ya_h++,ph_gh_h++,ph_ya_h++,gh_ya_h++,ph_gh_ya_h++;
            }else {
                ph_a++,gh_a++,ya_a++,ph_gh_a++,ph_ya_a++,gh_ya_a++,ph_gh_ya_a++;
            }
            
        }else if (resultNum == 101) {
            ph++,ga++,yh++,ph_ga++,ph_yh++,ga_yh++,ph_ga_yh++;
            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                ph_h++,ga_h++,yh_h++,ph_ga_h++,ph_yh_h++,ga_yh_h++,ph_ga_yh_h++;
            }else {
                ph_a++,ga_a++,yh_a++,ph_ga_a++,ph_yh_a++,ga_yh_a++,ph_ga_yh_a++;
            }
        }else if (resultNum == 100) {
            ph++,ga++,ya++,ph_ga++,ph_ya++,ga_ya++,ph_ga_ya++;
            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                ph_h++,ga_h++,ya_h++,ph_ga_h++,ph_ya_h++,ga_ya_h++,ph_ga_ya_h++;
                NSLog(@"主 %@%@--%@--%@%@",model.HomeTeam,model.homeScore,model.AsianAvrLet,model.AwayTeam,model.awayScore);
            }else {
                NSLog(@"客 %@%@--%@--%@%@",model.HomeTeam,model.homeScore,model.AsianAvrLet,model.AwayTeam,model.awayScore);
                ph_a++,ga_a++,ya_a++,ph_ga_a++,ph_ya_a++,ga_ya_a++,ph_ga_ya_a++;
            }
            
        }else if (resultNum == 11) {
            pa++,gh++,yh++,pa_gh++,pa_yh++,gh_yh++,pa_gh_yh++;
            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                pa_h++,gh_h++,yh_h++,pa_gh_h++,pa_yh_h++,gh_yh_h++,pa_gh_yh_h++;
            }else {
                pa_a++,gh_a++,yh_a++,pa_gh_a++,pa_yh_a++,gh_yh_a++,pa_gh_yh_a++;
            }
        }else if (resultNum == 10) {
            pa++,gh++,ya++,pa_gh++,pa_ya++,gh_ya++,pa_gh_ya++;
            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                pa_h++,gh_h++,ya_h++,pa_gh_h++,pa_ya_h++,gh_ya_h++,pa_gh_ya_h++;
            }else {
                pa_a++,gh_a++,ya_a++,pa_gh_a++,pa_ya_a++,gh_ya_a++,pa_gh_ya_a++;
            }
        }else if (resultNum == 1) {
            pa++,ga++,yh++,pa_ga++,pa_yh++,ga_yh++,pa_ga_yh++;
            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                pa_h++,ga_h++,yh_h++,pa_ga_h++,pa_yh_h++,ga_yh_h++,pa_ga_yh_h++;
            }else {
                pa_a++,ga_a++,yh_a++,pa_ga_a++,pa_yh_a++,ga_yh_a++,pa_ga_yh_a++;
            }
        }else if (resultNum == 0) {
            pa++,ga++,ya++,pa_ga++,pa_ya++,ga_ya++,pa_ga_ya++;
            if (model.homeScore.integerValue > model.awayScore.integerValue + model.AsianAvrLet.floatValue) {
                pa_h++,ga_h++,ya_h++,pa_ga_h++,pa_ya_h++,ga_ya_h++,pa_ga_ya_h++;
            }else {
                pa_a++,ga_a++,ya_a++,pa_ga_a++,pa_ya_a++,ga_ya_a++,pa_ga_ya_a++;
            }
        }
        
    }
    
    _analysisDatas = [NSMutableArray array];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交易(主)" home:ph_h away:ph_a]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交易(客)" home:pa_h away:pa_a]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"概率(主)" home:gh_h away:gh_a]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"概率(客)" home:ga_h away:ga_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"盈亏(主)" home:yh_h away:yh_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"盈亏(客)" home:ya_h away:ya_a]];
    
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)概(主)" home:ph_gh_h away:ph_gh_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)盈(主)" home:ph_yh_h away:ph_yh_a]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)概(客)" home:ph_ga_h away:ph_ga_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)盈(客)" home:ph_ya_h away:ph_ya_a]];
    
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)概(主)" home:pa_gh_h away:pa_gh_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)盈(主)" home:pa_yh_h away:pa_yh_a]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)概(客)" home:pa_ga_h away:pa_ga_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)盈(客)" home:pa_ya_h away:pa_ya_a]];
    
    SYDataAnalysisModel *title = [SYDataAnalysisModel new];
    title.oneStr = @"****";
    title.twoStr = @"****";
    title.threeStr = @"****";
    [_analysisDatas addObject:title];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交易(主)" home:ph_h_no away:ph_a_no]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交易(客)" home:pa_h_no away:pa_a_no]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"概率(主)" home:gh_h_no away:gh_a_no]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"概率(客)" home:ga_h_no away:ga_a_no]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)概(主)" home:ph_gh_h_no away:ph_gh_a_no]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)概(客)" home:ph_ga_h_no away:ph_ga_a_no]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)概(主)" home:pa_gh_h_no away:pa_gh_a_no]];
    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)概(客)" home:pa_ga_h_no away:pa_ga_a_no]];
    
    
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"概(主)盈(主)" home:gh_yh_h away:gh_yh_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"概(客)盈(主)" home:ga_yh_h away:ga_yh_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"概(主)盈(客)" home:gh_ya_h away:gh_ya_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"概(客)盈(客)" home:ga_ya_h away:ga_ya_a]];
    
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)概(主)盈(主)" home:ph_gh_yh_h away:ph_gh_yh_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)概(主)盈(客)" home:ph_gh_ya_h away:ph_gh_ya_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)概(客)盈(主)" home:ph_ga_yh_h away:ph_ga_yh_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(主)概(客)盈(客)" home:ph_ga_ya_h away:ph_ga_ya_a]];
//    
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)概(主)盈(主)" home:pa_gh_yh_h away:pa_gh_yh_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)概(主)盈(客)" home:pa_gh_ya_h away:pa_gh_ya_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)概(客)盈(主)" home:pa_ga_yh_h away:pa_ga_yh_a]];
//    [_analysisDatas addObject:[SYDataAnalysisModel modelWithTitle:@"交(客)概(客)盈(客)" home:pa_ga_ya_h away:pa_ga_ya_a]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
@end
