//
//  SYDataAnalyzeManager.m
//  SYNews
//
//  Created by leju_esf on 2018/12/6.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYDataAnalyzeManager.h"
#import "NSDate+SYExtension.h"

@interface SYDataAnalyzeManager ()
@property (nonatomic, copy) NSString *globalPath;
@property (nonatomic, copy) NSString *sportsPath;
@property (nonatomic, copy) NSString *resultSportsPath;
@property (nonatomic, copy) NSString *resultGamesPath;
@property (nonatomic, copy) NSString *sportsIdConverPath;
@property (nonatomic, copy) NSString *gameConverPath;

@property (nonatomic, strong) NSMutableDictionary *resultSprots;
@property (nonatomic, strong) NSMutableDictionary *resultGames;

@property (nonatomic, strong) NSMutableDictionary *dateResults;
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
    
//    NSLog(@"开始计算---%f",CACurrentMediaTime());
    [[SYSportDataManager sharedSYSportDataManager] requestDatasBySYListType:SYListTypeCompare_all Completion:^(NSArray *datas) {
        if (datas.count > 0) {
            _global = [self calculatorWithDatas:datas];
            [[_global mj_keyValues] writeToFile:self.globalPath atomically:YES];
//            NSLog(@"全局完毕---%f",CACurrentMediaTime());
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
//            NSLog(@"分组完毕---%f",CACurrentMediaTime());
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"计算完毕" toView:nil];
            });
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
    
    NSMutableArray *homeKellyScore = [NSMutableArray array];
    NSMutableArray *awayKellyScore = [NSMutableArray array];
    NSMutableArray *drawKellyScore = [NSMutableArray array];
    NSMutableArray *allKellyScore = [NSMutableArray array];
    
    for (SYGameListModel *model in datas) {
        
//        NSArray *pay_array = [self gameDataStatisticsWithArray:@[@(model.BfAmountHome/model.totalPAmount),@(model.BfAmountDraw/model.totalPAmount),@(model.BfAmountAway/model.totalPAmount)]];
        NSArray *kelly_array = [self gameDataStatisticsWithArray:@[@(model.KellyHome),@(model.KellyDraw),@(model.KellyAway)]];
//        NSArray *gl_array = [self gameDataStatisticsWithArray:@[@(model.BfIndexHome/100),@(model.BfIndexDraw/100),@(model.BfIndexAway/100)]];
        
        SYGameScoreType type = SYGameScoreTypeHome;
        
        if ([model.homeScore integerValue] == [model.awayScore integerValue]) {
            type = SYGameScoreTypeDraw;
            
            [drawKellyScore addObject:@(model.KellyDraw)];
            [allKellyScore addObject:@(model.KellyDraw)];
        }else if ([model.homeScore integerValue] < [model.awayScore integerValue]) {
            type = SYGameScoreTypeAway;
            
            [awayKellyScore addObject:@(model.KellyAway)];
            [allKellyScore addObject:@(model.KellyAway)];
        }else {
            
            [homeKellyScore addObject:@(model.KellyHome)];
            [allKellyScore addObject:@(model.KellyHome)];
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
    sprotData.SortName = ((SYGameListModel *)datas.firstObject).SortName;
    sprotData.kellys = tempArray;
    sprotData.homeRedKellyScore = homeKellyScore;
    sprotData.awayRedKellyScore = awayKellyScore;
    sprotData.drawRedKellyScore = drawKellyScore;
    sprotData.allRedKellyScore = allKellyScore;
    
    return sprotData;
}

- (NSArray *)gameDataStatisticsWithArray:(NSArray *)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    SYNumberModel *home = [SYNumberModel modelWithStatus:SYGameScoreTypeHome num:[array.firstObject doubleValue]];
    SYNumberModel *draw = [SYNumberModel modelWithStatus:SYGameScoreTypeDraw num:[array[1] doubleValue]];
    SYNumberModel *away = [SYNumberModel modelWithStatus:SYGameScoreTypeAway num:[array.lastObject doubleValue]];
    [tempArray addObjectsFromArray:@[home,draw,away]];
    NSSortDescriptor *numSD = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:NO];
    return [[tempArray sortedArrayUsingDescriptors:@[numSD]] mutableCopy];
}

#pragma mark - 获取比分

// http://api.nowscore.com//info/GetSchedule?lang=0&date=2018-12-12&from=2
- (void)requestResultByDate:(NSDate *)date completion:(void (^)(id result))completion {
    if (date == nil) {
        date = [NSDate date];
    }
    
    
    NSString *dateStr = [date sy_stringWithFormat:@"yyyy-MM-dd"];
    
    if (![date sy_isToday] && ![date sy_isYesterday]) {
        NSDictionary *dateResult = [self.dateResults objectForKey:dateStr];
        if (dateResult) {
            [self handleData:dateResult completion:completion];
            return;
        }
    }

    NSString *url = @"http://api.nowscore.com//info/GetSchedule";
    NSDictionary *params = @{@"lang":@"0",@"from":@"2",@"date":dateStr};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/plain"]];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (![date sy_isToday] && ![date sy_isYesterday]) {
                [self.dateResults setObject:responseObject forKey:dateStr];
                BOOL status = [self.dateResults writeToFile:[NSString sy_locationDocumentsWithType:SYCachePathTypeDateResults] atomically:YES];
                NSLog(@"保存完毕--%d",status);
            }
            [self handleData:responseObject completion:completion];
        }else {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
}

- (void)handleData:(NSDictionary *)result completion:(void (^)(id result))completion {
    NSString *date = [result objectForKey:@"date"];
    NSArray *sports = [result objectForKey:@"sclasss"];
    NSArray *games = [result objectForKey:@"schedules"];
    if (date.length < 8) {
        completion(nil);
        return;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *sport in sports) {
        if ([[sport objectForKey:@"ifDisp"] integerValue] == 1||[[sport objectForKey:@"isWfc"] integerValue] == 1||[[sport objectForKey:@"isJc"] integerValue] == 1 ||[[sport objectForKey:@"isGoalC"] integerValue] == 1) {
            [tempArray addObject:[NSString stringWithFormat:@"%@",[sport objectForKey:@"sid"]]];
        }
        [self.resultSprots setObject:sport forKey:[NSString stringWithFormat:@"%@",[sport objectForKey:@"sid"]]];
    }
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    
    NSArray *gameModels = [SYGameResultModel mj_objectArrayWithKeyValuesArray:games];
    for (SYGameResultModel *model in gameModels) {
        
        if (![tempArray containsObject:model.sclassID]) {
            continue;
        }
        
        NSMutableArray *temp = [mutableDict objectForKey:model.sclassID];
        if (!temp) {
            temp = [NSMutableArray array];
            [mutableDict setObject:temp forKey:model.sclassID];
        }
        
        for (NSDictionary *sport in sports) {
            if ([model.sclassID integerValue] == [[sport objectForKey:@"sid"] integerValue]) {
                model.sortName = [sport objectForKey:@"name"];
                break;
            }
        }
        
        [temp addObject:model];
    }
    completion(mutableDict.allValues);
    
    [self.resultGames setObject:games forKey:[date substringToIndex:8]];
    
    BOOL sportstauts = [self.resultSprots writeToFile:self.resultSportsPath atomically:YES];
    BOOL gamestauts = [self.resultGames writeToFile:self.resultGamesPath atomically:YES];
    NSLog(@"%d---%d",sportstauts,gamestauts);
}

- (void)copyScoreFrom:(SYGameResultModel *)result toGame:(SYGameListModel *)game {
    game.homeScore = result.hScore;
    game.awayScore = result.gScore;
    game.score = [NSString stringWithFormat:@"%@:%@",result.hScore,result.gScore];
    [self.sportIdToResultSprorId setObject:result.sortName forKey:game.SortName];
    [self.gameIdToResultGameName setObject:result.hTeam forKey:[game.HomeTeam stringByAppendingString:game.HomeTeamId]];
    [self.gameIdToResultGameName setObject:result.gTeam forKey:[game.AwayTeam stringByAppendingString:game.AwayTeamId]];
    [self.sportIdToResultSprorId writeToFile:[self pathWithName:@"sportIdToResultSprorId"] atomically:YES];
    [self.gameIdToResultGameName writeToFile:[self pathWithName:@"gameIdToResultGameName"] atomically:YES];
}

- (NSString *)pathWithName:(NSString *)name {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];
}

#pragma mark - 懒加载
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

- (NSString *)resultSportsPath {
    if (_resultSportsPath == nil) {
        _resultSportsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:@"reslut_sports.plist"];
    }
    return _resultSportsPath;
}

- (NSString *)resultGamesPath {
    if (_resultGamesPath == nil) {
        _resultGamesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:@"reslut_games.plist"];
    }
    return _resultGamesPath;
}

//- (NSString *)resultGamesPath {
//    if (_resultGamesPath == nil) {
//        _resultGamesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:@"reslut_games.plist"];
//    }
//    return _resultGamesPath;
//}

- (NSMutableDictionary *)resultSprots {
    if (_resultSprots == nil) {
        _resultSprots = [[NSMutableDictionary alloc] initWithContentsOfFile:self.resultSportsPath];
        if (_resultSprots == nil) {
            _resultSprots = [NSMutableDictionary dictionary];
        }
    }
    return _resultSprots;
}

- (NSMutableDictionary *)resultGames {
    if (_resultGames == nil) {
        _resultGames = [[NSMutableDictionary alloc] initWithContentsOfFile:self.resultGamesPath];
        if (_resultGames == nil) {
            _resultGames = [NSMutableDictionary dictionary];
        }
    }
    return _resultGames;
}

- (NSMutableDictionary *)sportIdToResultSprorId {
    if (_sportIdToResultSprorId == nil) {
        _sportIdToResultSprorId = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathWithName:@"sportIdToResultSprorId"]];
        if (_sportIdToResultSprorId == nil) {
            _sportIdToResultSprorId = [NSMutableDictionary dictionary];
        }
    }
    return _sportIdToResultSprorId;
}

- (NSMutableDictionary *)gameIdToResultGameName {
    if (_gameIdToResultGameName == nil) {
        _gameIdToResultGameName = [[NSMutableDictionary alloc] initWithContentsOfFile:[self pathWithName:@"gameIdToResultGameName"]];
        if (_gameIdToResultGameName == nil) {
            _gameIdToResultGameName = [NSMutableDictionary dictionary];
        }
    }
    return _gameIdToResultGameName;
}

- (NSMutableDictionary *)dateResults {
    if (_dateResults == nil) {
        _dateResults = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString sy_locationDocumentsWithType:SYCachePathTypeDateResults]];
        if (_dateResults == nil) {
            _dateResults = [NSMutableDictionary dictionary];
        }
    }
    return _dateResults;
}
@end
