//
//  SYHomeViewController.m
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYHomeViewController.h"
#import "SYSwitchView.h"
#import "SYHomeNewsViewController.h"

@interface SYHomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) SYSwitchView *switchView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.switchView];
    for (int i = 0; i < 7; i++) {
        SYHomeNewsViewController *newsVc = [SYHomeNewsViewController instancetFromNib];
        newsVc.section = i;
        newsVc.view.frame = CGRectMake(ScreenW * i, 0, ScreenW, ScreenH - 88);
        [self addChildViewController:newsVc];
        [self.scrollView addSubview:newsVc.view];
    }
    self.scrollView.contentSize = CGSizeMake(ScreenW * 7, 0);
}

- (void)scrollToIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(ScreenW *index, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x/ScreenW);
    [self.switchView setIndex:index];
}

- (SYSwitchView *)switchView {
    if (_switchView == nil) {
        _switchView = [[SYSwitchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
        __weak typeof(self) weakSelf = self;
        [_switchView setSelectBlock:^(NSInteger index){
            [weakSelf scrollToIndex:index];
        }];
    }
    return _switchView;
}

@end
