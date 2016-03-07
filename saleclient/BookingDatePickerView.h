//
//  BookingDatePickerView.h
//  saleclient
//
//  Created by Frank on 16/3/5.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookingDatePickerView;

@protocol BookingDatePickerViewDelegate <NSObject>

@optional
- (void)didFinishSelectDatePicker:(BookingDatePickerView *)view;

@end

@interface BookingDatePickerView : UIView

@property (nonatomic, assign) NSInteger selectedYear;
@property (nonatomic, assign) NSInteger selectedMonth;
@property (nonatomic, assign) NSInteger selectedDay;
@property (nonatomic, strong) NSString *selectedTime;

@property (nonatomic, weak) id<BookingDatePickerViewDelegate> delegate;

@end
