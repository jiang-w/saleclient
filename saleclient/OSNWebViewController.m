//
//  OSNWebViewController.m
//  saleclient
//
//  Created by Frank on 16/1/27.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "OSNWebViewController.h"
#import "NavigationBarView.h"
#import <Masonry.h>
#import <MBProgressHUD.h>

@interface OSNWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) NavigationBarView *navBar;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation OSNWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.webView];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(76);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark - Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    hud.labelText = @"加载中...";
    hud.opacity = 0;
    hud.activityIndicatorColor = [UIColor blackColor];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
}

#pragma mark - Preporty

- (NavigationBarView *)navBar {
    if (!_navBar) {
        _navBar = [[NavigationBarView alloc] init];
    }
    return _navBar;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scrollView.bounces = NO;
        _webView.delegate = self;
    }
    return _webView;
}

- (void)setUrl:(NSString *)url {
    if (url && ![url isEqualToString:_url]) {
        _url = url;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
}

@end
