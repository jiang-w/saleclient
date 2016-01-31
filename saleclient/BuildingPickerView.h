//
//  BuildingPickerView.h
//  saleclient
//
//  Created by Frank on 16/1/27.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuildingPickerView;
typedef void (^BuildingPickerViewdidSelectBlock)(BuildingPickerView *view, id obj);

@interface BuildingPickerView : UIView

@property (nonatomic, copy) BuildingPickerViewdidSelectBlock didSelectBlock;

- (void)setProvinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode andCountyCode:(NSString *)countyCode;

- (void)setProvinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode countyCode:(NSString *)countyCode andBuildingId:(NSString *)buildingId;

@end
