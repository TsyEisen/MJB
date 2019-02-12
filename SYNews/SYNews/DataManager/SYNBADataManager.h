//
//  SYNBADataManager.h
//  SYNews
//
//  Created by leju_esf on 2018/12/13.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYBasketBallModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SYNBAListType) {
    SYNBAListTypeToday,
    SYNBAListTypeHistory,
    SYNBAListTypeNoScore,
    SYNBAListTypeHasScore
};

@interface SYNBADataManager : NSObject
SYSingleton_interface(SYNBADataManager)

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableDictionary *gameIdToResultGameName;
//排名
@property (nonatomic, strong) NSMutableDictionary *ranks;
//球队推荐分析
@property (nonatomic, strong) NSArray *gamePush;

- (void)requestDatasByType:(SYNBAListType)type Completion:(void(^)(NSArray *datas))completion;

- (void)requestResultByDate:(NSDate *)date completion:(void (^)(id result))completion;

- (void)requestHistoryWithModel:(SYBasketBallModel *)model completion:(void (^)(NSArray *result,NSArray *groups))completion;

- (void)copyScoreFrom:(SYBasketBallModel *)result toGame:(SYBasketBallModel *)game;
- (void)changeScoreWithModels:(NSArray *)models;
- (void)deleteModel:(SYBasketBallModel *)model;
- (void)replaceDataForNewest;
@end

@interface SYNBADataAnalyze : NSObject
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger homeCount;
@property (nonatomic, assign) NSInteger awayCount;
@property (nonatomic, assign) NSInteger totalCount;
@end

NS_ASSUME_NONNULL_END
