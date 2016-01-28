//
//  OSNWebViewController.m
//  saleclient
//
//  Created by Frank on 16/1/27.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "OSNWebViewController.h"
#import "NavigationBarView.h"
#import "AppDelegate.h"
#import <Masonry.h>
#import <MBProgressHUD.h>

@interface OSNWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *navBar;

@end

@implementation OSNWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.webView];
    [self.navBar addSubview:self.backButton];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(76);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBar).offset(56);
        make.bottom.equalTo(self.navBar).offset(-16);
    }];
}

- (void)goBackHandle:(UIButton *)sender {
    AppDelegate *app = OSNMainDelegate;
    [app.mainNav popViewControllerAnimated:YES];
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

- (UIView *)navBar {
    if (!_navBar) {
        _navBar = [[UIView alloc] init];
    }
    return _navBar;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _backButton.layer.borderWidth = 1;
        _backButton.layer.borderColor = [[UIColor orangeColor] CGColor];
        _backButton.layer.cornerRadius = 5;
        _backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 16, 4, 16);
        
        [_backButton addTarget:self action:@selector(goBackHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
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
