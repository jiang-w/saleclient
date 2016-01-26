//
//  AddressPickerViewModel.h
//  saleclient
//
//  Created by Frank on 16/1/25.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegionModel.h"

@interface AddressPickerViewModel : NSObject

@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSArray *countyArray;

@property (nonatomic, assign) NSUInteger selectedProvinceIndex;
@property (nonatomic, assign) NSUInteger selectedCityIndex;
@property (nonatomic, assign) NSUInteger selectedCountyIndex;

@property (nonatomic, strong, readonly) RegionModel *province;
@property (nonatomic, strong, readonly) RegionModel *city;
@property (nonatomic, strong, readonly) RegionModel *county;

- (instancetype)initWithProvinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode andCountyCode:(NSString *)countyCode;

@end
