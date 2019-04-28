//
//  SYKellyDistributeViewController.m
//  SYNews
//
//  Created by leju_esf on 2019/4/25.
//  Copyright © 2019年 tsy. All rights reserved.
//

#import "SYKellyDistributeViewController.h"

@interface SYKellyDistributeViewController ()

@end

@implementation SYKellyDistributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSDictionary *home = [self calculator:self.model.]
}

- (NSDictionary *)calculator:(NSArray *)datas {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSNumber *num in datas) {
        NSInteger num_int = num.integerValue;
        NSNumber *count = [dict objectForKey: @(num_int)];
        if (!count) {
            count = @(0);
        }
        NSInteger count_int = count.integerValue;
        count_int += 1;
        [dict setObject:@(count_int) forKey:@(num_int)];
    }
    return dict;
}

@end
