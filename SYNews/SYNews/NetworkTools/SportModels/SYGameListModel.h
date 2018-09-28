//
//  SYGameListModel.h
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "EventId": 28875078,
 "MatchTime": "2018-09-22T19:30:00",
 "HomeTeam": "富勒姆",
 "AwayTeam": "沃特福德",
 "HomeTeamId": 56764,
 "AwayTeamId": 56301,
 "AsianAvrLet": "-0.25",
 "EventTypeId": 1,
 "LeagueId": 287,
 "Classifnication": 1,
 "SortName": "英超",
 "BfPayoutHome": -32.3633,
 "BfPayoutDraw": -0.5485,
 "BfPayoutAway": 39.8133,
 "BfOddsHome": 2.56,
 "BfOddsDraw": 3.6,
 "BfOddsAway": 3.05,
 "BfIndexHome": 22.0386,
 "BfIndexDraw": 32.405,
 "BfIndexAway": 45.556399999999996,
 "BfAmountHome": 71745.1,
 "BfAmountDraw": 74808.9,
 "BfAmountAway": 124795.87,
 "MediaIndexHome": 0.0,
 "MediaIndexDraw": 0.0,
 "MediaIndexAway": 0.0,
 "KellyHome": 5.7106,
 "KellyDraw": 8.1282,
 "KellyAway": 6.6825,
 "UnusualIndex": 0,
 "UnusualPayout": 0,
 "UnusualHot": 0,
 "MaxTeamId": 56301,
 "MaxUpdateTime": "2018-09-21T05:02:52",
 "MaxLastOdds": 3.0,
 "MaxTradedChange": 9237.75,
 "IsTutorial": false
 }
 */

@interface SYGameListModel : NSObject

@property (nonatomic, copy) NSString *AsianAvrLet;

@property (nonatomic, assign) CGFloat BfPayoutAway;

@property (nonatomic, assign) NSInteger EventTypeId;

@property (nonatomic, assign) CGFloat BfIndexAway;

@property (nonatomic, assign) NSInteger MaxLastOdds;

@property (nonatomic, copy) NSString *MaxUpdateTime;

@property (nonatomic, assign) CGFloat KellyHome;

@property (nonatomic, assign) CGFloat KellyAway;

@property (nonatomic, assign) CGFloat BfOddsHome;

@property (nonatomic, assign) NSInteger MediaIndexDraw;

@property (nonatomic, assign) NSInteger UnusualHot;

@property (nonatomic, assign) BOOL IsTutorial;

@property (nonatomic, assign) CGFloat BfOddsDraw;

@property (nonatomic, assign) NSInteger MaxTeamId;

@property (nonatomic, assign) NSInteger Classifnication;

@property (nonatomic, assign) CGFloat MaxTradedChange;

@property (nonatomic, copy) NSString *AwayTeam;

@property (nonatomic, assign) CGFloat BfIndexDraw;

@property (nonatomic, assign) CGFloat KellyDraw;

@property (nonatomic, assign) NSInteger MediaIndexAway;

@property (nonatomic, assign) NSInteger MediaIndexHome;

@property (nonatomic, copy) NSString *MatchTime;

@property (nonatomic, assign) NSInteger UnusualIndex;

@property (nonatomic, assign) NSInteger HomeTeamId;

@property (nonatomic, assign) NSInteger EventId;

@property (nonatomic, assign) CGFloat BfOddsAway;

@property (nonatomic, assign) CGFloat BfIndexHome;

@property (nonatomic, assign) CGFloat BfAmountHome;

@property (nonatomic, assign) NSInteger AwayTeamId;

@property (nonatomic, assign) NSInteger LeagueId;

@property (nonatomic, assign) CGFloat BfAmountDraw;

@property (nonatomic, copy) NSString *SortName;

@property (nonatomic, copy) NSString *HomeTeam;

@property (nonatomic, assign) CGFloat BfAmountAway;

@property (nonatomic, assign) CGFloat totalPAmount;

@property (nonatomic, assign) CGFloat BfPayoutHome;

@property (nonatomic, assign) NSInteger UnusualPayout;

@property (nonatomic, assign) CGFloat BfPayoutDraw;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *homeScore;

@property (nonatomic, copy) NSString *awayScore;

@property(nonatomic,assign)NSInteger dateSeconds;
@end

typedef NS_ENUM(NSUInteger, SYGameScoreType) {
    SYGameScoreTypeHome,
    SYGameScoreTypeDraw,
    SYGameScoreTypeAway
};

@interface SYNumberModel : NSObject
@property (nonatomic, assign) SYGameScoreType status;
@property (nonatomic, assign) CGFloat num;
+ (instancetype)modelWithStatus:(SYGameScoreType)type num:(CGFloat)num;
@end
