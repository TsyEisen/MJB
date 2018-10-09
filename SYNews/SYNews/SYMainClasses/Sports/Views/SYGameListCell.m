//
//  SYGameListCell.m
//  SYNews
//
//  Created by 唐绍禹 on 2018/9/23.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYGameListCell.h"
#import "NSDate+SYExtension.h"

@interface SYGameListCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *drawLabel;
@property (weak, nonatomic) IBOutlet UILabel *jyHomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jyDrawLabel;
@property (weak, nonatomic) IBOutlet UILabel *jyAwayLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *vsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastRefreshTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *glHomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *glDrawLabel;
@property (weak, nonatomic) IBOutlet UILabel *glAwayLabel;

@property (weak, nonatomic) IBOutlet UILabel *fcHomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fcDrawLabel;
@property (weak, nonatomic) IBOutlet UILabel *fcAwayLabel;

@property (weak, nonatomic) IBOutlet UILabel *jsHomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jsDrawLabel;
@property (weak, nonatomic) IBOutlet UILabel *jsAwayLabel;
@end

@implementation SYGameListCell

- (void)setModel:(SYGameListModel *)model {
    _model = model;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@",model.SortName,[NSDate sy_showMatchTimeWithTime:model.MatchTime]];
    self.homeLabel.text = model.HomeTeam;
    self.drawLabel.text = model.AwayTeam;
    self.vsLabel.text = [NSString stringWithFormat:@"VS %@",model.AsianAvrLet];
    
//    SYGameScoreType sigle_pay_type = model.MaxTeamId == model.HomeTeamId?SYGameScoreTypeHome : SYGameScoreTypeAway;
    
    self.lastRefreshTimeLabel.text = [NSString stringWithFormat:@"最后刷新时间:%@ 单笔交易最大:%@ %.2f万",[NSDate sy_showMatchTimeWithTime:model.MaxUpdateTime],model.MaxTeamId == model.HomeTeamId?@"主":@"客",model.MaxTradedChange/10000];
    self.scoreLabel.text = model.score;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.1f万",model.totalPAmount/10000];
    self.jyHomeLabel.text = [NSString stringWithFormat:@"%.2f",model.BfAmountHome/model.totalPAmount];
    self.jyDrawLabel.text = [NSString stringWithFormat:@"%.2f",model.BfAmountDraw/model.totalPAmount];
    self.jyAwayLabel.text = [NSString stringWithFormat:@"%.2f",model.BfAmountAway/model.totalPAmount];
    self.glHomeLabel.text = [NSString stringWithFormat:@"%.2f",model.BfIndexHome/100];
    self.glDrawLabel.text = [NSString stringWithFormat:@"%.2f",model.BfIndexDraw/100];
    self.glAwayLabel.text = [NSString stringWithFormat:@"%.2f",model.BfIndexAway/100];
    self.fcHomeLabel.text = [NSString stringWithFormat:@"%.f",model.KellyHome];
    self.fcDrawLabel.text = [NSString stringWithFormat:@"%.f",model.KellyDraw];
    self.fcAwayLabel.text = [NSString stringWithFormat:@"%.f",model.KellyAway];

    self.jsHomeLabel.text = [NSString stringWithFormat:@"%.f",model.BfAmountHome*model.BfIndexHome/10000];
    self.jsDrawLabel.text = [NSString stringWithFormat:@"%.f",model.BfAmountDraw*model.BfIndexDraw/10000];
    self.jsAwayLabel.text = [NSString stringWithFormat:@"%.f",model.BfAmountAway*model.BfIndexAway/10000];
}



//- (void)setModel:(SYGameModel *)model {
//    _model = model;
//    self.moneyLabel.text = [NSString stringWithFormat:@"%.f",(model.BfAmountHome + model.BfAmountAway + model.BfAmountDraw)/10000];
//
//    self.jyHomeLabel.text = [NSString stringWithFormat:@"%.f",model.BfPerHome];
//    self.jyDrawLabel.text = [NSString stringWithFormat:@"%.f",model.BfPerDraw];
//    self.jyAwayLabel.text = [NSString stringWithFormat:@"%.f",model.BfPerAway];
//    self.glHomeLabel.text = [NSString stringWithFormat:@"%.f",model.BfIndexHome];
//    self.glDrawLabel.text = [NSString stringWithFormat:@"%.f",model.BfIndexDraw];
//    self.glAwayLabel.text = [NSString stringWithFormat:@"%.f",model.BfIndexAway];
//    self.fcHomeLabel.text = [NSString stringWithFormat:@"%.f",model.KellyHome];
//    self.fcDrawLabel.text = [NSString stringWithFormat:@"%.f",model.KellyDraw];
//    self.fcAwayLabel.text = [NSString stringWithFormat:@"%.f",model.KellyAway];
//
//    self.jsHomeLabel.text = [NSString stringWithFormat:@"%.f",model.BfPerHome * model.BfIndexHome*0.01/ model.KellyHome];
//    self.jsDrawLabel.text = [NSString stringWithFormat:@"%.f",model.BfPerDraw * model.BfIndexDraw*0.01 / model.KellyDraw];
//    self.jsAwayLabel.text = [NSString stringWithFormat:@"%.f",model.BfPerDraw * model.BfIndexAway*0.01 / model.KellyAway];
//
//}
@end
