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
@property (nonatomic, strong) NSMutableDictionary *gameJsons;
@property (nonatomic, strong) NSMutableDictionary *currentGameJsons;
@property (nonatomic, strong) NSMutableDictionary *categaryCache;
@property (nonatomic, strong) NSMutableDictionary *collectionCache;

@end

@implementation SYSportDataManager
SYSingleton_implementation(SYSportDataManager)

/*
 http://api.spdex.com/spdex/match_data/sports?class=-1&jcfrom=1&sports=1,7522&app=z&version=i3.11
 */

- (void)reuqestAllSportsCompletion:(void (^)())completion {
    _currentGameJsons = nil;
    NSString *lastDate = [[NSUserDefaults standardUserDefaults] stringForKey:@"SYSportLastDate"];
    if ([lastDate isEqualToString:[[NSDate date] sy_stringWithFormat:@"yyyyMMdd"]]) {
        [self requestAllDatasCompletion:completion];
    }else {
        [self requestWithParams:nil byType:SYSportDataTypeHomeSport completion:^(id result) {
            if (result) {
                [[NSUserDefaults standardUserDefaults] setObject:[[NSDate date] sy_stringWithFormat:@"yyyyMMdd"] forKey:@"SYSportLastDate"];
                //保存
                [self sy_writeToFile:result forPath:[self dataPathWithFileName:sportsJsonPath]];
                self.sports = [SYSportModel mj_objectArrayWithKeyValuesArray:result];
                [self requestAllDatasCompletion:completion];
            }
        }];
    }
}

- (void)requestAllDatasCompletion:(void (^)())completion {
//    NSDictionary *dict = @{@"jcfrom":@(self.gameModels.count + 1),@"class":@"-1"};
//    [self requestWithParams:dict byType:SYSportDataTypeCatagorySport completion:^(id result) {
//        if (result) {
//            NSArray *array = (NSArray *)result;
//            if (array.count > 0) {
//                [self.gameModels addObjectsFromArray:result];
//                [self requestAllDatasCompletion:completion];
//            }else {
//                [self save];
//                _games = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.gameModels];
//                completion();
//            }
//        }
//    }];
   
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
            [self setdatas];
            completion();
        }
    });
}

- (void)setdatas {
    _categaryList = self.categaryCache.allValues;
    
    NSMutableArray *temp_payTopList = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.currentGameJsons.allValues];
    NSMutableArray *temp_nearList = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.currentGameJsons.allValues];
    
    NSSortDescriptor *paySD = [NSSortDescriptor sortDescriptorWithKey:@"totalPAmount" ascending:NO];//ascending:YES 代表升序 如果为NO 代表降序
    NSSortDescriptor *timeSD=[NSSortDescriptor sortDescriptorWithKey:@"dateSeconds" ascending:YES];
    
    _payTopList = [[temp_payTopList sortedArrayUsingDescriptors:@[paySD]] mutableCopy];
    _nearList = [[temp_nearList sortedArrayUsingDescriptors:@[timeSD]] mutableCopy];
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
    NSMutableDictionary *dict = [self.collectionCache objectForKey:[NSString stringWithFormat:@"%ld",(long)model.EventId]];
    if (dict) {
        dict[@"score"] = model.score?:@"";
        dict[@"homeScore"] = model.homeScore?:@"";
        dict[@"awayScore"] = model.awayScore?:@"";
    }
    [self.gameJsons setObject:model.mj_keyValues forKey:[NSString stringWithFormat:@"%ld",(long)model.EventId]];
    [self.collectionCache setObject:model.mj_keyValues forKey:[NSString stringWithFormat:@"%ld",(long)model.EventId]];
    
    for (SYGameListModel *item in _hotGameList) {
        if (item.EventId == model.EventId) {
            item.score = model.score;
            item.homeScore = model.homeScore;
            item.awayScore = model.awayScore;
            return;
        }
    }
    
    for (SYGameListModel *item in _nearList) {
        if (item.EventId == model.EventId) {
            item.score = model.score;
            item.homeScore = model.homeScore;
            item.awayScore = model.awayScore;
            return;
        }
    }
    
    for (SYGameListModel *item in _payTopList) {
        if (item.EventId == model.EventId) {
            item.score = model.score;
            item.homeScore = model.homeScore;
            item.awayScore = model.awayScore;
            return;
        }
    }
    
    [self sy_writeToFile:self.collectionCache forPath:[self dataPathWithFileName:hotGamesJsonPath]];
    [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
}

- (void)saveHotGame:(SYGameListModel *)model {
    
    [self.collectionCache setValue:model.mj_keyValues forKey:[NSString stringWithFormat:@"%ld",(long)model.EventId]];
    
    _hotGameList = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.collectionCache.allValues];
    
    [self sy_writeToFile:self.collectionCache forPath:[self dataPathWithFileName:hotGamesJsonPath]];
    [MBProgressHUD showSuccess:@"收藏成功" toView:nil];
    //    if (status) {
    //
    //    }else {
    //        [MBProgressHUD showError:@"保存失败" toView:nil];
    //    }
}

- (void)deleteHotGame:(SYGameListModel *)model {
    [self.collectionCache removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)model.EventId]];
    _hotGameList = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.collectionCache.allValues];
    [self sy_writeToFile:self.collectionCache forPath:[self dataPathWithFileName:hotGamesJsonPath]];
    [MBProgressHUD showSuccess:@"删除成功" toView:nil];
}

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

- (NSArray *)hotGameList {
    if (_hotGameList == nil) {
        if (self.collectionCache.count > 0) {
            _hotGameList = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.collectionCache.allValues];
        }else {
            _hotGameList = [[NSArray alloc] init];
        }
    }
    return _hotGameList;
}

- (NSMutableDictionary *)collectionCache {
    if (_collectionCache == nil) {
        _collectionCache = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataPathWithFileName:hotGamesJsonPath]];
        if (_collectionCache == nil) {
            _collectionCache = [NSMutableDictionary dictionary];
        }
    }
    return _collectionCache;
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

- (NSArray *)scoreGames {
    if (_scoreGames == nil) {
        _scoreGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];;
    }
    return _scoreGames;
}
@end
