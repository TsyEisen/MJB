//
//  SYGameListCell.m
//  SYNews
//
//  Created by 唐绍禹 on 2018/9/23.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYGameListCell.h"
#import "NSDate+SYExtension.h"

typedef NS_ENUM(NSUInteger, SYGameProbabilityType) {
    SYGameProbabilityTypeHome,
    SYGameProbabilityTypeDraw,
    SYGameProbabilityTypeAway
};

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
@property (weak, nonatomic) IBOutlet UILabel *lastTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;


//@property (nonatomic, strong) SYSportDataProbability *probability;
//@property (nonatomic, strong) NSMutableArray *probabilitys;
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
    self.fcHomeLabel.text = [NSString stringWithFormat:@"%.1f",model.KellyHome];
    self.fcDrawLabel.text = [NSString stringWithFormat:@"%.1f",model.KellyDraw];
    self.fcAwayLabel.text = [NSString stringWithFormat:@"%.1f",model.KellyAway];

    if (model.recommendType > 0 && self.recommend) {
//        self.lastTitleLabel.text = @"推介";
//        self.jsHomeLabel.text = nil;
//        self.jsAwayLabel.text = nil;
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
        self.recommendLabel.text = title;
        self.backgroundColor = model.resultType & model.recommendType?[UIColor appMainColor]:[UIColor whiteColor];
        self.contentView.backgroundColor = model.resultType & model.recommendType?[UIColor appMainColor]:[UIColor whiteColor];
    }else {
        self.recommendLabel.text = nil;
    }
    
    if (model.probability) {
        self.lastTitleLabel.text = @"方差概率";
        self.jsHomeLabel.text = [self showMessageWithType:SYGameProbabilityTypeHome];
        self.jsDrawLabel.text = [self showMessageWithType:SYGameProbabilityTypeDraw];
        self.jsAwayLabel.text = [self showMessageWithType:SYGameProbabilityTypeAway];
    }else {
        self.lastTitleLabel.text = nil;
        self.jsHomeLabel.text = nil;
        self.jsDrawLabel.text = nil;
        self.jsAwayLabel.text = nil;
    }
}

- (NSString *)showMessageWithType:(SYGameProbabilityType)type{
    
    NSString *pro = nil;
    switch (type) {
        case SYGameProbabilityTypeHome:
            pro = _model.global.gl_home == 0 ? @"0":[NSString stringWithFormat:@"%.2f",_model.global.gl_home];
            break;
        case SYGameProbabilityTypeDraw:
            pro = _model.global.gl_draw == 0 ? @"0":[NSString stringWithFormat:@"%.2f",_model.global.gl_draw];
            break;
        case SYGameProbabilityTypeAway:
            pro = _model.global.gl_away == 0 ? @"0":[NSString stringWithFormat:@"%.2f",_model.global.gl_away];
            break;
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@\n%@",[self showProbabilityMessageWithModel:_model.probability type:type],pro];
}

- (NSString *)showProbabilityMessageWithModel:(SYDataProbability *)model type:(SYGameProbabilityType)type {
    switch (type) {
        case SYGameProbabilityTypeHome:
            if (model.gl_home == 0) {
                return @"0";
            } else {
                return [NSString stringWithFormat:@"%.2f(%zd/%zd)",model.gl_home,model.count_home,model.total];
            }
            break;
        case SYGameProbabilityTypeDraw:
            if (model.gl_draw == 0) {
                return @"0";
            } else {
                return [NSString stringWithFormat:@"%.2f(%zd/%zd)",model.gl_draw,model.count_draw,model.total];
            }
            break;
        case SYGameProbabilityTypeAway:
            if (model.gl_away == 0) {
                return @"0";
            } else {
                return [NSString stringWithFormat:@"%.2f(%zd/%zd)",model.gl_away,model.count_away,model.total];
            }
            break;
        default:
            return @"0";
            break;
    }
}

//- (NSMutableArray *)probabilitys {
//    if (_probabilitys == nil) {
//        _probabilitys = [[NSMutableArray alloc] init];
//    }
//    return _probabilitys;
//}
@end
