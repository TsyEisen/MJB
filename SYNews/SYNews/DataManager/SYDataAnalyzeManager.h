//
//  SYDataAnalyzeManager.h
//  SYNews
//
//  Created by leju_esf on 2018/12/6.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYDataProbability.h"
#import "SYGameResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYDataAnalyzeManager : NSObject
SYSingleton_interface(SYDataAnalyzeManager)

@property (nonatomic, strong) SYSportDataProbability *global;
@property (nonatomic, strong) NSArray *sports;

//自动赋值
@property (nonatomic, strong) NSMutableDictionary *sportIdToResultSprorId;
@property (nonatomic, strong) NSMutableDictionary *gameIdToResultGameName;

- (void)calculatorDatas;


- (void)requestResultByDate:(NSDate *)date completion:(void (^)(id result))completion;

//- (void)requestResultWithModel:(SYGameListModel *)model completion:(void (^)(NSArray *array))completion;

- (void)copyScoreFrom:(SYGameResultModel *)result toGame:(SYGameListModel *)game;
@end

NS_ASSUME_NONNULL_END
