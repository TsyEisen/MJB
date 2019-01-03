//
//  SYMoreViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/10/10.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYMoreViewController.h"
#import "SYTabBarViewController.h"

@interface SYMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation SYMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}
- (void)setUpUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    SYChildVCModel *model = self.datas[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SYChildVCModel *model = self.datas[indexPath.row];
    NSString*nibPath = [[NSBundle mainBundle] pathForResource:model.className ofType:@"nib"];
    SYBaseViewController *baseVc = [[NSClassFromString(model.className) alloc] init];
    if (nibPath) {
        baseVc = [(SYBaseViewController *)[NSClassFromString(model.className) alloc] initWithNibName:model.className bundle:nil];
    }
    
    if (model.type > 0) {
        [baseVc setValue:@(model.type) forKey:@"type"];
    }
    
    baseVc.hidesBottomBarWhenPushed = YES;
    baseVc.title = model.title;
//
//    if ([model.className isEqualToString:@"SYListViewController"]) {
//        [baseVc setValue:model.type forKey:@"type"];
//    }
    
    [self.navigationController pushViewController:baseVc animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
//        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = [UIColor sy_colorWithRGB:0xf4f4f4];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)datas {
    if (_datas == nil) {
        _datas = [SYChildVCModel moreVcModelsWithType:self.type];
    }
    return _datas;
}
@end
