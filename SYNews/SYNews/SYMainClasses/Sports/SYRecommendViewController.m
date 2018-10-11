//
//  SYRecommendViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/10/10.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYRecommendViewController.h"
#import "SYGameListCell.h"
#import "SYGameTableCell.h"
@interface SYRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation SYRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.title = @"推介";
//    [self.tableView sy_registerNibWithClass:[SYGameListCell class]];
}

- (void)setUpUI {
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.top.equalTo(self.view);
//    }];
    [self.view addSubview:self.scrollView];
    CGFloat w = ScreenW;
    CGFloat h = 20;
    for (int i = 0; i < [SYSportDataManager sharedSYSportDataManager].recommends.count; i++) {
        SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[i];
        SYDataLabel *label = [[SYDataLabel alloc] initWithFrame:CGRectMake(i*w, 0, w, h)];
        label.text = model.name;
        [self.scrollView addSubview:label];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*w, 20, w, ScreenH - 84)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100;
        tableView.backgroundColor = [UIColor sy_colorWithRGB:0xf4f4f4];
        tableView.tag = i;
        [tableView sy_registerNibWithClass:[SYGameListCell class]];
        [self.scrollView addSubview:tableView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(w * [SYSportDataManager sharedSYSportDataManager].recommends.count, 0)];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[tableView.tag];
    return model.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameListCell class])];
    SYRecommendModel *model = [SYSportDataManager sharedSYSportDataManager].recommends[tableView.tag];
    cell.model = model.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
@end
