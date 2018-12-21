//
//  NSString+SYCachePath.m
//  SYNews
//
//  Created by leju_esf on 2018/12/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "NSString+SYCachePath.h"

@implementation NSString (SYCachePath)
+ (NSString *)sy_locationDocumentsWithType:(SYCachePathType)type {
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    return [document stringByAppendingString:[NSString stringWithFormat:@"SYCachePathType_%zd_data.plist",type]];
}
@end
