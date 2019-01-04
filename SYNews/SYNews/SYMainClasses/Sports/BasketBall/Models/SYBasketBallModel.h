//
//  SYBasketBallModel.h
//  SYNews
//
//  Created by leju_esf on 2019/1/3.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "EventId": 29065351,
 "MatchTime": "2019-01-03T11:40:00",
 "HomeTeam": "洛杉矶湖人队",
 "AwayTeam": "俄克拉荷马雷霆",
 "HomeTeamId": 5368712,
 "AwayTeamId": 3319741,
 "AsianAvrLet": "0",
 "EventTypeId": 7522,
 "LeagueId": 230,
 "Classifnication": -1,
 "SortName": "NBA",
 "BfPayoutHome": -22.9706,
 "BfPayoutDraw": 0.0,
 "BfPayoutAway": 10.8822,
 "BfOddsHome": 3.15,
 "BfOddsDraw": 0.0,
 "BfOddsAway": 1.46,
 "BfIndexHome": 40.9924,
 "BfIndexDraw": 0.0,
 "BfIndexAway": 59.0076,
 "BfAmountHome": 103553.48,
 "BfAmountDraw": 0.0,
 "BfAmountAway": 298537.39,
 "MediaIndexHome": 0.0,
 "MediaIndexDraw": 0.0,
 "MediaIndexAway": 0.0,
 "KellyHome": 0.0,
 "KellyDraw": 0.0,
 "KellyAway": 0.0,
 "UnusualIndex": 0,
 "UnusualPayout": 0,
 "UnusualHot": 0,
 "MaxTeamId": 3319741,
 "MaxUpdateTime": "2019-01-03T11:39:46",
 "MaxLastOdds": 1.46,
 "MaxTradedChange": 32950.640000000014,
 "IsTutorial": false
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface SYBasketBallModel : NSObject

@property (nonatomic, copy) NSString *EventId;
@property (nonatomic, copy) NSString *MatchTime;
@property (nonatomic, copy) NSString *HomeTeam;
@property (nonatomic, copy) NSString *AwayTeam;
@property (nonatomic, copy) NSString *HomeTeamId;
@property (nonatomic, copy) NSString *AwayTeamId;
@property (nonatomic, copy) NSString *LeagueId;
@property (nonatomic, copy) NSString *SortName;
/**
 模拟盈亏-主
 */
@property (nonatomic, assign) CGFloat BfPayoutHome;
/**
 模拟盈亏-客
 */
@property (nonatomic, assign) CGFloat BfPayoutAway;
/**
 主胜概率
 */
@property (nonatomic, assign) CGFloat BfIndexHome;
/**
 客胜概率
 */
@property (nonatomic, assign) CGFloat BfIndexAway;
/**
 主交易
 */
@property (nonatomic, assign) CGFloat BfAmountHome;
/**
 客交易
 */
@property (nonatomic, assign) CGFloat BfAmountAway;
/**
 最大交易方Id
 */
@property (nonatomic, copy) NSString *MaxTeamId;
/**
 最后更新时间
 */
@property (nonatomic, copy) NSString *MaxUpdateTime;
/**
 单笔最大交易额
 */
@property (nonatomic, assign) CGFloat MaxTradedChange;

@property (nonatomic, copy) NSString *homeScore;

@property (nonatomic, copy) NSString *awayScore;
/**
 让分
 */
@property (nonatomic, copy) NSString *AsianAvrLet;
/**
 盘口总分
 */
@property (nonatomic, copy) NSString *dishTotalScore;

@property (nonatomic, copy) NSString *result;

@property (nonatomic, copy) NSString *homeGroupRank;

@property (nonatomic, copy) NSString *awayGroupRank;

@property (nonatomic, assign) CGFloat totalPAmount;

@property(nonatomic,assign)NSInteger dateSeconds;

@property (nonatomic, assign) NSInteger updateSeconds;

@property (nonatomic, copy) NSString *showTime;
@end

NS_ASSUME_NONNULL_END
