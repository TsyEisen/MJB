//
//  SYNBADataManager.h
//  SYNews
//
//  Created by leju_esf on 2018/12/13.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SYNBAListType) {
    SYNBAListTypeToday,
    SYNBAListTypeAll
};

@interface SYNBADataManager : NSObject
SYSingleton_interface(SYNBADataManager)
- (void)requestDatasByType:(SYNBAListType)type Completion:(void(^)(NSArray *datas))completion;
@end

NS_ASSUME_NONNULL_END
