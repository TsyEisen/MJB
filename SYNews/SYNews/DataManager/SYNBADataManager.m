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
@property (nonatomic, strong) NSMutableDictionary *dateResults;

@end

@implementation SYNBADataManager
SYSingleton_implementation(SYNBADataManager)

- (void)requestDatasByType:(SYNBAListType)type Completion:(void(^)(NSArray *datas))completion {
    if (type == SYNBAListTypeToday) {
        [self requestDataCompletion:completion];
    }else if (type == SYNBAListTypeHistory){
        NSArray *games = [SYBasketBallModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (SYBasketBallModel *model in games) {
            if ([[NSDate date] timeIntervalSince1970] - model.dateSeconds > 7200) {
                [tempArray addObject:model];
            }
        }
        
        NSSortDescriptor *timeSD=[NSSortDescriptor sortDescriptorWithKey:@"dateSeconds" ascending:NO];
        NSArray * newgames = [tempArray sortedArrayUsingDescriptors:@[timeSD]];
        completion(newgames);
    }else if (type == SYNBAListTypeNoScore) {
        NSArray *games = [SYBasketBallModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (SYBasketBallModel *model in games) {
            if ([[NSDate date] timeIntervalSince1970] - model.dateSeconds > 7200 && model.homeScore.length == 0) {
                [tempArray addObject:model];
            }
        }
        
        NSSortDescriptor *timeSD=[NSSortDescriptor sortDescriptorWithKey:@"dateSeconds" ascending:NO];
        NSArray * newgames = [tempArray sortedArrayUsingDescriptors:@[timeSD]];
        completion(newgames);
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
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"SYBasketSportLastDate"];
            NSArray *array = (NSArray *)result;
            if (array.count > 0) {
                for (NSDictionary *gameJson in array) {
                    [self.currentGameJsons setValue:gameJson forKey:[NSString stringWithFormat:@"%@",[gameJson objectForKey:@"EventId"]]];
                    [self.gameJsons setValue:gameJson forKey:[NSString stringWithFormat:@"%@",[gameJson objectForKey:@"EventId"]]];
                }
                [self save];
                _allGames = [SYBasketBallModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
                completion([SYBasketBallModel mj_objectArrayWithKeyValuesArray:array]);
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

- (void)requestHistoryWithModel:(SYBasketBallModel *)model completion:(void (^)(id result))completion {
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:model];
    for (SYBasketBallModel *item in self.allGames) {
        if ([item.EventId isEqualToString:model.EventId]) {
            continue;
        }
        if (item.homeScore.length == 0) {
            continue;
        }
        if ([item.HomeTeam isEqualToString:model.HomeTeam] || [item.AwayTeam isEqualToString:model.AwayTeam] || [item.HomeTeam isEqualToString:model.AwayTeam] || [item.AwayTeam isEqualToString:model.HomeTeam]) {
            [tempArray addObject:item];
        }
    }
    if (completion) {
        completion(tempArray);
    }
}

- (void)requestResultByDate:(NSDate *)date completion:(void (^)(id result))completion {
    if (date == nil) {
        date = [[NSDate date] sy_yesterday];
    }
    
    NSString *dateStr = [date sy_stringWithFormat:@"yyyy-MM-dd"];
    
    if (![date sy_isToday] && ![date sy_isYesterday]) {
        NSString *result = [self.dateResults objectForKey:dateStr];
        if (result.length > 0) {
            [self handelResult:result completion:completion];
            return;
        }
    }
    
    NSString *url = @"http://ios.win007.com/phone/LqSchedule.aspx";
    NSDictionary *params = @{
                             @"lang":@"0",
                             @"from":@"2",
                             @"date":dateStr,
                             @"type":@"0",
                             @"sort":@"0",
                             @"apiversion":@"1"
                             };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"成功 %@ %@",[responseObject class],html);
        if (html.length > 0) {
            [self handelResult:html completion:completion];
            if (![date sy_isToday] && ![date sy_isYesterday]) {
                [self.dateResults setObject:html forKey:dateStr];
                BOOL status = [self.dateResults writeToFile:[NSString sy_locationDocumentsWithType:SYCachePathTypeNBADateResults] atomically:YES];
                NSLog(@"保存完毕--%d",status);
            }
        }else {
            completion(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(nil);
        }
        NSLog(@"失败%@",error);
    }];
}

- (void)handelResult:(NSString *)html completion:(void (^)(id result))completion{
    NSArray *gamestrings = [html componentsSeparatedByString:@"^#"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *game in gamestrings) {
        //FF0000^20190103080000^-1^^华盛顿奇才^亚特兰大老鹰^114^98^6.5^1.00^0.88^奇才-得分:比尔(24) 篮板:托马斯-布莱恩特(15) 助攻:萨托然斯基(7)<br>老鹰-得分:阿莱克斯.伦(24) 篮板:阿莱克斯.伦(11) 助攻:特雷-杨(9)^^35^29^29^24^24^31^26^14^^^0^5.5^229.5^230.5^0.80^0.86^东11^东12^4^64^53!326126^1
        
        //FF0000^20181228113000^-1^^金州勇士^波特兰开拓者^109^110^8.5^0.98^0.90^勇士-得分:库里(29) 篮板:格林(11) 助攻:杜兰特(11)<br>开拓者-得分:努尔基奇(27) 篮板:阿米奴(12) 助攻:利拉德(5)^^28^27^18^25^25^23^31^27^7^8^0^9.5^225.5^226.5^1.00^0.66^西1^西6^4^46^52!342558^183
        
        if ([game hasPrefix:@"76C5F2"]) {
//            NSLog(@"CBA : %@",game);
        }else if ([game hasPrefix:@"FF0000"]) {
            
            NSArray *datas = [game componentsSeparatedByString:@"^"];
            NSString *time = datas[1];
            NSString *homeName = datas[4];
            NSString *awayName = datas[5];
            NSString *homeScore = datas[6];
            NSString *awayScore = datas[7];
            NSString *avrLetScore = datas[24];
            NSString *dishTotalScore = datas[25];
            NSString *homeGroupLevel = datas[29];
            NSString *awayGroupLevel = datas[30];
            
            SYBasketBallModel *model = [SYBasketBallModel new];
            
            NSDate *date = [NSDate sy_dateWithString:time formate:@"yyyyMMddHHmmss"];
            model.showTime = [date sy_stringWithFormat:@"MM-dd HH:mm"];
            model.HomeTeam = homeName;
            model.AwayTeam = awayName;
            model.homeGroupRank = homeGroupLevel;
            model.awayGroupRank = awayGroupLevel;
            model.homeScore = homeScore;
            model.awayScore = awayScore;
            model.AsianAvrLet = avrLetScore;
            model.dishTotalScore = dishTotalScore;
            model.result = game;
            model.dateSeconds = [date timeIntervalSince1970];
            [tempArray addObject:model];
        }
    }
    if (completion) {
        completion(tempArray);
    }
}
#pragma mark - 逻辑事件
- (void)refreshGameData {
    NSArray *array = [SYBasketBallModel mj_objectArrayWithKeyValuesArray:self.currentGameJsons.allValues];
    BOOL needRefresh = NO;
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"SYBasketSportLastDate"];
    if (date && [date isKindOfClass:[NSDate class]]) {
        needRefresh = [[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970] > 7200;
    }
    
    if (array.count > 0 && needRefresh == NO) {
        NSInteger i = 0;
        do {
            SYBasketBallModel *model = array[i];
            needRefresh = fabs(model.dateSeconds - [[NSDate date] timeIntervalSince1970]) <= 2000;
            i++;
        } while ((!needRefresh)&&(i<array.count));
    }
    
    if (needRefresh) {
        [self requestDatasByType:SYNBAListTypeToday Completion:^(NSArray * _Nonnull datas) {
            NSLog(@"刷新一次");
        }];
    }
}

- (void)calculatorData {
    
    //一种
    NSInteger ph = 0, gh = 0, yh = 0,pa = 0,ga = 0,ya = 0;
    NSInteger ph_h = 0, gh_h = 0, yh_h = 0,pa_h = 0,ga_h = 0,ya_h = 0;
    NSInteger ph_a = 0, gh_a = 0, yh_a = 0,pa_a = 0,ga_a = 0,ya_a = 0;
    //两种
    NSInteger ph_gh = 0, ph_yh = 0, ph_ga = 0, ph_ya = 0,pa_gh = 0, pa_yh = 0, pa_ga = 0, pa_ya = 0, gh_yh = 0,gh_ya = 0,ga_yh = 0,ga_ya = 0;
    NSInteger ph_gh_h = 0, ph_yh_h = 0, ph_ga_h = 0, ph_ya_h = 0,pa_gh_h = 0, pa_yh_h = 0, pa_ga_h = 0, pa_ya_h = 0, gh_yh_h = 0,gh_ya_h = 0,ga_yh_h = 0,ga_ya_h = 0;
    NSInteger ph_gh_a = 0, ph_yh_a = 0, ph_ga_a = 0, ph_ya_a = 0,pa_gh_a = 0, pa_yh_a = 0, pa_ga_a = 0, pa_ya_a = 0, gh_yh_a = 0,gh_ya_a = 0,ga_yh_a = 0,ga_ya_a = 0;
    //三种
    NSInteger ph_gh_yh = 0,ph_gh_ya = 0,ph_ga_yh = 0,ph_ga_ya = 0,pa_gh_yh = 0,pa_gh_ya = 0,pa_ga_yh = 0,pa_ga_ya = 0;
    NSInteger ph_gh_yh_h = 0,ph_gh_ya_h = 0,ph_ga_yh_h = 0,ph_ga_ya_h = 0,pa_gh_yh_h = 0,pa_gh_ya_h = 0,pa_ga_yh_h = 0,pa_ga_ya_h = 0;
    NSInteger ph_gh_yh_a = 0,ph_gh_ya_a = 0,ph_ga_yh_a = 0,ph_ga_ya_a = 0,pa_gh_yh_a = 0,pa_gh_ya_a = 0,pa_ga_yh_a = 0,pa_ga_ya_a = 0;
    
    for (SYBasketBallModel *model in self.allGames) {
        
        if (model.homeScore.length == 0 || model.homeScore.integerValue == 0) {
            continue;
        }
        
        NSInteger resultNum = 0;
        if (model.BfAmountHome >= model.BfPayoutAway) {
            resultNum += 100;
        }
        if (model.BfIndexHome >= model.BfIndexAway) {
            resultNum += 10;
        }
        if (model.BfPayoutHome > model.BfIndexAway) {
            resultNum += 1;
        }
        
        if (resultNum == 111) {
            ph++,gh++,yh++,ph_gh++,ph_yh++,gh_yh++,ph_gh_yh++;
            if ((model.homeScore.integerValue + model.AsianAvrLet.floatValue) > model.homeScore.integerValue) {
                ph_h++,gh_h++,yh_h++,ph_gh_h++,ph_yh_h++,gh_yh_h++,ph_gh_yh_h++;
            }else {
                ph_a++,gh_a++,yh_a++,ph_gh_a++,ph_yh_a++,gh_yh_a++,ph_gh_yh_a++;
            }
        }else if (resultNum == 110) {
            ph++,gh++,ya++,ph_gh++,ph_ya++,gh_ya++,ph_gh_ya++;
            if ((model.homeScore.integerValue + model.AsianAvrLet.floatValue) > model.homeScore.integerValue) {
                ph_h++,gh_h++,ya_h++,ph_gh_h++,ph_ya_h++,gh_ya_h++,ph_gh_ya_h++;
            }else {
                ph_a++,gh_a++,ya_a++,ph_gh_a++,ph_ya_a++,gh_ya_a++,ph_gh_ya_a++;
            }
        }else if (resultNum == 101) {
            ph++,ga++,yh++,ph_ga++,ph_yh++,ga_yh++,ph_ga_yh++;
            if ((model.homeScore.integerValue + model.AsianAvrLet.floatValue) > model.homeScore.integerValue) {
                ph_h++,ga_h++,yh_h++,ph_ga_h++,ph_yh_h++,ga_yh_h++,ph_ga_yh_h++;
            }else {
                ph_a++,ga_a++,yh_a++,ph_ga_a++,ph_yh_a++,ga_yh_a++,ph_ga_yh_a++;
            }
        }else if (resultNum == 100) {
            ph++,ga++,ya++,ph_ga++,ph_ya++,ga_ya++,ph_ga_ya++;
            if ((model.homeScore.integerValue + model.AsianAvrLet.floatValue) > model.homeScore.integerValue) {
                ph_h++,ga_h++,ya_h++,ph_ga_h++,ph_ya_h++,ga_ya_h++,ph_ga_ya_h++;
            }else {
                ph_a++,ga_a++,ya_a++,ph_ga_a++,ph_ya_a++,ga_ya_a++,ph_ga_ya_a++;
            }
            
        }else if (resultNum == 11) {
            pa++,gh++,yh++,pa_gh++,pa_yh++,gh_yh++,pa_gh_yh++;
            if ((model.homeScore.integerValue + model.AsianAvrLet.floatValue) > model.homeScore.integerValue) {
                pa_h++,gh_h++,yh_h++,pa_gh_h++,pa_yh_h++,gh_yh_h++,pa_gh_yh_h++;
            }else {
                pa_a++,gh_a++,yh_a++,pa_gh_a++,pa_yh_a++,gh_yh_a++,pa_gh_yh_a++;
            }
        }else if (resultNum == 10) {
            pa++,gh++,ya++,pa_gh++,pa_ya++,gh_ya++,pa_gh_ya++;
            if ((model.homeScore.integerValue + model.AsianAvrLet.floatValue) > model.homeScore.integerValue) {
                pa_h++,gh_h++,ya_h++,pa_gh_h++,pa_ya_h++,gh_ya_h++,pa_gh_ya_h++;
            }else {
                pa_a++,gh_a++,ya_a++,pa_gh_a++,pa_ya_a++,gh_ya_a++,pa_gh_ya_a++;
            }
        }else if (resultNum == 1) {
            pa++,ga++,yh++,pa_ga++,pa_yh++,ga_yh++,pa_ga_yh++;
            if ((model.homeScore.integerValue + model.AsianAvrLet.floatValue) > model.homeScore.integerValue) {
                pa_h++,ga_h++,yh_h++,pa_ga_h++,pa_yh_h++,ga_yh_h++,pa_ga_yh_h++;
            }else {
                pa_a++,ga_a++,yh_a++,pa_ga_a++,pa_yh_a++,ga_yh_a++,pa_ga_yh_a++;
            }
        }else if (resultNum == 0) {
            pa++,ga++,ya++,pa_ga++,pa_ya++,ga_ya++,pa_ga_ya++;
            if ((model.homeScore.integerValue + model.AsianAvrLet.floatValue) > model.homeScore.integerValue) {
                pa_h++,ga_h++,ya_h++,pa_ga_h++,pa_ya_h++,ga_ya_h++,pa_ga_ya_h++;
            }else {
                pa_a++,ga_a++,ya_a++,pa_ga_a++,pa_ya_a++,ga_ya_a++,pa_ga_ya_a++;
            }
        }
        
    }
}

#pragma mark - 保存数据
- (void)sy_writeToFile:(id)datas forPath:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    [datas writeToFile:path atomically:YES];
}

- (NSString *)dataPathWithFileName:(NSString *)fileName {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:fileName];
}

#pragma mark - 分数赋值
- (void)changeScoreWithModels:(NSArray *)models {
    if (models.count == 0) {
        return;
    }
    
    for (SYBasketBallModel *model in models) {
        [self changeScoreModel:model];
    }
}
- (void)deleteModel:(SYBasketBallModel *)model {
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.allGames];
    for (SYBasketBallModel *item in tempArray) {
        if ([item.EventId isEqualToString:model.EventId]) {
            [tempArray removeObject:item];
            break;
        }
    }
    
    [self.gameJsons removeObjectForKey:model.EventId];
    [self save];
}

- (void)changeScoreModel:(SYBasketBallModel *)model {
    
    for (SYBasketBallModel *item in _allGames) {
        if ([item.EventId isEqualToString:model.EventId]) {
            item.homeScore = model.homeScore;
            item.awayScore = model.awayScore;
            item.AsianAvrLet = model.AsianAvrLet;
            item.dishTotalScore = model.dishTotalScore;
            item.homeGroupRank = model.homeGroupRank;
            item.awayGroupRank = model.awayGroupRank;
            item.result = model.result;
            
            if (model.homeGroupRank.length > 0 && ([model.homeGroupRank hasPrefix:@"东"] || [model.homeGroupRank hasPrefix:@"西"])) {
                [self.ranks setValue:model.homeGroupRank forKey:item.HomeTeam];
            }
            
            if (model.awayGroupRank.length > 0 && ([model.awayGroupRank hasPrefix:@"东"] || [model.awayGroupRank hasPrefix:@"西"])) {
                [self.ranks setValue:model.awayGroupRank forKey:item.AwayTeam];
            }
            
            break;
        }
    }
//    if (exitModel) {
//        [self.gameJsons setObject:exitModel.mj_keyValues forKey:model.EventId];
//    }else {
//        [self.gameJsons setObject:model.mj_keyValues forKey:model.EventId];
//    }

    NSDictionary *json = [self.gameJsons objectForKey:model.EventId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (json) {
        [dict addEntriesFromDictionary:json];
        [dict setValue:model.homeScore forKey:@"homeScore"];
        [dict setValue:model.awayScore forKey:@"awayScore"];
        [dict setValue:model.AsianAvrLet forKey:@"AsianAvrLet"];
        [dict setValue:model.dishTotalScore forKey:@"dishTotalScore"];
        [dict setValue:model.homeGroupRank forKey:@"homeGroupRank"];
        [dict setValue:model.awayGroupRank forKey:@"awayGroupRank"];
        [dict setValue:model.result forKey:@"result"];
    }else {
        dict = model.mj_keyValues;
    }
    
    [self.gameJsons setObject:dict forKey:model.EventId];
    [self save];
//    for (SYRecommendModel *recommend in self.recommends) {
//        [recommend changeModelInformation:model];
//    }
}

//- (void)replaceDataForNewest {
//    for (NSString *html in self.dateResults.allValues) {
//        
//    }
//}

- (void)save {
    [self.ranks writeToFile:[NSString sy_locationDocumentsWithType:SYCachePathTypeNBARank] atomically:YES];
    [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
}

- (void)copyScoreFrom:(SYBasketBallModel *)result toGame:(SYBasketBallModel *)game {
    game.homeScore = result.homeScore;
    game.awayScore = result.awayScore;
    game.AsianAvrLet = result.AsianAvrLet;
    game.dishTotalScore = result.dishTotalScore;
    game.homeGroupRank = result.homeGroupRank;
    game.awayGroupRank = result.awayGroupRank;
    game.result = result.result;

    [self.gameIdToResultGameName setObject:result.HomeTeam forKey:game.HomeTeam];
    [self.gameIdToResultGameName setObject:result.AwayTeam forKey:game.AwayTeam];
    [self.gameIdToResultGameName writeToFile:[NSString sy_locationDocumentsWithType:SYCachePathTypeNBAGameNameToResultName] atomically:YES];
}

- (void)replaceDataForNewest {
    NSString *todayString = [[NSDate date] sy_stringWithFormat:@"yyyyMMdd"];
    NSString *path = [[NSBundle mainBundle] pathForResource:[@"NBA-" stringByAppendingString:todayString] ofType:@"plist"];
    if (path == nil) {
        return;
    }
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"NBAReplaceDataForNewest"];
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
                    SYBasketBallModel *newModel = [SYBasketBallModel mj_objectWithKeyValues:newDict];
                    SYBasketBallModel *oldModel = [SYBasketBallModel mj_objectWithKeyValues:oldDict];
                    
                    if (![newModel.MaxUpdateTime isEqualToString:oldModel.MaxUpdateTime] && newModel.updateSeconds > oldModel.updateSeconds) {
                        oldModel.BfPayoutHome = newModel.BfPayoutHome;
                        oldModel.BfPayoutAway = newModel.BfPayoutAway;
                        oldModel.BfAmountHome = newModel.BfAmountHome;
                        oldModel.BfAmountAway = newModel.BfAmountAway;
                        oldModel.BfIndexHome = newModel.BfIndexHome;
                        oldModel.BfIndexAway = newModel.BfIndexAway;
                        oldModel.MaxTeamId = newModel.MaxTeamId;
                        oldModel.MaxUpdateTime = newModel.MaxUpdateTime;
                        oldModel.MaxTradedChange = newModel.MaxTradedChange;
                        
                        [self.gameJsons setObject:[oldModel mj_keyValues] forKey:key];
                    }
                }else {
                    [self.gameJsons setObject:newDict forKey:key];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"NBAReplaceDataForNewest"];
                [self sy_writeToFile:self.gameJsons forPath:[self dataPathWithFileName:gamesJsonPath]];
                _allGames = [SYBasketBallModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
                [MBProgressHUD showSuccess:@"篮球更新执行完毕" toView:nil];
            });
        });
        
    }
}

#pragma mark - 懒加载

- (NSMutableDictionary *)gameIdToResultGameName {
    if (_gameIdToResultGameName == nil) {
        _gameIdToResultGameName = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString sy_locationDocumentsWithType:SYCachePathTypeNBAGameNameToResultName]];
        if (_gameIdToResultGameName == nil) {
            _gameIdToResultGameName = [NSMutableDictionary dictionary];
        }
    }
    return _gameIdToResultGameName;
}

- (NSMutableDictionary *)currentGameJsons {
    if (_currentGameJsons == nil) {
        _currentGameJsons = [[NSMutableDictionary alloc] init];
    }
    return _currentGameJsons;
}

- (NSArray *)allGames {
    if (_allGames == nil) {
        _allGames = [SYBasketBallModel mj_objectArrayWithKeyValuesArray:self.gameJsons.allValues];
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

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1000 target:self selector:@selector(refreshGameData) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSMutableDictionary *)dateResults {
    if (_dateResults == nil) {
        _dateResults = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString sy_locationDocumentsWithType:SYCachePathTypeNBADateResults]];
        if (_dateResults == nil) {
            _dateResults = [NSMutableDictionary dictionary];
        }
    }
    return _dateResults;
}

- (NSMutableDictionary *)ranks {
    if (_ranks == nil) {
        _ranks = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString sy_locationDocumentsWithType:SYCachePathTypeNBARank]];
        if (_ranks == nil) {
            _ranks = [NSMutableDictionary dictionary];
        }
    }
    return _ranks;
}
@end

@implementation SYNBADataAnalyze

- (NSInteger)totalCount {
    return self.homeCount + self.awayCount;
}

@end
