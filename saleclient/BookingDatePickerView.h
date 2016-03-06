//
//  BookingDatePickerView.h
//  saleclient
//
//  Created by Frank on 16/3/5.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingDatePickerView : UIView

@property (nonatomic, assign) NSInteger selectedYear;
@property (nonatomic, assign) NSInteger selectedMonth;
@property (nonatomic, assign) NSInteger selectedDay;
@property (nonatomic, strong) NSString *selectedTime;

@end
