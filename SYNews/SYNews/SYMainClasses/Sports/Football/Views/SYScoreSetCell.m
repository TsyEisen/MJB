//
//  SYScoreSetCell.m
//  SYNews
//
//  Created by leju_esf on 2018/12/19.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYScoreSetCell.h"
#import "NSDate+SYExtension.h"

@interface SYScoreSetCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayScoreLabel;

@end

@implementation SYScoreSetCell
- (void)setModel:(id)model {
    _model = model;
    
    if ([model isKindOfClass:[SYGameListModel class]]) {
        SYGameListModel *item = (SYGameListModel *)model;
        self.dateLabel.text = [NSDate sy_showMatchTimeWithTime:item.MatchTime];
        self.homeLabel.text = item.HomeTeam;
        self.awayLabel.text = item.AwayTeam;
        self.homeScoreLabel.text = item.homeScore;
        self.awayScoreLabel.text = item.awayScore;
    }else if ([model isKindOfClass:[SYGameResultModel class]]) {
        //20181212183000
        SYGameResultModel *item = (SYGameResultModel *)model;
        self.dateLabel.text = [self timeForResult:item];
        self.homeLabel.text = item.hTeam;
        self.awayLabel.text = item.gTeam;
        self.homeScoreLabel.text = item.hScore;
        self.awayScoreLabel.text = item.gScore;
    }
}

- (NSString *)timeForResult:(SYGameResultModel *)result {
    NSDate *date = [NSDate sy_dateWithString:result.time formate:@"yyyyMMddHHmmss"];
    return [date sy_stringWithFormat:@"MM-dd HH:mm"];
}
@end
