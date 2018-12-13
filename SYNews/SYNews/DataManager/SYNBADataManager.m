//
//  SYNBADataManager.m
//  SYNews
//
//  Created by leju_esf on 2018/12/13.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYNBADataManager.h"
#import "NSDate+SYExtension.h"

#define gamesJsonPath @"nbaGamesJsonPath.plist"

@interface SYNBADataManager ()
@property (nonatomic, strong) NSMutableDictionary *gameJsons;
@property (nonatomic, strong) NSMutableDictionary *currentGameJsons;
@property (nonatomic, strong) NSArray *allGames;
@end

@implementation SYNBADataManager
SYSingleton_implementation(SYNBADataManager)

- (void)requestDatasByType:(SYNBAListType)type Completion:(void(^)(NSArray *datas))completion {
    if (type == SYNBAListTypeToday) {
        [self requestDataCompletion:completion];
    }
}

- (void)requestDataCompletion:(void(^)(NSArray *datas))completion{
    NSDictionary *dict = @{
                           @"league":@"230",
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
                [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
                _allGames = [SYGameListModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
                completion([SYGameListModel mj_objectArrayWithKeyValuesArray:array]);
            }else {
                completion(nil);
            }
        }else {
            completion(nil);
        }
        
    }];
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
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil);
    }];
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

- (NSMutableDictionary *)gameJsons {
    if (_gameJsons == nil) {
        _gameJsons = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataPathWithFileName:gamesJsonPath]];
        if (_gameJsons == nil) {
            _gameJsons = [[NSMutableDictionary alloc] init];
        }
    }
    return _gameJsons;
}

@end
