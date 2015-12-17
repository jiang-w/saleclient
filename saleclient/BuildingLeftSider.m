//
//  BuildingLeftSider.m
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "BuildingLeftSider.h"
#import "OSNBuildingManager.h"
#import "OSNUserManager.h"

@interface BuildingLeftSider ()

@property(nonatomic, strong) UITextField *keyWordText;
@property(nonatomic, strong) UIButton *searchButton;
@property(nonatomic, strong) UILabel *cityLabel;
@property(nonatomic, strong) AutoLayoutTagView *cityTagView;
@property(nonatomic, strong) NSMutableArray *areaList;

@end

@implementation BuildingLeftSider

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _areaList = [NSMutableArray array];
    [self layoutSubview];
    [self loadAreaTagData];
}

- (void)layoutSubview {
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
        make.top.equalTo(self.cityLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
    }];
}

- (void)loadAreaTagData {
    OSNBuildingManager *manager = [[OSNBuildingManager alloc] init];
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("loadCityArea", nil);
    dispatch_async(queue, ^{
        NSArray *areas = [manager getCityAreaList];
        [weakSelf.areaList removeAllObjects];
        [weakSelf.areaList addObjectsFromArray:areas];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.cityTagView removeAllTags];
            [weakSelf.areaList enumerateObjectsUsingBlock:^(OSNAreaEntity *obj, NSUInteger idx, BOOL *stop) {
                [weakSelf.cityTagView addTagWithTitle:obj.areaName];
            }];
            if (weakSelf.areaList.count > 0) {
                weakSelf.cityTagView.selectedIndex = 0;
            }
        });
    });
}

#pragma mark - property

- (UITextField *)keyWordText {
    if (!_keyWordText) {
        _keyWordText = [[UITextField alloc] init];
        _keyWordText.layer.borderWidth = 1;
        _keyWordText.layer.borderColor = [UIColor orangeColor].CGColor;
        _keyWordText.layer.cornerRadius = 5;
        _keyWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _keyWordText.placeholder = @"请输入楼盘信息";
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
        _cityLabel.font = [UIFont systemFontOfSize:14];
        _cityLabel.text = [NSString stringWithFormat:@"所在城市：%@", [OSNUserManager sharedInstance].currentUser.cityName];
    }
    return _cityLabel;
}

- (AutoLayoutTagView *)cityTagView {
    if (!_cityTagView) {
        _cityTagView = [[AutoLayoutTagView alloc] init];
        _cityTagView.padding = UIEdgeInsetsMake(10, 20, 10, 20);
        [_cityTagView setTagButtonStyleWithBlock:^(UIButton *button, NSUInteger index) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor whiteColor];
            button.contentEdgeInsets = UIEdgeInsetsMake(6, 4, 6, 4);
            button.layer.borderColor = [UIColor blackColor].CGColor;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 5;
            button.frame = CGRectMake(0, 0, 105, 30);
        }];
        _cityTagView.delegate = self;
    }
    return _cityTagView;
}


#pragma mark - event

- (void)searchButtonClickHandel:(UIButton *)button {
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(didSelectArea:andKeyword:)]) {
            [self.delegate didSelectArea:self.areaList[self.cityTagView.selectedIndex] andKeyword:self.keyWordText.text];
        }
    }
}

- (void)autoLayoutTagView:(AutoLayoutTagView *)view didSelectTagButton:(UIButton *)button andIndex:(NSUInteger)index {
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(didSelectArea:andKeyword:)]) {
            [self.delegate didSelectArea:self.areaList[index] andKeyword:@""];
        }
    }
}

- (void)autoLayoutTagView:(AutoLayoutTagView *)view disSelectTagButton:(UIButton *)button andIndex:(NSUInteger)index {
    button.layer.borderColor = [UIColor blackColor].CGColor;
}

@end
