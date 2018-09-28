//
//  SYCommentRequest.h
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYCommentRequest : NSObject
+ (void)requestGaneDataWithKeyWord:(NSInteger)enventId completion:(void (^)(id result,NSError *error))completion;
@end
