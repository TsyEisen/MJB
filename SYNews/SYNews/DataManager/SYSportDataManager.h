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

typedef NS_ENUM(NSUInteger, SYSportDataType) {
    SYSportDataTypeHomeSport,
    SYSportDataTypeCatagorySport,
    SYSportDataTypeGameDetail
};

typedef NS_ENUM(NSUInteger, SYListType) {
    SYListTypeCategory = 0,
    SYListTypePayTop = 1,
    SYListTypeNear = 2,
    SYListTypeHistory = 3,
    SYListTypeCompare = 4
};

@interface SYSportDataManager : NSObject
SYSingleton_interface(SYSportDataManager)

@property (nonatomic, strong) NSTimer *timer;
- (void)requestDatasBySYListType:(SYListType)type Completion:(void(^)(NSArray *datas))completion;
- (void)changeScoreModel:(SYGameListModel *)model;
@end
