//
//  SYSportDataManager.h
//  SYNews
//
//  Created by 唐绍禹 on 2018/9/22.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYGameModel.h"
#import "SYSportModel.h"
#import "SYGameListModel.h"
#import "SYRecommendModel.h"

typedef NS_ENUM(NSUInteger, SYSportDataType) {
    SYSportDataTypeHomeSport,
    SYSportDataTypeCatagorySport,
    SYSportDataTypeGameDetail
};

typedef NS_ENUM(NSUInteger, SYListType) {
    SYListTypeCategory = 1,
    SYListTypeNear = 2,
    SYListTypePayTop = 3,
    SYListTypeHistory = 4,
    SYListTypeCompare = 5,
    SYListTypeCompare_all = 6,
    SYListTypeNoScore = 7,
    SYListTypeCompare_HighQuality = 8,
    SYListTypeCompare_HighQuality_all = 9,
};

@interface SYSportDataManager : NSObject
SYSingleton_interface(SYSportDataManager)

@property (nonatomic, strong) NSMutableArray *recommends;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableDictionary *replaceNames;

- (void)requestDatasBySYListType:(SYListType)type Completion:(void(^)(NSArray *datas))completion;
//- (void)changeScoreModel:(SYGameListModel *)model;
- (void)changeScoreWithModels:(NSArray *)models;
- (void)deleteModel:(SYGameListModel *)model;
- (void)replaceDataForNewest;

- (void)creatNewRecommend:(NSString *)name;
- (void)deleteRecommendAtIndex:(NSInteger)index;

- (void)replaceNameForTeamId:(NSInteger)teamId byName:(NSString *)name;

@end
