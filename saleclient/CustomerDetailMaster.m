//
//  CustomerDetailMaster.m
//  saleclient
//
//  Created by Frank on 15/12/29.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CustomerDetailMaster.h"
#import "AutoLayoutTagView.h"
#import "OSNNetworkService.h"
#import <Masonry.h>

@interface CustomerDetailMaster () <AutoLayoutTagViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSString          *customerId;
@property (nonatomic, strong) AutoLayoutTagView *tagView;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UILabel           *titlelabel;
@property (nonatomic, strong) UIButton          *backButton;
@property (nonatomic, strong) NSArray           *tags;
@property (nonatomic, strong) UIWebView         *contentView;

@end

@implementation CustomerDetailMaster

- (instancetype)initWithCustomerId:(NSString *)customerId {
    self = [super init];
    if (self) {
        _customerId = customerId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tags = @[@{@"title": @"基础资料", @"dataUrl": @"ViewCustomerDetailInfo"},
                  @{@"title": @"跟进记录", @"dataUrl": @"ListCustomerFollowUp"},
                  @{@"title": @"方案记录", @"dataUrl": @"ListViewCustCase"},
                  @{@"title": @"收藏记录", @"dataUrl": @"ListCustomerCollectGoodsRecord"},
                  @{@"title": @"订单记录", @"dataUrl": @"ListCustomerOrder"},
                  @{@"title": @"状态更改日志", @"dataUrl": @"ListViewCustomerStatusLog"},
                  @{@"title": @"回访记录", @"dataUrl": @"ListViewCustVisitRecord"},
                  @{@"title": @"量尺记录", @"dataUrl": @"ListViewCustAmountRecord"},
                  @{@"title": @"报价单", @"dataUrl": @"ListMallShoppingCartQuote"},
                  @{@"title": @"接待记录", @"dataUrl": @"ListViewCustomerReceptionRecord"}];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(76);
        make.left.equalTo(self.view).offset(-1);
        make.right.equalTo(self.view).offset(1);
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.titlelabel];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.tagView.mas_top).offset(-20);
    }];
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tagView.mas_top).offset(-14);
        make.left.equalTo(self.view).offset(56);
    }];
    
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView);
    }];
}


#pragma mark - property

- (AutoLayoutTagView *)tagView {
    if (!_tagView) {
        _tagView = [[AutoLayoutTagView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.padding = UIEdgeInsetsMake(1, 0, 1, 0);
        _tagView.tagSpace = 0;
        _tagView.lineSpace = 0;
        _tagView.layer.borderColor = [UIColor grayColor].CGColor;
        _tagView.layer.borderWidth = 1;
        
        [_tagView setTagButtonStyleWithBlock:^(UIButton *button, NSUInteger index) {
            button.layer.borderWidth = 0;
            button.layer.cornerRadius = 0;
            button.frame = CGRectMake(0, 0, 102, 40);
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }];
        
        _tagView.delegate = self;
    }
    return _tagView;
}

- (void)setTags:(NSArray *)tags {
    if (_tags != tags) {
        _tags = tags;
        [self.tagView removeAllTags];
        for (NSDictionary *tag in _tags) {
            [self.tagView addTagWithTitle:tag[@"title"]];
        }
        
        if (_tags.count > 0) {
            self.tagView.selectedIndex = 0;
        }
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UILabel *)titlelabel {
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] init];
        _titlelabel.text = @"客户详细信息";
        _titlelabel.textColor = [UIColor blackColor];
        _titlelabel.font = [UIFont systemFontOfSize:18];
    }
    return _titlelabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _backButton.layer.borderColor = [UIColor orangeColor].CGColor;
        _backButton.layer.borderWidth = 1;
        _backButton.layer.cornerRadius = 5;
        _backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 20, 4, 20);
        
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIWebView *)contentView {
    if (!_contentView) {
        _contentView = [[UIWebView alloc] init];
    }
    return _contentView;
}


#pragma mark - AutoLayoutTagViewDelegate

- (void)autoLayoutTagView:(AutoLayoutTagView *)view didSelectTagButton:(UIButton *)button andIndex:(NSUInteger)index {
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor orangeColor];
    [button addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(3);
        make.bottom.left.right.equalTo(button);
    }];
    
    // 加载web
    NSString *url = [NSString stringWithFormat:@"%@%@?customerId=%@", CRMURL, [self.tags[index] objectForKey:@"dataUrl"], self.customerId];
    OSNNetworkService *service = [[OSNNetworkService alloc] init];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [service syncPostRequest:url parameters:nil returnResponse:&response error:&error];
    NSString *contentHtml = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSString *htmlText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ContentView" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    htmlText = [htmlText stringByReplacingOccurrencesOfString:@"{{content}}" withString:contentHtml];
    [self.contentView loadHTMLString:htmlText baseURL:nil];
//    [self.contentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)autoLayoutTagView:(AutoLayoutTagView *)view disSelectTagButton:(UIButton *)button andIndex:(NSUInteger)index {
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    for (UIView *sub in button.subviews) {
        if (![sub isKindOfClass:[UILabel class]]) {
            [sub removeFromSuperview];
        }
    }
}


#pragma mark - event

- (void)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
