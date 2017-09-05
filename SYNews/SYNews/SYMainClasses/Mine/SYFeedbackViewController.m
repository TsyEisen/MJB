//
//  SYFeedbackViewController.m
//  SYNews
//
//  Created by leju_esf on 2017/9/4.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYFeedbackViewController.h"

@interface SYFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@end

@implementation SYFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.textView.layer.borderColor = [UIColor lineDefaultColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    self.title = @"Feedback";
}

- (void)sendFeedback {
    
    if (self.textView.text.length == 0) {
        [MBProgressHUD showError:@"Please enter content" toView:self.view];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showSuccess:@"Success!" toView:self.view];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"send" style:UIBarButtonItemStylePlain target:self action:@selector(sendFeedback)];
        _rightItem.tintColor = [UIColor whiteColor];
    }
    return _rightItem;
}

@end
