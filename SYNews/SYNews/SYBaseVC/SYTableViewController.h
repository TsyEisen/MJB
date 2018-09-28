//
//  SYTableViewController.h
//  SYNews
//
//  Created by leju_esf on 2018/9/21.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYBaseViewController.h"
#import "ListRequestManager.h"

@interface SYTableViewController : SYBaseViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ListRequestManager *manager;
@property (nonatomic, strong) UITableView *tableView;
- (void)requestData;
@end
