//
//  AddressPickerView.m
//  saleclient
//
//  Created by Frank on 16/1/25.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "AddressPickerView.h"
#import "AddressPickerViewModel.h"
#import <Masonry.h>

@interface AddressPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *buttonPanel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIPickerView *pickerView;

//@property (nonatomic, strong) NSString *provinceCode;
//@property (nonatomic, strong) NSString *cityCode;
//@property (nonatomic, strong) NSString *areaCode;
@property (nonatomic, strong) AddressPickerViewModel *model;

@end

@implementation AddressPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _model = [[AddressPickerViewModel alloc] init];
        [self initAndLayoutSubview];
    }
    return self;
}

- (void)setProvinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode andCountyCode:(NSString *)countyCode {
    self.model = [[AddressPickerViewModel alloc] initWithProvinceCode:provinceCode cityCode:cityCode andCountyCode:countyCode];
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:self.model.selectedProvinceIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:self.model.selectedCityIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:self.model.selectedCountyIndex inComponent:2 animated:NO];
}

- (void)initAndLayoutSubview {
    [self addSubview:self.buttonPanel];
    [self.buttonPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [self.buttonPanel addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buttonPanel).offset(20);
        make.centerY.equalTo(self.buttonPanel);
        make.width.mas_equalTo(60);
    }];
    
    [self.buttonPanel addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buttonPanel).offset(-20);
        make.centerY.equalTo(self.buttonPanel);
        make.width.mas_equalTo(60);
    }];
    
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonPanel.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = RGB(204, 204, 202).CGColor;
    self.layer.cornerRadius = 5;
}


#pragma mark - Perporty

- (UIView *)buttonPanel {
    if (!_buttonPanel) {
        _buttonPanel = [[UIView alloc] init];
        _buttonPanel.backgroundColor = [UIColor whiteColor];
    }
    return _buttonPanel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_saveButton setTitle:@"完成" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_saveButton addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = RGB(242, 242, 242);
    }
    return _pickerView;
}

- (NSString *)description {
    NSString *provinceName = self.model.province != nil? self.model.province.name : @"";
    NSString *cityName = self.model.city != nil? self.model.city.name : @"";
    NSString *countyName = self.model.county != nil? self.model.county.name : @"";
    return [NSString stringWithFormat:@"%@ %@ %@", provinceName, cityName, countyName];
}


#pragma mark - Event

- (void)clickCancelButton:(UIButton *)sender {
    self.hidden = YES;
}

- (void)clickSaveButton:(UIButton *)sender {
    if (self.block) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if (self.model.province) {
            userInfo[@"province"] = self.model.province.code;
            userInfo[@"provinceName"] = self.model.province.name;
        }
        if (self.model.city) {
            userInfo[@"city"] = self.model.city.code;
            userInfo[@"cityName"] = self.model.city.name;
        }
        if (self.model.county) {
            userInfo[@"county"] = self.model.county.code;
            userInfo[@"countyName"] = self.model.county.name;
        }
        self.block(self, userInfo);
    }
}


#pragma mark - Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.model.provinceArray.count;
        case 1:
            return self.model.cityArray.count;
        case 2:
            return self.model.countyArray.count;
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    RegionModel *regionModel;
    switch (component) {
        case 0:
            regionModel = [self.model.provinceArray objectAtIndex:row];
            break;
        case 1:
            regionModel = [self.model.cityArray objectAtIndex:row];
            break;
        case 2:
            regionModel = [self.model.countyArray objectAtIndex:row];
            break;
        default:
            regionModel =  nil;
            break;
    }
    if (regionModel) {
        return regionModel.name;
    }
    else {
        return @"";
    }
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
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.model.selectedProvinceIndex = row;
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:self.model.selectedCityIndex inComponent:1 animated:YES];
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:self.model.selectedCountyIndex inComponent:2 animated:YES];
            break;
        case 1:
            self.model.selectedCityIndex = row;
            [self.pickerView reloadComponent:2];
            [self.pickerView selectRow:self.model.selectedCountyIndex inComponent:2 animated:YES];
            break;
        case 2:
            self.model.selectedCountyIndex = row;
            break;
        default:
            break;
    }
}

@end
