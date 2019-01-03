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
    SYNBAListTypeAll
};

@interface SYNBADataManager : NSObject
SYSingleton_interface(SYNBADataManager)

@property (nonatomic, strong) NSTimer *timer;

- (void)requestDatasByType:(SYNBAListType)type Completion:(void(^)(NSArray *datas))completion;

- (void)requestResultByDate:(NSDate *)date completion:(void (^)(id result))completion;

- (void)changeScoreWithModels:(NSArray *)models;
- (void)deleteModel:(SYBasketBallModel *)model;
- (void)replaceDataForNewest;
@end

NS_ASSUME_NONNULL_END
