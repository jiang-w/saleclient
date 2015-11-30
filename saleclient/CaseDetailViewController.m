//
//  CaseDetailViewController.m
//  saleclient
//
//  Created by Frank on 15/11/30.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseDetailViewController.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface CaseDetailViewController ()

@property(nonatomic, strong) OSNCaseEntity *caseEntity;
@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UIImageView *caseImage;
@property(nonatomic, strong) UIButton *history;
@property(nonatomic, strong) UIButton *shopping;
@property(nonatomic, strong) UIButton *qCode;
@property(nonatomic, strong) UIButton *notes;

@end

@implementation CaseDetailViewController

- (instancetype)initWithCaseEntity:(OSNCaseEntity *)entity {
    self = [super init];
    if (self) {
        _caseEntity = entity;
    }
    return self;
}

- (void)setSubViewAndLayout {
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(76);
    }];
    
    [navView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView).offset(-16);
        make.left.equalTo(navView).offset(56);
    }];
    
    [self.view addSubview:self.caseImage];
    [self.caseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(40);
        make.width.mas_equalTo(560);
        make.height.mas_equalTo(420);
    }];
    
    [navView addSubview:self.history];
    [self.history mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
        make.right.equalTo(navView).offset(-33);
    }];
    
    [navView addSubview:self.shopping];
    [self.shopping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
        make.right.equalTo(self.history.mas_left).offset(-32);
    }];
    
    [navView addSubview:self.qCode];
    [self.qCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
        make.right.equalTo(self.shopping.mas_left).offset(-32);
    }];
    
    [navView addSubview:self.notes];
    [self.notes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
        make.right.equalTo(self.qCode.mas_left).offset(-32);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 244, 244);
    
    [self setSubViewAndLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - property

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _backBtn.backgroundColor = [UIColor whiteColor];
        _backBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 16, 4, 16);
        _backBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        _backBtn.layer.borderWidth = 1;
        _backBtn.layer.cornerRadius = 5;
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)caseImage {
    if (!_caseImage) {
        _caseImage = [[UIImageView alloc] init];
        _caseImage.backgroundColor = [UIColor whiteColor];
        [_caseImage sd_setImageWithURL:[NSURL URLWithString:self.caseEntity.imagePath]];
    }
    return _caseImage;
}

- (UIButton *)history {
    if (!_history) {
        _history = [UIButton buttonWithType:UIButtonTypeCustom];
        [_history setImage:[UIImage imageNamed:@"historyview_ico.png"] forState:UIControlStateNormal];
    }
    return _history;
}

- (UIButton *)shopping {
    if (!_shopping) {
        _shopping = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shopping setImage:[UIImage imageNamed:@"shopping_ico.png"] forState:UIControlStateNormal];
    }
    return _shopping;
}

- (UIButton *)qCode {
    if (!_qCode) {
        _qCode = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qCode setImage:[UIImage imageNamed:@"qcode_ico.png"] forState:UIControlStateNormal];
    }
    return _qCode;
}

- (UIButton *)notes {
    if (!_notes) {
        _notes = [UIButton buttonWithType:UIButtonTypeCustom];
        [_notes setImage:[UIImage imageNamed:@"history_ico.png"] forState:UIControlStateNormal];
    }
    return _notes;
}


#pragma mark - event

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
