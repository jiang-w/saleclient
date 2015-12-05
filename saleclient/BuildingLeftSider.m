//
//  BuildingLeftSider.m
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "BuildingLeftSider.h"
#import "OSNTagPadView.h"
#import <Masonry.h>

@interface BuildingLeftSider ()

@property(nonatomic, strong) UITextField *keyWordText;
@property(nonatomic, strong) UIButton *searchButton;
@property(nonatomic, strong) OSNTagPadView *tagView;
@property(nonatomic, strong) UILabel *cityLabel;
@property(nonatomic, strong) OSNTagPadView *cityTagView;

@end

@implementation BuildingLeftSider

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.keyWordText];
    [self.keyWordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(36);
    }];
    
    [self.view addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.keyWordText.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(self.keyWordText);
    }];
    
    [self.view addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchButton.mas_bottom).offset(100);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.cityTagView];
    [self.cityTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - property

- (UITextField *)keyWordText {
    if (!_keyWordText) {
        _keyWordText = [[UITextField alloc] init];
        _keyWordText.layer.borderWidth = 1;
        _keyWordText.layer.borderColor = [UIColor orangeColor].CGColor;
        _keyWordText.layer.cornerRadius = 5;
    }
    return _keyWordText;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _searchButton.backgroundColor = RGB(252, 237, 226);
        _searchButton.layer.borderWidth = 1;
        _searchButton.layer.borderColor = [UIColor orangeColor].CGColor;
        _searchButton.layer.cornerRadius = 5;
        [_searchButton addTarget:self action:@selector(searchButtonClickHandel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.font = [UIFont systemFontOfSize:12];
    }
    return _cityLabel;
}

- (OSNTagPadView *)cityTagView {
    if (!_cityTagView) {
        _cityTagView = [[OSNTagPadView alloc] init];
        _cityTagView.backgroundColor = [UIColor yellowColor];
    }
    return _cityTagView;
}


#pragma mark - event

- (void)searchButtonClickHandel:(UIButton *)button {
    
}

@end
