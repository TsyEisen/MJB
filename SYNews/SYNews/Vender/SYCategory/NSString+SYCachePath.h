//
//  NSString+SYCachePath.h
//  SYNews
//
//  Created by leju_esf on 2018/12/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SYCachePathType) {
    SYCachePathTypeDateResults = 0
};

@interface NSString (SYCachePath)
+ (NSString *)sy_locationDocumentsWithType:(SYCachePathType)type;
@end

NS_ASSUME_NONNULL_END