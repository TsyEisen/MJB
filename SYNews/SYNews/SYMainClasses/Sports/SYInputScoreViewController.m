//
//  SYInputScoreViewController.m
//  SYNews
//
//  Created by 唐绍禹 on 2018/9/25.
//  Copyright © 2018年 tsy. All rights reserved.
//

#import "SYInputScoreViewController.h"
//#import "SYTransitionAnimation.h"
@interface SYInputScoreViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *homeTextField;
@property (weak, nonatomic) IBOutlet UITextField *awayTextField;
//@property (nonatomic, strong) SYTransitionAnimation *animation;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@end

@implementation SYInputScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.homeTextField becomeFirstResponder];
//    self.transitioningDelegate = self;
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

- (void)saveAction {
    if (self.homeTextField.text.length > 0 && self.awayTextField.text.length > 0) {
        self.model.homeScore = self.homeTextField.text;
        self.model.awayScore = self.awayTextField.text;
        self.model.score = [NSString stringWithFormat:@"%@:%@",self.homeTextField.text,self.awayTextField.text];
        [MBProgressHUD showSuccess:@"保存成功" toView:nil];
        [[SYSportDataManager sharedSYSportDataManager] changeScoreModel:self.model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
        _rightItem.tintColor = [UIColor whiteColor];
    }
    return _rightItem;
}

//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
//    self.animation.animationType = SYAnimationTypePresent;
//    return self.animation;
//}
//
//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//    self.animation.animationType = SYAnimationTypeDismiss;
//    return self.animation;
//}
//
//- (SYTransitionAnimation *)animation {
//    if (_animation == nil) {
//        _animation = [[SYTransitionAnimation alloc] init];
//    }
//    return _animation;
//}
@end
