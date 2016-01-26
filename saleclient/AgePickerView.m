//
//  AgePickerView.m
//  saleclient
//
//  Created by Frank on 16/1/26.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "AgePickerView.h"
#import <Masonry.h>

@interface AgePickerView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation AgePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _data = @[@{@"description": @"20 ~ 30岁", @"code": @"9513"},
                  @{@"description": @"30 ~ 40岁", @"code": @"9514"},
                  @{@"description": @"40 ~ 50岁", @"code": @"9515"},
                  @{@"description": @"50 ~ 60岁", @"code": @"9516"},
                  @{@"description": @"60岁以上", @"code": @"9517"}];
        [self initAndLayoutSubview];
    }
    return self;
}

- (void)initAndLayoutSubview {
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.mas_equalTo(60);
        make.right.equalTo(self).offset(-10);
    }];
    
    self.layer.borderColor = RGB(204, 204, 202).CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.data[row][@"description"];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 7.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:13]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *selData = self.data[row];
    if (self.didSelectBlock) {
        self.didSelectBlock(self, selData);
    }
}


#pragma mark - Event

- (void)clickCancelButton:(UIButton *)sender {
    if (self.dissmissBlock) {
        self.dissmissBlock(self);
    }
}

#pragma mark - Property

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = RGB(242, 242, 242);
    }
    return _pickerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"隐藏" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)setAgeCode:(NSString *)ageCode {
    for (int i = 0; i < self.data.count; i++) {
        NSString *code = self.data[i][@"code"];
        if ([code isEqualToString:ageCode]) {
            [self.pickerView selectRow:i inComponent:0 animated:NO];
            if (self.didSelectBlock) {
                self.didSelectBlock(self, self.data[i]);
            }
            return;
        }
    }
}

@end
