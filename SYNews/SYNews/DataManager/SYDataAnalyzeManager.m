//
//  SYDataAnalyzeManager.m
//  SYNews
//
//  Created by leju_esf on 2018/12/6.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYDataAnalyzeManager.h"

@interface SYDataAnalyzeManager ()
@property (nonatomic, copy) NSString *globalPath;
@property (nonatomic, copy) NSString *sportsPath;
@end

@implementation SYDataAnalyzeManager
SYSingleton_implementation(SYDataAnalyzeManager)
- (instancetype)init {
    if (self = [super init]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:self.globalPath];
        if (dict) {
            _global = [SYSportDataProbability mj_objectWithKeyValues:dict];
        }
        NSArray *array = [NSArray arrayWithContentsOfFile:self.sportsPath];
        if (array) {
            _sports = [SYSportDataProbability mj_objectArrayWithKeyValuesArray:array];
        }
    }
    return self;
}

- (void)calculatorDatas {
    
    NSLog(@"开始计算---%f",CACurrentMediaTime());
    [[SYSportDataManager sharedSYSportDataManager] requestDatasBySYListType:SYListTypeCompare_all Completion:^(NSArray *datas) {
        if (datas.count > 0) {
            _global = [self calculatorWithDatas:datas];
            [[_global mj_keyValues] writeToFile:self.globalPath atomically:YES];
            NSLog(@"全局完毕---%f",CACurrentMediaTime());
        }
    }];
    
    [[SYSportDataManager sharedSYSportDataManager] requestDatasBySYListType:SYListTypeCompare Completion:^(NSArray *datas) {
        if (datas.count > 0) {
            NSMutableArray *tempArray = [NSMutableArray array];
            NSMutableArray *tempDictArray = [NSMutableArray array];
            for (NSArray *temp in datas) {
                SYSportDataProbability *model = [self calculatorWithDatas:temp];
                [tempArray addObject:model];
                [tempDictArray addObject:[model mj_keyValues]];
            }
            _sports = tempArray;
            
            [tempDictArray writeToFile:self.sportsPath atomically:YES];
            NSLog(@"分组完毕---%f",CACurrentMediaTime());
        }
    }];
}

- (SYSportDataProbability *)calculatorWithDatas:(NSArray *)datas {
    
    NSInteger HDA = 0,HAD = 0,AHD = 0,ADH = 0,DHA = 0,DAH = 0;
    NSInteger HDA_H = 0,HDA_D = 0,HDA_A = 0;
    NSInteger HAD_H = 0,HAD_D = 0,HAD_A = 0;
    NSInteger AHD_H = 0,AHD_D = 0,AHD_A = 0;
    NSInteger ADH_H = 0,ADH_D = 0,ADH_A = 0;
    NSInteger DHA_H = 0,DHA_D = 0,DHA_A = 0;
    NSInteger DAH_H = 0,DAH_D = 0,DAH_A = 0;
    
    for (SYGameListModel *model in datas) {
        
//        NSArray *pay_array = [self gameDataStatisticsWithArray:@[@(model.BfAmountHome/model.totalPAmount),@(model.BfAmountDraw/model.totalPAmount),@(model.BfAmountAway/model.totalPAmount)]];
        NSArray *kelly_array = [self gameDataStatisticsWithArray:@[@(model.KellyHome),@(model.KellyDraw),@(model.KellyAway)]];
//        NSArray *gl_array = [self gameDataStatisticsWithArray:@[@(model.BfIndexHome/100),@(model.BfIndexDraw/100),@(model.BfIndexAway/100)]];
        
        SYGameScoreType type = SYGameScoreTypeHome;
        
        if ([model.homeScore integerValue] == [model.awayScore integerValue]) {
            type = SYGameScoreTypeDraw;
        }else if ([model.homeScore integerValue] < [model.awayScore integerValue]) {
            type = SYGameScoreTypeAway;
        }
        
        if (((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeHome &&
            ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeDraw &&
            ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeAway) {
            HDA++;
            if (type == SYGameScoreTypeHome) {HDA_H++;}
            if (type == SYGameScoreTypeDraw) {HDA_D++;}
            if (type == SYGameScoreTypeAway) {HDA_A++;}
        }else if (((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeAway){
            HAD++;
            if (type == SYGameScoreTypeHome) {HAD_H++;}
            if (type == SYGameScoreTypeDraw) {HAD_D++;}
            if (type == SYGameScoreTypeAway) {HAD_A++;}
        }else if (((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeAway){
            AHD++;
            if (type == SYGameScoreTypeHome) {AHD_H++;}
            if (type == SYGameScoreTypeDraw) {AHD_D++;}
            if (type == SYGameScoreTypeAway) {AHD_A++;}
        }else if (((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeAway){
            ADH++;
            if (type == SYGameScoreTypeHome) {ADH_H++;}
            if (type == SYGameScoreTypeDraw) {ADH_D++;}
            if (type == SYGameScoreTypeAway) {ADH_A++;}
        }else if (((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeAway){
            DHA++;
            if (type == SYGameScoreTypeHome) {DHA_H++;}
            if (type == SYGameScoreTypeDraw) {DHA_D++;}
            if (type == SYGameScoreTypeAway) {DHA_A++;}
        }else if (((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeHome &&
                  ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeDraw &&
                  ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeAway){
            DAH++;
            if (type == SYGameScoreTypeHome) {DAH_H++;}
            if (type == SYGameScoreTypeDraw) {DAH_D++;}
            if (type == SYGameScoreTypeAway) {DAH_A++;}
        }
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:[SYDataProbability modelWithType:SYHDAType_HDA home:HDA_H draw:HDA_D away:HDA_A total:HDA]];
    [tempArray addObject:[SYDataProbability modelWithType:SYHDAType_HAD home:HAD_H draw:HAD_D away:HAD_A total:HAD]];
    [tempArray addObject:[SYDataProbability modelWithType:SYHDAType_AHD home:AHD_H draw:AHD_D away:AHD_A total:AHD]];
    [tempArray addObject:[SYDataProbability modelWithType:SYHDAType_ADH home:ADH_H draw:ADH_D away:ADH_A total:ADH]];
    [tempArray addObject:[SYDataProbability modelWithType:SYHDAType_DHA home:DHA_H draw:DHA_D away:DHA_A total:DHA]];
    [tempArray addObject:[SYDataProbability modelWithType:SYHDAType_DAH home:DAH_H draw:DAH_D away:DAH_A total:DAH]];
    SYSportDataProbability *sprotData = [SYSportDataProbability new];
    sprotData.sportId = ((SYGameListModel *)datas.firstObject).LeagueId;
    sprotData.kellys = tempArray;
    return sprotData;
}

//- (SYHDAType)typeWithKellArray:(NSArray *)kelly_array {
//    if (((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeHome &&
//        ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeDraw &&
//        ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeAway) {
//        return SYHDAType_HDA;
//    }else if (<#expression#>)
//}

- (NSArray *)gameDataStatisticsWithArray:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    SYNumberModel *home = [SYNumberModel modelWithStatus:SYGameScoreTypeHome num:[array.firstObject doubleValue]];
    SYNumberModel *draw = [SYNumberModel modelWithStatus:SYGameScoreTypeDraw num:[array[1] doubleValue]];
    SYNumberModel *away = [SYNumberModel modelWithStatus:SYGameScoreTypeAway num:[array.lastObject doubleValue]];
    [tempArray addObjectsFromArray:@[home,draw,away]];
    NSSortDescriptor *numSD = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:NO];
    return [[tempArray sortedArrayUsingDescriptors:@[numSD]] mutableCopy];
}

- (NSString *)globalPath {
    if (_globalPath == nil) {
        _globalPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:@"globalProbability.plist"];
    }
    return _globalPath;
}

- (NSString *)sportsPath {
    if (_sportsPath == nil) {
        _sportsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:@"sportsProbability.plist"];
    }
    return _sportsPath;
}

@end
