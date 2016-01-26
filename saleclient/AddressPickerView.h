//
//  AddressPickerView.h
//  saleclient
//
//  Created by Frank on 16/1/25.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressPickerView;

typedef void (^AddressPickerViewConfirmBlock)(AddressPickerView *view, NSDictionary *userInfo);

@interface AddressPickerView : UIView

@property (nonatomic, weak, readonly) NSString *description;

@property (nonatomic, copy) AddressPickerViewConfirmBlock block;

- (void)setProvinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode andCountyCode:(NSString *)countyCode;

@end
