//
//  SYDataAnalyzeManager.h
//  SYNews
//
//  Created by leju_esf on 2018/12/6.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYDataProbability.h"
NS_ASSUME_NONNULL_BEGIN

@interface SYDataAnalyzeManager : NSObject
SYSingleton_interface(SYDataAnalyzeManager)

@property (nonatomic, strong) SYSportDataProbability *global;
@property (nonatomic, strong) NSArray *sports;

- (void)calculatorDatas;


- (void)requestResultByDate:(NSDate *)date completion:(void (^)(id result))completion;

- (void)requestResultWithModel:(SYGameListModel *)model completion:(void (^)(NSArray *array))completion;
@end

NS_ASSUME_NONNULL_END
