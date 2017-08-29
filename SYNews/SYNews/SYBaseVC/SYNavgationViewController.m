//
//  SYNavgationViewController.m
//  SYCaiPiao
//
//  Created by leju_esf on 17/5/5.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYNavgationViewController.h"

@interface SYNavgationViewController ()

@end

@implementation SYNavgationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor appMainColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
