//
//  SYCompareViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/9/28.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYCompareViewController.h"
#import "SYGameTableCell.h"
@interface SYCompareViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTabelView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@end

@implementation SYCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView addSubview:self.rightTableView];
    NSArray *titles = @[@"概率大",@"概率中",@"概率小",@"交易大",@"交易中",@"交易小",@"方差大",@"方差中",@"方差小",@"单注"];
    CGFloat w = 80;
    CGFloat h = 20;
    for (int i = 0; i < 10; i++) {
        NSString *title = titles[i];
        SYDataLabel *label = [[SYDataLabel alloc] initWithFrame:CGRectMake(i*w, 0, w, h)];
        label.tag = i;
        label.text = title;
        [self.scrollView addSubview:label];
    }
    self.scrollView.contentSize = CGSizeMake(self.rightTableView.sy_width, 0);
    [self.rightTableView sy_registerCellWithClass:[SYGameTableCell class]];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.leftTabelView.tableFooterView = [UIView new];
}

- (void)refreshAction {
    _datas = nil;
    [self.rightTableView reloadData];
    [self.leftTabelView reloadData];
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGameListModel *model = self.datas[indexPath.row];
    if (tableView == self.leftTabelView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ vs %@",model.HomeTeam,model.AwayTeam];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
        cell.textLabel.numberOfLines = 0;
        [cell.textLabel sizeToFit];
        return cell;
    }else {
        SYGameTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameTableCell class])];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.leftTabelView) {
        [self.rightTableView setContentOffset:scrollView.contentOffset];
    }else {
        [self.leftTabelView setContentOffset:scrollView.contentOffset];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)rightTableView {
    if (_rightTableView == nil) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 800, ScreenH - 84) style:UITableViewStylePlain];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.backgroundColor = [UIColor sy_colorWithRGB:0xf4f4f4];
        _rightTableView.tableFooterView = [UIView new];
    }
    return _rightTableView;
}

- (NSArray *)datas {
    if (_datas == nil) {
        _datas = [[SYSportDataManager sharedSYSportDataManager] getAllScoreGames];
    }
    return _datas;
}

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refreshAction)];
        _rightItem.tintColor = [UIColor whiteColor];
    }
    return _rightItem;
}
@end
