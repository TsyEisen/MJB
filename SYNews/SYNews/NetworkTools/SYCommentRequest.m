//
//  SYCommentRequest.m
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYCommentRequest.h"
#import "SYGameModel.h"

#define kBaseUrl @"http://api.spdex.com"

@implementation SYCommentRequest
+ (void)requestGaneDataWithKeyWord:(NSInteger)enventId completion:(void (^)(id result,NSError *error))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"app":@"z",
                                                                                  @"version":@"i3.11",
                                                                                  @"keyword":@(enventId)
                                                                                  }];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"text/plain"]];
    [manager GET:[kBaseUrl stringByAppendingString:@"/data/search"] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SYGameModel *model = [SYGameModel mj_objectWithKeyValues:responseObject];
        completion(model,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--%@",error);
        completion(nil,error);
    }];
}
@end
