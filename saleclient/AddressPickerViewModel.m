//
//  AddressPickerViewModel.m
//  saleclient
//
//  Created by Frank on 16/1/25.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "AddressPickerViewModel.h"

@implementation AddressPickerViewModel
{
    NSDictionary *_provinceDic;
    NSDictionary *_cityDic;
    NSDictionary *_countyDic;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithProvinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode andCountyCode:(NSString *)countyCode {
    if (self = [super init]) {
        [self initData];
        for (int i = 0; i < self.provinceArray.count; i++) {
            RegionModel *province = self.provinceArray[i];
            if ([province.code isEqualToString:provinceCode]) {
                self.selectedProvinceIndex = i;
            }
        }
        
        for (int i = 0; i < self.cityArray.count; i++) {
            RegionModel *city = self.cityArray[i];
            if ([city.code isEqualToString:cityCode]) {
                self.selectedCityIndex = i;
            }
        }
        
        for (int i = 0; i < self.countyArray.count; i++) {
            RegionModel *county = self.countyArray[i];
            if ([county.code isEqualToString:countyCode]) {
                self.selectedCountyIndex = i;
            }
        }
    }
    return self;
}

- (void)initData {
    NSDictionary *dataDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AreaPlist.plist" ofType:nil]];
    NSString *province = dataDic[@"province"];
    NSArray *arr = [province componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *itm in arr) {
        if (itm.length > 0) {
            NSArray *pair = [itm componentsSeparatedByString:@"|"];
            if (pair.count == 2) {
                [dic setObject:pair[1] forKey:pair[0]];
            }
        }
    }
    _provinceDic = [NSDictionary dictionaryWithDictionary:dic];
    
    dic = [NSMutableDictionary dictionary];
    NSString *city = dataDic[@"city"];
    arr = [city componentsSeparatedByString:@","];
    for (NSString *itm in arr) {
        if (itm.length > 0) {
            NSArray *pair = [itm componentsSeparatedByString:@"|"];
            if (pair.count == 2) {
                [dic setObject:pair[1] forKey:pair[0]];
            }
        }
    }
    _cityDic = [NSDictionary dictionaryWithDictionary:dic];
    
    dic = [NSMutableDictionary dictionary];
    NSString *area = dataDic[@"area"];
    arr = [area componentsSeparatedByString:@","];
    for (NSString *itm in arr) {
        if (itm.length > 0) {
            NSArray *pair = [itm componentsSeparatedByString:@"|"];
            if (pair.count == 2) {
                [dic setObject:pair[1] forKey:pair[0]];
            }
        }
    }
    _countyDic = [NSDictionary dictionaryWithDictionary:dic];
    
    self.provinceArray = [self getProvinceArray];
    self.selectedProvinceIndex = 0;
}


- (void)setProvinceCode:(NSString *)provinceCode {
    for (int i = 0; i < self.provinceArray.count; i++) {
        RegionModel *province = self.provinceArray[i];
        if ([province.code isEqualToString:provinceCode]) {
            [self setSelectedProvinceIndex:i];
        }
    }
}

- (void)setCityCode:(NSString *)cityCode {
    for (int i = 0; i < self.cityArray.count; i++) {
        RegionModel *city = self.cityArray[i];
        if ([city.code isEqualToString:cityCode]) {
            [self setSelectedCityIndex:i];
        }
    }
}

- (void)setCountyCode:(NSString *)countyCode {
    for (int i = 0; i < self.countyArray.count; i++) {
        RegionModel *county = self.countyArray[i];
        if ([county.code isEqualToString:countyCode]) {
            [self setSelectedCountyIndex:i];
        }
    }
}

- (RegionModel *)province {
    if (self.provinceArray.count > self.selectedProvinceIndex) {
        RegionModel *region = self.provinceArray[self.selectedProvinceIndex];
        return region;
    }
    else {
        return nil;
    }
}

- (RegionModel *)city {
    if (self.cityArray.count > self.selectedCityIndex) {
        RegionModel *region = self.cityArray[self.selectedCityIndex];
        return region;
    }
    else {
        return nil;
    }
}

- (RegionModel *)county {
    if (self.countyArray.count > self.selectedCountyIndex) {
        RegionModel *region = self.countyArray[self.selectedCountyIndex];
        return region;
    }
    else {
        return nil;
    }
}


#pragma mark - Private Method

- (NSArray *)getProvinceArray {
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *keyArr = [_provinceDic.allKeys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSInteger val1 = [obj1 integerValue];
        NSInteger val2 = [obj2 integerValue];
        if (val2 > val1) {
            return NSOrderedAscending;
        }
        else if (val1 > val2) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedAscending;
        }
    }];
    for (NSString *key in keyArr) {
        RegionModel *region = [[RegionModel alloc] init];
        region.code = key;
        region.name = _provinceDic[key];
        [arr addObject:region];
    }
    return arr;
}

- (NSArray *)getCityArrayWithProvinceCode:(NSString *)code {
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *cityDictionary = [NSMutableDictionary dictionary];
    NSArray *cityCodes = [_cityDic allKeys];
    NSRange range = NSMakeRange(0, 2);
    for (NSString *item in cityCodes) {
        if ([[item substringWithRange:range] isEqualToString:[code substringWithRange:range]]) {
            [cityDictionary setObject:_cityDic[item] forKey:item];
        }
    }
    
    NSArray *keyArr = [cityDictionary.allKeys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSInteger val1 = [obj1 integerValue];
        NSInteger val2 = [obj2 integerValue];
        if (val2 > val1) {
            return NSOrderedAscending;
        }
        else if (val1 > val2) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedAscending;
        }
    }];
    for (NSString *key in keyArr) {
        RegionModel *region = [[RegionModel alloc] init];
        region.code = key;
        region.name = _cityDic[key];
        [arr addObject:region];
    }
    return arr;
}

- (NSArray *)getCountyArrayWithCityCode:(NSString *)code {
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *countyDictionary = [NSMutableDictionary dictionary];
    NSArray *countyCodes = [_countyDic allKeys];
    NSRange range = NSMakeRange(0, 4);
    for (NSString *item in countyCodes) {
        if ([[item substringWithRange:range] isEqualToString:[code substringWithRange:range]]) {
            [countyDictionary setObject:_countyDic[item] forKey:item];
        }
    }
    
    NSArray *keyArr = [countyDictionary.allKeys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSInteger val1 = [obj1 integerValue];
        NSInteger val2 = [obj2 integerValue];
        if (val2 > val1) {
            return NSOrderedAscending;
        }
        else if (val1 > val2) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedAscending;
        }
    }];
    for (NSString *key in keyArr) {
        RegionModel *region = [[RegionModel alloc] init];
        region.code = key;
        region.name = _countyDic[key];
        [arr addObject:region];
    }
    return arr;
}

- (void)setSelectedProvinceIndex:(NSUInteger)index {
    if (index < self.provinceArray.count) {
        _selectedProvinceIndex = index;
        RegionModel *province = self.provinceArray[index];
        self.cityArray = [self getCityArrayWithProvinceCode:province.code];
        if (self.cityArray.count == 0) {
            self.countyArray = [NSArray array];
        }
        self.selectedCityIndex = 0;
    }
}

- (void)setSelectedCityIndex:(NSUInteger)index {
    if (index < self.cityArray.count) {
        _selectedCityIndex = index;
        RegionModel *city = self.cityArray[index];
        self.countyArray = [self getCountyArrayWithCityCode:city.code];
        self.selectedCountyIndex = 0;
    }
}

- (void)setSelectedCountyIndex:(NSUInteger)index {
    if (index < self.countyArray.count) {
        _selectedCountyIndex = index;
    }
}

@end
