//
//  ListRequestManager.m
//  redpoppy
//
//  Created by leju_esf on 2018/7/17.
//  Copyright © 2018年 Hale Chan. All rights reserved.
//

#import "ListRequestManager.h"
#import "AFHTTPSessionManager.h"
#import "SYSportModel.h"
#import "SYGameModel.h"
#import "SYGameListModel.h"

#define kBaseUrl @"http://api.spdex.com"

@interface ListRequestManager()
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) Class modelclass;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL noMoreData;
@end

@implementation ListRequestManager
- (instancetype)initWithType:(ListRequestPageType)type {
    if (self = [super init]) {
        self.type = type;
        _datas = [NSArray array];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _datas = [NSArray array];
    }
    return self;
}
/*
 http://api.spdex.com/spdex/leagues/sports?sports=1,7522&app=z&version=i3.11
 http://api.spdex.com/spdex/match_data/sports?class=-1&league=287&sports=1,7522&app=z&version=i3.11
 http://api.spdex.com/data/search?keyword=28875078&app=z&version=i3.11
 */

- (void)setType:(ListRequestPageType)type {
    _type = type;
    switch (type) {
        case ListRequestPageTypeHomeSport:
            self.url = [kBaseUrl stringByAppendingString:@"/spdex/leagues/sports"];
            self.modelclass = SYSportModel.class;
            break;
        case ListRequestPageTypeCatagorySport:
            self.url = [kBaseUrl stringByAppendingString:@"/spdex/match_data/sports"];
            self.modelclass = SYGameListModel.class;
            break;
        default:
            self.url = nil;
            break;
    }
}

- (void)loadNewData {
    self.noMoreData = NO;
    self.page = 1;
    [self requestData];
}

- (void)loadMoreData {
    if (self.noMoreData) {
        return;
    }
    self.page ++;
    [self requestData];
}

- (void)requestData {
    if (self.isLoading) {
        return;
    }else {
        self.isLoading = YES;
    }
    
    if (self.url == nil && self.reloadData) {
        self.reloadData(nil);
        return;
    }
    
//    APIRequest *request = [APIRequest new];
//    request.method = APIRequestMethodGet;
//    request.apiPath = [kHomeBaseUrl stringByAppendingString:@"/storyformobile/newslist.ashx"];
//    request.parameters = @{@"sectionId":@(page)};
//    [[APIRequestOperationManager sharedRequestOperationManager] requestAPI:request completion:^(id result, NSError *error, NSProgress *downloadProgress) {
//        if ([[result objectForKey:@"result"] isEqualToString:@"true"]) {
//            NSArray *list = [SYHomeNewsModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"newslist"]];
//            completion(list,nil);
//        }else {
//            completion(nil,error);
//        }
//    }];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"sports":@"1,7522",
                                                                                  @"app":@"z",
                                                                                  @"version":@"i3.11"
                                                                                  }];
    if (self.params.count > 0) {
        [params addEntriesFromDictionary:self.params];
    }
    
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/plain"]];
    [manager GET:self.url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@",responseObject);
        [weakSelf dealData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@",error);
    }];
    
}

//- (void)filtData:(CXTBaseResponse *)response {
//    if (self.type == ListRequestPageTypeStatusDetail) {
//        [self dealData:[response.data objectForKey:@"comments"]];
//        if (self.reloadOtherData) {
//            self.reloadOtherData([response.data objectForKey:@"info"]);
//        }
//    }else if (self.type == ListRequestPageTypeMyLiveApply || self.type == ListRequestPageTypeLiveRoomList){
//        self.noMoreData = response.total.integerValue <= self.datas.count + [(NSArray *)response.data count];
//        [self dealData:response.data];
//    }else if (self.type == ListRequestPageTypeGoodDetailEvaluate){
//        self.noMoreData = response.total.integerValue <= self.datas.count + [(NSArray *)response.data count];
//        if (self.reloadOtherData) {
//            self.reloadOtherData(response);
//        }
//        [self dealData:response.data];
//    }else {
//        [self dealData:response.data];
//    }
//}

- (void)dealData:(NSArray *)datas {
    
    if ([self.datas isKindOfClass:[NSArray class]] && datas != nil && datas.count > 0) {
        
        NSArray *array = [self.modelclass mj_objectArrayWithKeyValuesArray:datas];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (self.type == ListRequestPageTypeHomeSport) {
            for (SYSportModel *model in array) {
                NSMutableArray *temp = [dict objectForKey:model.Classification.stringValue];
                if (!temp) {
                    temp = [NSMutableArray array];
                }
                [temp addObject:model];
                [dict setObject:temp forKey:model.Classification.stringValue];
            }
            _datas = dict.allValues;
        }else {
            _datas = array;
        }
    
        if (self.reloadData) {
            self.reloadData(nil);
        }
        
//        if (self.page == 1) {
//            _datas = array;
//        }else {
//            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_datas];
//            [tempArray addObjectsFromArray:array];
//            _datas = tempArray;
//        }
//        
//        if (self.reloadData) {
//            self.reloadData(nil);
//        }
        
    }else {
        self.noMoreData = YES;
        
        if (self.page == 1) {
            _datas = @[];
        }
        
        if ((_datas.count == 0||self.page == 1)&& self.reloadData) {
            self.reloadData(nil);
        }
    }
    
}

@end
