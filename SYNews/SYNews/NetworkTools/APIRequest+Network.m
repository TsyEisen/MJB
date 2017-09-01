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

@implementation APIRequest (Network)
+ (void)requestHomeDataWithSection:(NSInteger)page completion:(void (^)(id result,NSError *error))completion {
    APIRequest *request = [APIRequest new];
    request.method = APIRequestMethodGet;
    request.apiPath = @"/storyformobile/newslist.ashx";
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
    request.apiPath = @"/storyformobile/newsDetail.ashx";
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
@end
