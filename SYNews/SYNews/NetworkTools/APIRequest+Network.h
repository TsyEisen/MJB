//
//  APIRequest+Network.h
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "APIRequest.h"

@interface APIRequest (Network)
+ (void)requestHomeDataWithSection:(NSInteger)section completion:(void (^)(id result,NSError *error))completion;
+ (void)requestNewsDetailWithNewsId:(NSString *)newsId completion:(void (^)(id result,NSError *error))completion;
+ (void)requestDistoverDataWithPage:(NSInteger)page completion:(void (^)(id result,NSError *error))completion;
+ (void)requestDistoverDetailWithNewId:(NSString *)newid completion:(void (^)(id result,NSError *error))completion;
@end
