//
//  SYListViewController.h
//  SYNews
//
//  Created by 唐绍禹 on 2018/9/23.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYBaseViewController.h"

typedef NS_ENUM(NSUInteger, SYListType) {
    SYListTypeCategory = 1,
    SYListTypePayTop = 2,
    SYListTypeNear = 3,
    SYListTypeCollection = 4,
    SYListTypeHistory = 5
};

@interface SYListViewController : SYBaseViewController

@end
