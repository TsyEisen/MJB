//
//  APIRequest+Network.m
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "APIRequest+Network.h"
#import "APIRequestOperationManager.h"
#import "SYHomeNewsModel.h"
#import "SYDiscoverNewsModel.h"
#import "SYDiscoverDetailModel.h"

NSString *const kHomeBaseUrl = @"http://61.129.118.77";
NSString *const kDiscoverBaseUrl = @"http://apps.iyuba.com";

@implementation APIRequest (Network)
+ (void)requestHomeDataWithSection:(NSInteger)page completion:(void (^)(id result,NSError *error))completion {
    APIRequest *request = [APIRequest new];
    request.method = APIRequestMethodGet;
    request.apiPath = [kHomeBaseUrl stringByAppendingString:@"/storyformobile/newslist.ashx"];
    request.parameters = @{@"sectionId":@(page)};
    [[APIRequestOperationManager sharedRequestOperationManager] requestAPI:request completion:^(id result, NSError *error, NSProgress *downloadProgress) {
        if ([[result objectForKey:@"result"] isEqualToString:@"true"]) {
            NSArray *list = [SYHomeNewsModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"newslist"]];
            completion(list,nil);
        }else {
            completion(nil,error);
        }
    }];
}

+ (void)requestNewsDetailWithNewsId:(NSString *)newsId completion:(void (^)(id, NSError *))completion {
    APIRequest *request = [APIRequest new];
    request.method = APIRequestMethodGet;
    request.apiPath = [kHomeBaseUrl stringByAppendingString:@"/storyformobile/newsDetail.ashx"];
    request.parameters = @{@"newsId":newsId?:@""};
    [[APIRequestOperationManager sharedRequestOperationManager] requestAPI:request completion:^(id result, NSError *error, NSProgress *downloadProgress) {
        if ([[result objectForKey:@"result"] isEqualToString:@"true"]) {
            NSArray *list = [SYNewsDetailModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"newslist"]];
            completion(list.firstObject,nil);
        }else {
            completion(nil,error);
        }
    }];
}

+ (void)requestDistoverDataWithPage:(NSInteger)page completion:(void (^)(id result,NSError *error))completion {
    APIRequest *request = [APIRequest new];
    request.method = APIRequestMethodGet;
    request.apiPath = [kDiscoverBaseUrl stringByAppendingString:@"/iyuba/titleChangSuApi.jsp"];
    request.parameters = @{
                           @"pages":@(page),
                           @"type":@"iOS",
                           @"format":@"json",
                           @"appId":@"107",
                           @"pageNum":@"10",
                           @"parentID":@"0",
                           @"maxid":@"0"
                           };
    [[APIRequestOperationManager sharedRequestOperationManager] requestAPI:request completion:^(id result, NSError *error, NSProgress *downloadProgress) {
        if ([result objectForKey:@"data"]) {
            NSArray *list = [SYDiscoverNewsModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"data"]];
            completion(list,nil);
        }else {
            completion(nil,error);
        }
    }];
}

+ (void)requestDistoverDetailWithNewId:(NSString *)newid completion:(void (^)(id result,NSError *error))completion {
    APIRequest *request = [APIRequest new];
    request.method = APIRequestMethodGet;
    request.apiPath = [kDiscoverBaseUrl stringByAppendingString:@"/iyuba/textExamApi.jsp"];
    request.parameters = @{
                           @"format":@"json",
                           @"voaid":newid?:@""
                           };
    [[APIRequestOperationManager sharedRequestOperationManager] requestAPI:request completion:^(id result, NSError *error, NSProgress *downloadProgress) {
        if ([result objectForKey:@"voatext"]) {
            NSArray *list = [SYDiscoverDetailModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"voatext"]];
            completion(list,nil);
        }else {
            completion(nil,error);
        }
    }];
}
@end
