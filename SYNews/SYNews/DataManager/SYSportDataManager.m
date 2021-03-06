//
//  SYSportDataManager.m
//  SYNews
//
//  Created by 唐绍禹 on 2018/9/22.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYSportDataManager.h"
#import "NSDate+SYExtension.h"

#define gamesJsonPath @"gamesJsonPath.plist"
#define sportsJsonPath @"sportsJsonPath.plist"
#define hotGamesJsonPath @"hotGamesJsonPath.plist"
#define scoreGamesJsonPath @"scoreGamesJsonPath.plist"
#define replaceNamePath @"replaceNamePath.plist"

@interface SYSportDataManager()

@property (nonatomic, strong) NSArray *sports;
@property (nonatomic, strong) NSMutableDictionary *gameJsons;
@property (nonatomic, strong) NSMutableDictionary *currentGameJsons;
@property (nonatomic, strong) NSMutableDictionary *categaryCache;
@property (nonatomic, strong) NSArray *allGames;

@end

@implementation SYSportDataManager
SYSingleton_implementation(SYSportDataManager)

/*
 http://api.spdex.com/spdex/match_data/sports?class=-1&jcfrom=1&sports=1,7522&app=z&version=i3.11
 */
//29021624#2018-12-01T13:00:00
//- (void)washData {
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"20181221.plist" ofType:nil]];
//    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
//    for (NSString *key in dict) {
//        NSString *month = [key substringWithRange:NSMakeRange(14, 2)];
//        NSString *date = [key substringWithRange:NSMakeRange(17, 2)];
//        if ([month isEqualToString:@"12"] && [date integerValue] > 20) {
//            [temp setObject:dict[key] forKey:key];
//        }
//    }
//    [temp writeToFile:[self dataPathWithFileName:@"test.plist"] atomically:YES];
//}

- (void)requestAllDatasCompletion:(void (^)(NSArray *))completion {
//    [self washData];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (SYSportModel *model in self.sports) {
        if ([model.SortName containsString:@"NBA"]) {
            continue;
        }
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            NSDictionary *dict = @{
                                   @"league":model.Id,
                                   @"class":@"-1"
                                   };
            [self requestWithParams:dict byType:SYSportDataTypeCatagorySport completion:^(id result) {
//                NSLog(@"结果--%@--%@",model.SortName,result);
                if (result) {
                    NSArray *array = (NSArray *)result;
                    if (array.count > 0) {
                        for (NSDictionary *gameJson in array) {
                            [self.currentGameJsons setValue:gameJson forKey:[NSString stringWithFormat:@"%@#%@",[gameJson objectForKey:@"EventId"],[gameJson objectForKey:@"MatchTime"]]];
                            [self.gameJsons setValue:gameJson forKey:[NSString stringWithFormat:@"%@#%@",[gameJson objectForKey:@"EventId"],[gameJson objectForKey:@"MatchTime"]]];
                        }
                        [self.categaryCache setValue:[SYGameListModel mj_objectArrayWithKeyValuesArray:array] forKey:model.Id.stringValue];
                    }
                }
                dispatch_group_leave(group);
            }];
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        
        if (completion) {
            [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
            _allGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
            
            /******************/
            
//            NSMutableDictionary *temp = [NSMutableDictionary dictionary];
//            for (SYGameListModel *model in _allGames) {
//                if (![temp objectForKey:model.SortName]) {
//                    [temp setObject:model.LeagueId forKey:model.SortName];
//                }else {
//                    NSString *leagueId = [temp objectForKey:model.SortName];
//                    if (![leagueId isEqualToString:model.LeagueId]) {
//                        NSLog(@"不一致--%@---%@---%@",model.LeagueId,model.SortName,leagueId);
//                    }
//                }
//            }
//            NSLog(@"%@",temp);
            
            /*****************/
            
            NSArray *tempArray = [_categaryCache allValues];
            for (NSArray *arr in tempArray) {
                [self bindProbabilityWithModels:arr sameSport:YES];
            }
            tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSArray *  _Nonnull obj1, NSArray *  _Nonnull obj2) {
                return obj1.count < obj2.count;
            }];
            completion(tempArray);
        }
        
        NSArray *currentGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.currentGameJsons.allValues];
        for (SYGameListModel *model in currentGames) {
            for (SYRecommendModel *recommend in self.recommends) {
                [recommend changeModelInformation:model];
            }
        }
    });
}

- (void)requestDatasBySYListType:(SYListType)type Completion:(void (^)(NSArray *))completion {
    
    if (completion) {
        if (type == SYListTypeCategory) {
            
            _currentGameJsons = nil;
            _categaryCache = nil;
            [self requestWithParams:nil byType:SYSportDataTypeHomeSport completion:^(id result) {
                if (result) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"SYSportLastDate"];
                    //保存
                    [self sy_writeToFile:result forPath:[self dataPathWithFileName:sportsJsonPath]];
                    self.sports = [SYSportModel mj_objectArrayWithKeyValuesArray:result];
                    [self requestAllDatasCompletion:completion];
                }
            }];
            
        }else if (type == SYListTypeNear) {
            
            if (_currentGameJsons == nil) {
                completion(nil);
            }else {
                NSArray *currentGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.currentGameJsons.allValues];
                NSMutableArray *temp_nearList = [NSMutableArray array];
                for (SYGameListModel *model in currentGames) {
                    if (model.dateSeconds + 7200 >= [[NSDate date] timeIntervalSince1970]) {
                        [temp_nearList addObject:model];
                    }
                }
                NSSortDescriptor *timeSD=[NSSortDescriptor sortDescriptorWithKey:@"dateSeconds" ascending:YES];
                NSArray *array = [[temp_nearList sortedArrayUsingDescriptors:@[timeSD]] mutableCopy];
                
                completion([self bindProbabilityWithModels:array sameSport:NO]);
            }
            
        }else if (type == SYListTypePayTop) {
            
            if (_currentGameJsons == nil) {
                completion(nil);
            }else {
                NSArray *currentGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.currentGameJsons.allValues];
                NSMutableArray *temp_payTopList = [NSMutableArray array];
                for (SYGameListModel *model in currentGames) {
                    if (model.dateSeconds + 7200 >= [[NSDate date] timeIntervalSince1970]) {
                        [temp_payTopList addObject:model];
                    }
                }
                NSSortDescriptor *paySD = [NSSortDescriptor sortDescriptorWithKey:@"totalPAmount" ascending:NO];
                NSArray *array = [[temp_payTopList sortedArrayUsingDescriptors:@[paySD]] mutableCopy];
                completion([self bindProbabilityWithModels:array sameSport:NO]);
            }
            
        }else if (type == SYListTypeHistory) {
            
            NSMutableArray *temp = [NSMutableArray array];
            for (SYGameListModel *model in self.allGames) {
                NSDate *date = [NSDate sy_dateWithString:[model.MatchTime stringByReplacingOccurrencesOfString:@"T" withString:@"-"] formate:@"yyyy-MM-dd-HH:mm:ss"];
                
                if ((-1)*[date timeIntervalSinceNow] > 7200) {
                    [temp addObject:model];
                }
            }
            NSSortDescriptor *timeSD=[NSSortDescriptor sortDescriptorWithKey:@"dateSeconds" ascending:NO];
            NSSortDescriptor *name=[NSSortDescriptor sortDescriptorWithKey:@"SortName" ascending:NO];
            NSArray *array = [[temp sortedArrayUsingDescriptors:@[timeSD,name]] mutableCopy];
            completion([self bindProbabilityWithModels:array sameSport:NO]);
            
        }else if (type == SYListTypeCompare) {
            
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
            for (SYGameListModel *model in self.allGames) {
                if (model.score.length > 0) {
                    NSMutableArray *temp = [mutableDict objectForKey:model.SortName];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        [mutableDict setObject:temp forKey:model.SortName];
                    }
                    [temp addObject:model];
                }
            }
            
            NSArray *temp = mutableDict.allValues;
            
            
//            for (NSString *name in mutableDict.allKeys) {
//                NSLog(@"%@",name);
//            }
            
            NSArray *array = [temp sortedArrayUsingComparator:^NSComparisonResult(NSArray *  _Nonnull obj1, NSArray *  _Nonnull obj2) {
                [self bindProbabilityWithModels:obj1 sameSport:YES];
                [self bindProbabilityWithModels:obj2 sameSport:YES];
                return obj1.count < obj2.count;
            }];
            
            completion(array);
            
        }else if (type == SYListTypeCompare_all) {
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (SYGameListModel *model in self.allGames) {
                if (model.score.length > 0) {
                    [tempArray addObject:model];
                }
            }
            completion([self bindProbabilityWithModels:tempArray sameSport:NO]);
            
        }else if (type == SYListTypeNoScore) {
            
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
            NSMutableArray *deleateArray = [NSMutableArray array];
            
            for (SYGameListModel *model in self.allGames) {
                if (model.score.length == 0 && model.dateSeconds + 7200 < [[NSDate date] timeIntervalSince1970]) {
                    NSMutableArray *temp = [mutableDict objectForKey:model.SortName];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        [mutableDict setObject:temp forKey:model.SortName];
                    }
                    if ((model.KellyHome == 0 && model.KellyDraw == 0 && model.KellyAway == 0)||model.totalPAmount < 1000) {
                        [deleateArray addObject:model];
                    }else {
                         [temp addObject:model];
                    }
                }
            }
            
            if (deleateArray.count > 0) {
                //删除无效数据
                for (SYGameListModel *model in deleateArray) {
                    [self.gameJsons removeObjectForKey:[NSString stringWithFormat:@"%ld#%@",(long)model.EventId,model.MatchTime]];
                }
                [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
                _allGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"今日清楚无效数据%zd",deleateArray.count] toView:nil];
            }
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:mutableDict.allValues];
            NSSortDescriptor *timeSD=[NSSortDescriptor sortDescriptorWithKey:@"dateSeconds" ascending:NO];

            NSMutableArray *noNullArray = [NSMutableArray array];
            for (int i = 0; i < temp.count; i++) {
                NSArray *games = temp[i];
                NSArray * newgames = [games sortedArrayUsingDescriptors:@[timeSD]];
//                [temp replaceObjectAtIndex:i withObject:newgames];
                if (games.count > 0) {
                    [noNullArray addObject:newgames];
                }
            }
            
            NSArray *array = [noNullArray sortedArrayUsingComparator:^NSComparisonResult(NSArray *  _Nonnull obj1, NSArray *  _Nonnull obj2) {
                return obj1.count < obj2.count;
            }];
            
            completion([NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:array]]);
            
        }else if (type == SYListTypeCompare_HighQuality) {
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
            for (SYGameListModel *model in self.allGames) {
                if (model.score.length > 0 && [self highQualityGame:model]) {
                    NSMutableArray *temp = [mutableDict objectForKey:model.SortName];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        [mutableDict setObject:temp forKey:model.SortName];
                    }
                    [temp addObject:model];
                }
            }
            
            NSMutableArray *gamesArray = [NSMutableArray array];
            for (NSArray *models in mutableDict.allValues) {
                if (models.count > 10) {
                    [gamesArray addObject:models];
                }
            }
            
            NSArray *array = [gamesArray sortedArrayUsingComparator:^NSComparisonResult(NSArray *  _Nonnull obj1, NSArray *  _Nonnull obj2) {
                return obj1.count < obj2.count;
            }];
            
            completion(array);
        }else if (type == SYListTypeCompare_HighQuality_all) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (SYGameListModel *model in self.allGames) {
                if (model.score.length > 0 && [self highQualityGame:model]) {
                    [tempArray addObject:model];
                }
            }
            completion(tempArray);
        }
    }
}

- (BOOL)highQualityGame:(SYGameListModel *)model {
    
    if (model.dateSeconds > model.updateSeconds + 1800) {
        return NO;
    }
    
    if (model.totalPAmount < 10000) {
        return NO;
    }
    
    return YES;
}

- (void)requestWithParams:(NSDictionary *)params byType:(SYSportDataType)type completion:(void (^)(id result))completion{
    
    NSMutableDictionary *baseparams = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"sports":@"1,7522",
                                                                                  @"app":@"z",
                                                                                  @"version":@"i3.11"
                                                                                  }];
    if (params.count > 0) {
        [baseparams addEntriesFromDictionary:params];
    }
    
    NSString *url = nil;
    switch (type) {
        case SYSportDataTypeHomeSport:
            url = [kBaseUrl stringByAppendingString:@"/spdex/leagues/sports"];
            break;
        case SYSportDataTypeCatagorySport:
            url = [kBaseUrl stringByAppendingString:@"/spdex/match_data/sports"];
            break;
        case SYSportDataTypeGameDetail:
            url = [kBaseUrl stringByAppendingString:@"/spdex/leagues/sports"];
            break;
        default:
            break;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/plain"]];
    [manager GET:url parameters:baseparams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"--%@",responseObject);
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"--%@",error);
        completion(nil);
    }];
}

- (void)washData {
    
    NSInteger count = 0;
    for (SYGameListModel *model in self.allGames) {
        if (model.KellyHome == 0 && model.KellyAway == 0 && model.KellyDraw == 0) {
            [self.gameJsons removeObjectForKey:[NSString stringWithFormat:@"%ld#%@",(long)model.EventId,model.MatchTime]];
            count++;
        }else if (model.totalPAmount < 1000) {
            [self.gameJsons removeObjectForKey:[NSString stringWithFormat:@"%ld#%@",(long)model.EventId,model.MatchTime]];
            count++;
        }
    }
    
    if (count > 0) {
        [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
        NSLog(@"清除%zd个无效数据",count);
    }
    
    
}

- (void)deleteModel:(SYGameListModel *)model {
    [self.gameJsons removeObjectForKey:[NSString stringWithFormat:@"%ld#%@",(long)model.EventId,model.MatchTime]];
    [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
    _allGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
}

- (void)changeScoreWithModels:(NSArray *)models {
    
    if (models.count == 0) {
        return;
    }
    
    for (SYGameListModel *model in models) {
        [self changeScoreModel:model];
    }
    
    [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
}

- (void)changeScoreModel:(SYGameListModel *)model {
    
    NSDictionary *json = [self.gameJsons objectForKey:[NSString stringWithFormat:@"%ld#%@",(long)model.EventId,model.MatchTime]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   if (json) {
       [dict addEntriesFromDictionary:json]; 
       [dict setValue:model.score?:@"" forKey:@"score"];
       [dict setValue:model.homeScore?:@"" forKey:@"homeScore"];
       [dict setValue:model.awayScore?:@"" forKey:@"awayScore"];
   }else {
       dict = model.mj_keyValues;
   }
    
    [self.gameJsons setObject:dict forKey:[NSString stringWithFormat:@"%ld#%@",(long)model.EventId,model.MatchTime]];
    
    for (SYGameListModel *item in _allGames) {
        if (item.EventId == model.EventId) {
            item.score = model.score;
            item.homeScore = model.homeScore;
            item.awayScore = model.awayScore;
        }
    }
    
    for (SYRecommendModel *recommend in self.recommends) {
        [recommend changeModelInformation:model];
    }
}

- (void)replaceDataForNewest {
    
    NSString *todayString = [[NSDate date] sy_stringWithFormat:@"yyyyMMdd"];
    NSString *path = [[NSBundle mainBundle] pathForResource:todayString ofType:@"plist"];
    if (path == nil) {
        return;
    }

    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"replaceDataForNewest"];
    if (date != nil && [date sy_isToday]) {
        return;
    }
    
    if (path.length > 0) {
        NSDictionary *json = [NSDictionary dictionaryWithContentsOfFile:path];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSString *key in json.allKeys) {
                NSDictionary *newDict = [json objectForKey:key];
                NSDictionary *oldDict = [self.gameJsons objectForKey:key];
                if (oldDict) {
                    SYGameListModel *newModel = [SYGameListModel mj_objectWithKeyValues:newDict];
                    SYGameListModel *oldModel = [SYGameListModel mj_objectWithKeyValues:oldDict];
                    
                    if (![newModel.MaxUpdateTime isEqualToString:oldModel.MaxUpdateTime] && newModel.updateSeconds > oldModel.updateSeconds) {
                        
                        newModel.score = oldModel.score;
                        newModel.homeScore = oldModel.homeScore;
                        newModel.awayScore = oldModel.awayScore;
                        newModel.recommendType = oldModel.recommendType;
                        
                        [self.gameJsons setObject:[newModel mj_keyValues] forKey:key];
                        
                        for (SYRecommendModel *recommend in self.recommends) {
                            [recommend changeModelInformation:newModel];
                        }
                        
                    }
                }else {
                    [self.gameJsons setObject:newDict forKey:key];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"replaceDataForNewest"];
                [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
                _allGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
                [MBProgressHUD showSuccess:@"今日更新执行完毕" toView:nil];
            });
        });
        
    }
}

- (void)refreshGameData {
    NSArray *array = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.currentGameJsons.allValues];
    BOOL needRefresh = NO;
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"SYSportLastDate"];
    if (date && [date isKindOfClass:[NSDate class]]) {
         needRefresh = [[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970] > 7200;
    }
   
    if (array.count > 0 && needRefresh == NO) {
        NSInteger i = 0;
        do {
            SYGameListModel *model = array[i];
            needRefresh = fabs(model.dateSeconds - [[NSDate date] timeIntervalSince1970]) <= 2000;
            i++;
        } while ((!needRefresh)&&(i<array.count));
    }

    if (needRefresh) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataNeedRefresh" object:nil];
        NSLog(@"F刷新一次 %@",[[NSDate date] sy_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]);
    }
}

- (BOOL)sy_writeToFile:(id)datas forPath:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    return [datas writeToFile:path atomically:YES];
}

- (NSString *)dataPathWithFileName:(NSString *)fileName {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:fileName];
}

- (NSArray *)sports {
    if (_sports == nil) {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self dataPathWithFileName:sportsJsonPath]];
        if (array.count > 0) {
            _sports = [SYSportModel mj_objectArrayWithKeyValuesArray:array];
        }else {
            _sports = [NSArray array];
        }
    }
    return _sports;
}

- (NSMutableDictionary *)categaryCache {
    if (_categaryCache == nil) {
        _categaryCache = [[NSMutableDictionary alloc] init];
    }
    return _categaryCache;
}

- (NSMutableDictionary *)gameJsons {
    if (_gameJsons == nil) {
        _gameJsons = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataPathWithFileName:gamesJsonPath]];
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        for (NSDictionary *dict in _gameJsons.allValues) {
            [temp setObject:dict forKey:[NSString stringWithFormat:@"%@#%@",[dict objectForKey:@"EventId"],[dict objectForKey:@"MatchTime"]]];
        }
        _gameJsons = temp;
        if (_gameJsons == nil) {
            _gameJsons = [[NSMutableDictionary alloc] init];
        }
    }
    return _gameJsons;
}

- (NSMutableDictionary *)currentGameJsons {
    if (_currentGameJsons == nil) {
        _currentGameJsons = [[NSMutableDictionary alloc] init];
    }
    return _currentGameJsons;
}

- (NSArray *)allGames {
    if (_allGames == nil) {
        _allGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
    }
    return _allGames;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1000 target:self selector:@selector(refreshGameData) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)creatNewRecommend:(NSString *)name {
    for (SYRecommendModel *model in self.recommends) {
        if ([model.name isEqualToString:name]) {
            return;
        }
    }
    SYRecommendModel *model = [SYRecommendModel new];
    model.name = name;
    if (self.recommends.count > 0) {
        SYRecommendModel *last = self.recommends.lastObject;
        model.tag = last.tag + 1;
    }else {
        model.tag = 1;
    }
    [self.recommends addObject:model];
    [self saveRecommends];
}

- (void)deleteRecommendAtIndex:(NSInteger)index {
    if (self.recommends.count > index) {
        [self.recommends removeObjectAtIndex:index];
        [self saveRecommends];
    }
}

- (void)saveRecommends {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (SYRecommendModel *model in self.recommends) {
        [tempArray addObject:@{@"name":model.name,@"tag":@(model.tag)}];
    }
    [tempArray writeToFile:[self recommendModelsPath] atomically:YES];
}

- (NSMutableArray *)recommends {
    if (_recommends == nil) {
//        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Recommend.plist" ofType:nil]];
        //        [tempArray addObjectsFromArray:array];
        //        [tempArray writeToFile:[self recommendModelsPath] atomically:YES];
        NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:[self recommendModelsPath]];
        if (tempArray == nil) {
            tempArray = [NSMutableArray array];
        }
        _recommends = [SYRecommendModel mj_objectArrayWithKeyValuesArray:tempArray];
        
        NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SYRecommend"];
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsPath];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        for (NSString *fileName in enumerator) {
            BOOL exit = NO;
            for (SYRecommendModel *recommend in _recommends) {
                if ([fileName containsString:[NSString stringWithFormat:@"SYRecommend_%zd.plist",recommend.tag]]) {
                    exit = YES;
                    break;
                }
            }
            if (exit == NO) {
                [[NSFileManager defaultManager] removeItemAtPath:[documentsPath stringByAppendingPathComponent:fileName] error:nil];
                NSLog(@"不包含----%@",fileName);
            }
        }
        
    }
    return _recommends;
}

- (NSString *)recommendModelsPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SYRecommendModelsPath.plist"];
}

- (void)replaceNameForTeamId:(NSInteger)teamId byName:(NSString *)name {
    NSString *key = [NSString stringWithFormat:@"%zd",teamId];
    if (name.length == 0 || [name isEqualToString:@" "]) {
        [self.replaceNames removeObjectForKey:key];
    }else {
        [self.replaceNames setValue:name forKey:key];
    }
    [self.replaceNames writeToFile:[self dataPathWithFileName:replaceNamePath] atomically:YES];
}

- (NSMutableDictionary *)replaceNames {
    if (_replaceNames == nil) {
        _replaceNames = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataPathWithFileName:replaceNamePath]];
        if (_replaceNames == nil) {
            _replaceNames = [NSMutableDictionary dictionary];
        }
    }
    return _replaceNames;
}


#pragma mark - 绑定概率
- (NSArray *)bindProbabilityWithModels:(NSArray *)models sameSport:(BOOL)same{
    
    if ([SYDataAnalyzeManager sharedSYDataAnalyzeManager].sports.count == 0) {
        return models;
    }
    
    if (same) {
        
        SYSportDataProbability *probability = nil;
        for (SYSportDataProbability *pro in [SYDataAnalyzeManager sharedSYDataAnalyzeManager].sports) {
            if ([pro.SortName isEqualToString:((SYGameListModel *)models.firstObject).SortName]) {
                probability = pro;
                break;
            }
        }
        
        if (probability == nil) {
            return models;
        }
        
        for (SYGameListModel *model in models) {
            
            SYHDAType type = [self HDATypeWithModel:model];
            for (SYDataProbability *pro in probability.kellys) {
                if (pro.type == type) {
                    model.probability = pro;
                    break;
                }
            }
            for (SYDataProbability *pro in [SYDataAnalyzeManager sharedSYDataAnalyzeManager].global.kellys) {
                if (pro.type == type) {
                    model.global = pro;
                    break;
                }
            }
        }

        return models;
    }else {
    
        for (SYGameListModel *model in models) {
            
            SYSportDataProbability *probability = nil;
            
            for (SYSportDataProbability *pro in [SYDataAnalyzeManager sharedSYDataAnalyzeManager].sports) {
                if ([pro.SortName isEqualToString:model.SortName]) {
                    probability = pro;
                    break;
                }
            }
            
            if (probability == nil) {
                continue;
            }
            
            SYHDAType type = [self HDATypeWithModel:model];
            for (SYDataProbability *pro in probability.kellys) { 
                if (pro.type == type) {
                    model.probability = pro;
                    break;
                }
            }
            for (SYDataProbability *pro in [SYDataAnalyzeManager sharedSYDataAnalyzeManager].global.kellys) {
                if (pro.type == type) {
                    model.global = pro;
                    break;
                }
            }
        }
        
        return models;
    }
    
}

- (SYHDAType)HDATypeWithModel:(SYGameListModel *)model {
    NSArray *kelly_array = [self gameDataStatisticsWithArray:@[@(model.KellyHome),@(model.KellyDraw),@(model.KellyAway)]];
    if (((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeHome &&
        ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeDraw &&
        ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeAway) {
        return SYHDAType_HDA;
    }else if (((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeHome &&
              ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeDraw &&
              ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeAway){
        return SYHDAType_HAD;
    }else if (((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeHome &&
              ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeDraw &&
              ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeAway){
        return SYHDAType_AHD;
    }else if (((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeHome &&
              ((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeDraw &&
              ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeAway){
        return SYHDAType_ADH;
    }else if (((SYNumberModel *)kelly_array[1]).status == SYGameScoreTypeHome &&
              ((SYNumberModel *)kelly_array[0]).status == SYGameScoreTypeDraw &&
              ((SYNumberModel *)kelly_array[2]).status == SYGameScoreTypeAway){
        return SYHDAType_DHA;
    }else{
        return SYHDAType_DAH;
    }
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

- (void)writeDataToDocuments {
    NSArray *dictArray = @[@"gameIdToResultGameName",@"gamesJsonPath",@"globalProbability",@"hotGamesJsonPath",@"nbaGamesJsonPath",@"replaceNamePath",@"reslut_games",@"reslut_sports",@"sportIdToResultSprorId",@"SYCachePathType_0_data",@"SYCachePathType_1_data",@"SYCachePathType_2_data",@"SYCachePathType_3_data",@""];
    NSArray *arrArray = @[@"sportsJsonPath",@"sportsProbability",@"SYCachePathType_4_data",@"SYRecommendModelsPath"];
    
    for (NSString *path in dictArray) {
        NSString *pathUrl = [[NSBundle mainBundle] pathForResource:path ofType:@"plist"];
        if (pathUrl.length > 0) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathUrl];
            NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            BOOL status = [dict writeToFile:[NSString stringWithFormat:@"%@/%@.plist",documentsPath,path] atomically:YES];
            NSLog(@"dictArray-%@",status ? @"成功":@"失败");
        }
    }
    
    for (NSString *path in arrArray) {
        NSString *pathUrl = [[NSBundle mainBundle] pathForResource:path ofType:@"plist"];
        if (pathUrl.length > 0) {
            NSArray *arr = [NSArray arrayWithContentsOfFile:pathUrl];
            NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            BOOL status = [arr writeToFile:[NSString stringWithFormat:@"%@/%@.plist",documentsPath,path] atomically:YES];
            NSLog(@"arrArray-%@",status ? @"成功":@"失败");
        }
    }
    
    [self recommends];
    
    for (int i = 1; i < 8; i++) {
        NSString *pathUrl = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"SYRecommend_%d",i] ofType:@"plist"];
        if (pathUrl.length > 0) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathUrl];
            NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            BOOL status = [dict writeToFile:[NSString stringWithFormat:@"%@/SYRecommend/SYRecommend_%d.plist",documentsPath,i] atomically:YES];
            NSLog(@"SYRecommend-%@",status ? @"成功":@"失败");
        }
    }
    
}
@end
