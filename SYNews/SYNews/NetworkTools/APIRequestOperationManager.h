//
//  APIRequestOperationManager.h
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "APIRequest.h"

@interface APIRequestOperationManager : AFHTTPSessionManager

+ (instancetype)sharedRequestOperationManager;

- (NSURLSessionDataTask *)requestAPI:(APIRequest *)api completion:(void (^)(id result, NSError *error,NSProgress *downloadProgress))completion;

@end
