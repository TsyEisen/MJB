//
//  SYNewsDetailViewController.m
//  SYNews
//
//  Created by leju_esf on 2017/8/29.
//  Copyright © 2017年 tsy. All rights reserved.
//

#import "SYNewsDetailViewController.h"
#import "SYHomeNewsModel.h"

@interface SYNewsDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation SYNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setNewsId:(NSString *)newsId {
    _newsId = newsId;
    [APIRequest requestNewsDetailWithNewsId:newsId completion:^(id result, NSError *error) {
        if (result) {
            SYNewsDetailModel *model = (SYNewsDetailModel *)result;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.url]];
            [self.webView loadRequest:request];
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.title.length == 0) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

@end
