//
//  SYSportDataManager.m
//  SYNews
//
//  Created by 唐绍禹 on 2018/9/22.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYSportDataManager.h"
#import "NSDate+SYExtension.h"

#define kBaseUrl @"http://api.spdex.com"

#define gamesJsonPath @"gamesJsonPath.plist"
#define sportsJsonPath @"sportsJsonPath.plist"
#define hotGamesJsonPath @"hotGamesJsonPath.plist"
#define scoreGamesJsonPath @"scoreGamesJsonPath.plist"

@interface SYSportDataManager()

@property (nonatomic, strong) NSArray *sports;

//@property (nonatomic, strong) NSArray *payTopList;
//@property (nonatomic, strong) NSArray *nearList;
//@property (nonatomic, strong) NSArray *categaryList;
//@property (nonatomic, strong) NSArray *hotGameList;

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

//- (void)reuqestAllSportsCompletion:(void (^)())completion {
//    _currentGameJsons = nil;
////    NSString *lastDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"SYSportLastDate"];
////    if ([lastDate isEqualToString:[[NSDate date] sy_stringWithFormat:@"yyyyMMdd"]]) {
////        [self requestAllDatasCompletion:completion];
////    }else {
////        [self requestWithParams:nil byType:SYSportDataTypeHomeSport completion:^(id result) {
////            if (result) {
////                [[NSUserDefaults standardUserDefaults] setObject:[[NSDate date] sy_stringWithFormat:@"yyyyMMdd"] forKey:@"SYSportLastDate"];
////                //保存
////                [self sy_writeToFile:result forPath:[self dataPathWithFileName:sportsJsonPath]];
////                self.sports = [SYSportModel mj_objectArrayWithKeyValuesArray:result];
////                [self requestAllDatasCompletion:completion];
////            }
////        }];
////    }
//
//}

- (void)requestAllDatasCompletion:(void (^)(NSArray *))completion {
   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (SYSportModel *model in self.sports) {
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
                            [self.currentGameJsons setValue:gameJson forKey:[NSString stringWithFormat:@"%@",[gameJson objectForKey:@"EventId"]]];
                            [self.gameJsons setValue:gameJson forKey:[NSString stringWithFormat:@"%@",[gameJson objectForKey:@"EventId"]]];
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
            completion([_categaryCache allValues]);
        }
    });
}

- (void)requestDatasBySYListType:(SYListType)type Completion:(void (^)(NSArray *))completion {
    
    if (completion) {
        if (type == SYListTypeCategory) {
            
            _currentGameJsons = nil;
            [self requestWithParams:nil byType:SYSportDataTypeHomeSport completion:^(id result) {
                if (result) {
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSDate date] sy_stringWithFormat:@"yyyyMMdd"] forKey:@"SYSportLastDate"];
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
                
                completion(array);
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
                completion(array);
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
            completion(array);
            
        }else if (type == SYListTypeCompare) {
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
            for (SYGameListModel *model in self.allGames) {
                if (model.score.length > 0) {
                    NSMutableArray *temp = [mutableDict objectForKey:[NSString stringWithFormat:@"%zd",model.LeagueId]];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        [mutableDict setObject:temp forKey:[NSString stringWithFormat:@"%zd",model.LeagueId]];
                    }
                    [temp addObject:model];
                }
            }
            completion(mutableDict.allValues);
        }
    }
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

- (void)changeScoreModel:(SYGameListModel *)model {
    
    NSDictionary *json = [self.gameJsons objectForKey:[NSString stringWithFormat:@"%ld",(long)model.EventId]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   if (json) {
       [dict addEntriesFromDictionary:json]; 
       [dict setValue:model.score?:@"" forKey:@"score"];
       [dict setValue:model.homeScore?:@"" forKey:@"homeScore"];
       [dict setValue:model.awayScore?:@"" forKey:@"awayScore"];
   }else {
       dict = model.mj_keyValues;
   }
    
    [self.gameJsons setObject:dict forKey:[NSString stringWithFormat:@"%ld",(long)model.EventId]];
    
    for (SYGameListModel *item in _allGames) {
        if (item.EventId == model.EventId) {
            item.score = model.score;
            item.homeScore = model.homeScore;
            item.awayScore = model.awayScore;
        }
    }
    
//    [self sy_writeToFile:self.collectionCache forPath:[self dataPathWithFileName:hotGamesJsonPath]];
    [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
}

- (void)refreshGameData {
    NSArray *array = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.currentGameJsons.allValues];
    BOOL needRefresh = NO;
    
    if (array.count > 0) {
        NSInteger i = 0;
        do {
            SYGameListModel *model = array[i];
            needRefresh = fabs(model.dateSeconds - [[NSDate date] timeIntervalSince1970]) <= 600;
            i++;
        } while ((!needRefresh)&&(i<array.count));
    }
    
    
    if (needRefresh) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataNeedRefresh" object:nil];
    }
}

//- (void)saveHotGame:(SYGameListModel *)model {
//
//    [self.collectionCache setValue:model.mj_keyValues forKey:[NSString stringWithFormat:@"%ld",(long)model.EventId]];
//
//    _hotGameList = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.collectionCache.allValues];
//
//    [self sy_writeToFile:self.collectionCache forPath:[self dataPathWithFileName:hotGamesJsonPath]];
//    [MBProgressHUD showSuccess:@"收藏成功" toView:nil];
//    //    if (status) {
//    //
//    //    }else {
//    //        [MBProgressHUD showError:@"保存失败" toView:nil];
//    //    }
//}

//- (void)deleteHotGame:(SYGameListModel *)model {
//    [self.collectionCache removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)model.EventId]];
//    _hotGameList = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.collectionCache.allValues];
//    [self sy_writeToFile:self.collectionCache forPath:[self dataPathWithFileName:hotGamesJsonPath]];
//    [MBProgressHUD showSuccess:@"删除成功" toView:nil];
//}

//- (NSArray *)getAllScoreGamesByCategory:(BOOL)category {
//
//    NSMutableArray *temp = [NSMutableArray array];
//    for (SYGameListModel *model in self.allGames) {
//        if (model.score.length > 0) {
//            [temp addObject:model];
//        }
//    }
//    if (category) {
//        NSSortDescriptor *timeSD=[NSSortDescriptor sortDescriptorWithKey:@"SortName" ascending:NO];
//        return [[temp sortedArrayUsingDescriptors:@[timeSD]] mutableCopy];
//    }else {
//        NSSortDescriptor *timeSD=[NSSortDescriptor sortDescriptorWithKey:@"totalPAmount" ascending:NO];
//        return [[temp sortedArrayUsingDescriptors:@[timeSD]] mutableCopy];
//    }
//}

- (void)sy_writeToFile:(id)datas forPath:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    [datas writeToFile:path atomically:YES];
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
//
//- (NSArray *)hotGameList {
//    if (_hotGameList == nil) {
//        if (self.collectionCache.count > 0) {
//            _hotGameList = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.collectionCache.allValues];
//        }else {
//            _hotGameList = [[NSArray alloc] init];
//        }
//    }
//    return _hotGameList;
//}
//
//- (NSMutableDictionary *)collectionCache {
//    if (_collectionCache == nil) {
//        _collectionCache = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataPathWithFileName:hotGamesJsonPath]];
//        if (_collectionCache == nil) {
//            _collectionCache = [NSMutableDictionary dictionary];
//        }
//    }
//    return _collectionCache;
//}

- (NSMutableDictionary *)categaryCache {
    if (_categaryCache == nil) {
        _categaryCache = [[NSMutableDictionary alloc] init];
    }
    return _categaryCache;
}

- (NSMutableDictionary *)gameJsons {
    if (_gameJsons == nil) {
        _gameJsons = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataPathWithFileName:gamesJsonPath]];
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
        _allGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];;
    }
    return _allGames;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:600 target:self selector:@selector(refreshGameData) userInfo:nil repeats:YES];
    }
    return _timer;
}
@end
