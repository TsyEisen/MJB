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


//@interface SYGameDataBase : NSObject
//- (instancetype)initwithType:()
//@property (nonatomic, strong) NSMutableDictionary *jsons;
//@property (nonatomic, strong) NSArray *models;
//@end

@interface SYSportDataManager : NSObject
SYSingleton_interface(SYSportDataManager)
@property (nonatomic, strong) NSArray *payTopList;
@property (nonatomic, strong) NSArray *nearList;
@property (nonatomic, strong) NSArray *categaryList;
@property (nonatomic, strong) NSArray *hotGameList;

@property (nonatomic, strong) NSArray *scoreGames;

- (void)changeScoreModel:(SYGameListModel *)model;
- (void)saveHotGame:(SYGameListModel *)model;
- (void)deleteHotGame:(SYGameListModel *)model;
- (void)reuqestAllSportsCompletion:(void(^)())completion;

@end
