//
//  SYBasketballListCell.m
//  SYNews
//
//  Created by leju_esf on 2019/1/3.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYBasketballListCell.h"
#import "NSDate+SYExtension.h"

@interface SYBasketballListCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayLabel;

@property (weak, nonatomic) IBOutlet UILabel *jyHomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jyAwayLabel;

@property (weak, nonatomic) IBOutlet UILabel *glHomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *glAwayLabel;

@property (weak, nonatomic) IBOutlet UILabel *ykHomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ykAwayLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreHomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreAwayLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastRefreshTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *avrScoreLabel;
@end

@implementation SYBasketballListCell

- (void)setModel:(SYBasketBallModel *)model {
    _model = model;
    //
    if (self.currentGame) {
        
        if ([self.currentGame.HomeTeam isEqualToString:model.HomeTeam]) {
            self.homeLabel.textColor = [UIColor appMainColor];
        }else if ([self.currentGame.AwayTeam isEqualToString:model.HomeTeam]) {
            self.homeLabel.textColor = [UIColor sy_colorWithRGB:0x3CB371];
        }else {
            self.homeLabel.textColor = [UIColor sy_colorWithRGB:0x333333];
        }
        
        if ([self.currentGame.HomeTeam isEqualToString:model.AwayTeam]) {
            self.awayLabel.textColor = [UIColor appMainColor];
        }else if ([self.currentGame.AwayTeam isEqualToString:model.AwayTeam]) {
            self.awayLabel.textColor = [UIColor sy_colorWithRGB:0x3CB371];
        }else {
            self.awayLabel.textColor = [UIColor sy_colorWithRGB:0x333333];
        }
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@",model.SortName,[NSDate sy_showMatchTimeWithTime:model.MatchTime]];
    if (model.homeGroupRank.length > 0) {
        self.homeLabel.text = [NSString stringWithFormat:@"%@(%@)",model.HomeTeam,model.homeGroupRank];
    }else {
        self.homeLabel.text = model.HomeTeam;
    }
    
    if (model.awayGroupRank.length > 0) {
        self.awayLabel.text = [NSString stringWithFormat:@"%@(%@)",model.AwayTeam,model.awayGroupRank];
    }else {
        self.awayLabel.text = model.AwayTeam;
    }
    

    self.lastRefreshTimeLabel.text = [NSString stringWithFormat:@"最后刷新时间:%@ 单笔交易最大:%@ %.2f万",[[NSDate sy_showMatchTimeWithTime:model.MaxUpdateTime] stringByReplacingOccurrencesOfString:@"\n" withString:@" "],model.MaxTeamId.integerValue == model.HomeTeamId.integerValue?@"主":@"客",model.MaxTradedChange/10000];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.1f万",model.totalPAmount/10000];
    
    self.jyHomeLabel.text = [NSString stringWithFormat:@"%.2f",model.BfAmountHome/model.totalPAmount];
    self.jyAwayLabel.text = [NSString stringWithFormat:@"%.2f",model.BfAmountAway/model.totalPAmount];
    self.glHomeLabel.text = [NSString stringWithFormat:@"%.2f",model.BfIndexHome/100];
    self.glAwayLabel.text = [NSString stringWithFormat:@"%.2f",model.BfIndexAway/100];
    
    self.ykHomeLabel.text = [NSString stringWithFormat:@"%.1f",model.BfPayoutHome];
    self.ykAwayLabel.text = [NSString stringWithFormat:@"%.1f",model.BfPayoutAway];
    
    self.scoreHomeLabel.text = model.homeScore;
    self.scoreAwayLabel.text = model.awayScore;
    
//    if (model.AsianAvrLet.length > 0 && model.dishTotalScore.length > 0) {
//
//    }else {
//        self.avrScoreLabel.text = nil;
//    }
    
    self.avrScoreLabel.text = [NSString stringWithFormat:@"让分  %@   总分  %@",model.AsianAvrLet.integerValue == 0?@"--":model.AsianAvrLet,model.dishTotalScore?:@"--"];
}

@end
