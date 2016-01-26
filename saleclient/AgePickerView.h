//
//  AgePickerView.h
//  saleclient
//
//  Created by Frank on 16/1/26.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AgePickerView;
typedef void (^AgePickerViewdidSelectBlock)(AgePickerView *view, NSDictionary *userInfo);

@interface AgePickerView : UIView

@property (nonatomic, copy) AgePickerViewdidSelectBlock block;

- (void)setAgeCode:(NSString *)ageCode;
- (void)show;
- (void)hidden;

@end
