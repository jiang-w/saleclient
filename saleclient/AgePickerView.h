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
typedef void (^AgePickerViewDissmissBlock)(AgePickerView *view);

@interface AgePickerView : UIView

@property (nonatomic, copy) AgePickerViewdidSelectBlock didSelectBlock;
@property (nonatomic, copy) AgePickerViewDissmissBlock dissmissBlock;

- (void)setAgeCode:(NSString *)ageCode;

@end
