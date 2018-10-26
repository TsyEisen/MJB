//
//  SYCompareViewController.h
//  SYNews
//
//  Created by leju_esf on 2018/9/28.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYBaseViewController.h"

@interface SYResultModel : NSObject
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) BOOL red;
@end

@interface SYCompareViewController : SYBaseViewController
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, assign) SYListType type;
@end
