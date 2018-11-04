//
//  SYCategoryViewController.m
//  SYNews
//
//  Created by leju_esf on 2018/10/9.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYCategoryViewController.h"
#import "SYCategoryCell.h"
#import "SYCompareViewController.h"
#import "SYNormalListViewController.h"

@interface SYCategoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *followLayout;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation SYCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.followLayout.itemSize = CGSizeMake(ScreenW/3, 40);
    self.followLayout.minimumInteritemSpacing = 0;
    self.followLayout.minimumLineSpacing = 0;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SYCategoryCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SYCategoryCell class])];
    [self setupMJRefresh];
}

- (void)setupMJRefresh {
    __weak typeof (self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshAction];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)refreshAction {
    [[SYSportDataManager sharedSYSportDataManager] requestDatasBySYListType:self.type Completion:^(NSArray *datas) {
        [self.collectionView.mj_header endRefreshing];
        self.datas = datas;
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SYCategoryCell class]) forIndexPath:indexPath];
    NSArray *item = self.datas[indexPath.item];
    SYGameListModel *model = item.firstObject;
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%zd)",model.SortName,item.count];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.title isEqualToString:@"历史回顾"]) {
        SYCompareViewController *vc = [[SYCompareViewController alloc] initWithNibName:NSStringFromClass([SYCompareViewController class]) bundle:nil];
        vc.datas = self.datas[indexPath.item];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        SYNormalListViewController *vc = [[SYNormalListViewController alloc] init];
        vc.datas = self.datas[indexPath.item];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray *)datas {
    if (_datas == nil) {
        _datas = [[NSArray alloc] init];
    }
    return _datas;
}

@end
