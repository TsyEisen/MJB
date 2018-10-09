//
//  SYGameTableTitleCell.m
//  SYNews
//
//  Created by leju_esf on 2018/9/29.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYGameTableTitleCell.h"

@interface SYGameTableTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *vsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastRefreshTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayScoreLabel;
@end

@implementation SYGameTableTitleCell

- (void)setModel:(SYGameListModel *)model {
    _model = model;
//    self.homeLabel.text = model.HomeTeam;
//    self.awayLabel.text = model.AwayTeam;
//    self.vsLabel.text = [NSString stringWithFormat:@"VS %@",model.AsianAvrLet];
//    self.lastRefreshTimeLabel.text = [NSDate sy_showMatchTimeWithTime:model.MaxUpdateTime];
//    self.homeScoreLabel.text = model.homeScore;
//    self.awayScoreLabel.text = model.awayScore;
//    self.moneyLabel.text = [NSString stringWithFormat:@"%.1f万",model.totalPAmount/10000];
    
    self.homeLabel.text = nil;
    self.awayLabel.text = nil;
    self.vsLabel.text = [NSString stringWithFormat:@"%@ %@",model.SortName,model.AsianAvrLet];
    self.lastRefreshTimeLabel.text = [NSDate sy_showMatchTimeWithTime:model.MaxUpdateTime];
    self.homeScoreLabel.text = model.homeScore;
    self.awayScoreLabel.text = model.awayScore;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.1f万",model.totalPAmount/10000];
}

@end
