//
//  BookingDatePickerView.m
//  saleclient
//
//  Created by Frank on 16/3/5.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "BookingDatePickerView.h"
#import "OSNCustomerManager.h"

#define NUMBER_OF_YEARS 2

@interface BookingDatePickerView() <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *timeZonelArray;

@end

@implementation BookingDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAndLayoutSubview];
        [self loadReservationTimeZone];
    }
    return self;
}

- (void)initAndLayoutSubview {
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    self.selectedYear = dateComponent.year;
    self.selectedMonth = dateComponent.month;
    self.selectedDay = dateComponent.day;
}

- (void)loadReservationTimeZone {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
        NSArray *data = [manager getReservationTimeZone];
        if (data) {
            __weak __typeof__(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                for (NSDictionary *item in data) {
                    NSString *key = item[@"enumId"];
                    NSString *description = item[@"description"];
                    [weakSelf.timeZonelArray addObject:@{key: description}];
                }
                [weakSelf.pickerView reloadComponent:3];
            });
        }
    });
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger number = 0;
    switch (component) {
        case 0:
            number = NUMBER_OF_YEARS;
            break;
        case 1:
            number = 12;
            break;
        case 2:
            number = [self daysForMonth:self.selectedMonth andYear:self.selectedYear];
            break;
        case 3:
            number = self.timeZonelArray.count;
            break;
        default:
            break;
    }
    return number;
}


#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = 0;
    switch (component) {
        case 0:
            width = pickerView.frame.size.width * 0.25;
            break;
        case 1:
            width = pickerView.frame.size.width * 0.15;
            break;
        case 2:
            width = pickerView.frame.size.width * 0.15;
            break;
        case 3:
            width = pickerView.frame.size.width * 0.45;
            break;
        default:
            break;
    }
    return width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel *)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:13]];
    }

    switch (component) {
        case 0:
            pickerLabel.text = [NSString stringWithFormat:@"%ld年", [self getYearWithSelectedRow:row]];
            break;
        case 1:
            pickerLabel.text = [NSString stringWithFormat:@"%ld月", row+1];
            break;
        case 2:
            pickerLabel.text = [NSString stringWithFormat:@"%ld日", row+1];
            break;
        case 3: {
            NSDictionary *dic = self.timeZonelArray[row];
            pickerLabel.text = [[dic allValues] firstObject];
            break;
        }
        default:
            break;
    }
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        case 1:
            [pickerView reloadComponent:2];
            break;
        case 2:
            break;
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishSelectDatePicker:)]) {
        [self.delegate didFinishSelectDatePicker:self];
    }
}


#pragma mark - Private

- (NSInteger)daysForMonth:(NSInteger)month andYear:(NSInteger)year {
    int days=0;
    switch(month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            days=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            days=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                days=29;
                break;
            }
            else
            {
                days=28;
                break;
            }
        }
        default:
            break;
    }
    return days;
}

- (NSInteger)getYearWithSelectedRow:(NSInteger)row {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger sinceYear = dateComponent.year - (NUMBER_OF_YEARS - 1) / 2;
    return sinceYear + row;
}

- (NSInteger)getSelectedRowWithYear:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger sinceYear = dateComponent.year - (NUMBER_OF_YEARS - 1) / 2;
    if (year >= sinceYear) {
        return year - sinceYear;
    }
    else {
        return 0;
    }
}


#pragma mark - Property

- (NSInteger)selectedYear {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    return [self getYearWithSelectedRow:selectedRow];
}

- (void)setSelectedYear:(NSInteger)selectedYear {
    NSInteger selectedRow = [self getSelectedRowWithYear:selectedYear];
    [self.pickerView selectRow:selectedRow inComponent:0 animated:NO];
}

- (NSInteger)selectedMonth {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:1];
    return selectedRow + 1;
}

- (void)setSelectedMonth:(NSInteger)selectedMonth {
    [self.pickerView selectRow:selectedMonth - 1 inComponent:1 animated:NO];
}

- (NSInteger)selectedDay {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:2];
    return selectedRow + 1;
}

- (void)setSelectedDay:(NSInteger)selectedDay {
    [self.pickerView selectRow:selectedDay - 1 inComponent:2 animated:NO];
}

- (NSString *)selectedTime {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:3];
    NSDictionary *dic = self.timeZonelArray[selectedRow];
    return [[dic allKeys] firstObject];
}

- (void)setSelectedTime:(NSString *)selectedTime {
    for (NSDictionary *item in self.timeZonelArray) {
        NSString *key = [[item allKeys] firstObject];
        if ([key isEqualToString:selectedTime]) {
            NSInteger selectedRow = [self.timeZonelArray indexOfObject:item];
            [self.pickerView selectRow:selectedRow inComponent:3 animated:NO];
            break;
        }
    }
}

- (NSString *)description {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:3];
    NSString *timeDescription = [[self.timeZonelArray[selectedRow] allValues] firstObject];
    return [NSString stringWithFormat:@"%ld年%ld月%ld日 %@", self.selectedYear, self.selectedMonth, self.selectedDay, timeDescription];
}

- (NSMutableArray *)timeZonelArray {
    if (!_timeZonelArray) {
        _timeZonelArray = [NSMutableArray array];
    }
    return _timeZonelArray;
}

@end
