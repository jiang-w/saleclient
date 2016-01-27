//
//  BuildingPickerView.m
//  saleclient
//
//  Created by Frank on 16/1/27.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "BuildingPickerView.h"
#import "OSNBuildingManager.h"
#import <Masonry.h>

@interface BuildingPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *buildingArray;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation BuildingPickerView
{
    OSNBuildingManager *_manager;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _manager = [[OSNBuildingManager alloc] init];
        _buildingArray = [NSArray array];
        [self initViewAndLayout];
    }
    return self;
}

- (void)setProvinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode andCountyCode:(NSString *)countyCode {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"provinceId"] = provinceCode;
    paramters[@"cityId"] = cityCode;
    paramters[@"areaId"] = countyCode;
    self.buildingArray = [_manager getBuildingListWithParameters:paramters];
    [self.pickerView reloadAllComponents];
}

- (void)initViewAndLayout {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.layer.borderColor = RGB(204, 204, 202).CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.buildingArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    OSNBuildingEntity *entity = self.buildingArray[row];
    return entity.buildingName;
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
    OSNBuildingEntity *entity = self.buildingArray[row];
    if (self.didSelectBlock) {
        self.didSelectBlock(self, entity);
    }
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = RGB(242, 242, 242);
    }
    return _pickerView;
}

@end
