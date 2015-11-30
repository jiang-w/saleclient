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
        make.bottom.equalTo(navView).offset(-10);
        make.left.equalTo(navView).offset(60);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(26);
    }];
    
    [self.view addSubview:self.caseImage];
    [self.caseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(40);
        make.width.mas_equalTo(560);
        make.height.mas_equalTo(420);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
        [_backBtn setImage:[UIImage imageNamed:@"navbtn_back_hov.png"] forState:UIControlStateNormal];
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


#pragma mark - event

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
