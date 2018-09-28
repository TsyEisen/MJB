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
@end

@implementation SYCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView addSubview:self.rightTableView];
    CGFloat w = 80;
    CGFloat h = 20;
    for (int i = 0; i < 10; i++) {
        SYDataLabel *label = [[SYDataLabel alloc] initWithFrame:CGRectMake(i*w, 0, w, h)];
        label.tag = i;
        [self.scrollView addSubview:label];
    }
    self.scrollView.contentSize = CGSizeMake(self.rightTableView.sy_width, 0);
    [self.rightTableView sy_registerCellWithClass:[SYGameTableCell class]];
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
        [cell.textLabel sizeToFit];
        return cell;
    }else {
        SYGameTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SYGameTableCell class])];
        cell.model = model;
        return cell;
    }
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
    }
    return _rightTableView;
}

- (NSArray *)datas {
    if (_datas == nil) {
        _datas = [[NSArray alloc] init];
    }
    return _datas;
}
@end
