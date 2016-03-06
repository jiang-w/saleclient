//
//  CustomerBookingVC.m
//  saleclient
//
//  Created by Frank on 16/3/5.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "CustomerBookingVC.h"
#import "BookingDatePickerView.h"

@interface CustomerBookingVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *recordListView;
@property (nonatomic, strong) BookingDatePickerView *datePicker;

@end

@implementation CustomerBookingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordListView.dataSource = self;
    self.recordListView.delegate = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDateLabel:)];
    [self.dateLabel addGestureRecognizer:tapRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self.view addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(2);
        make.left.right.equalTo(self.dateLabel);
        make.height.mas_offset(200);
    }];
}


- (IBAction)clickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapDateLabel:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    self.datePicker.hidden = NO;
    self.dateLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日 %@",
                           self.datePicker.selectedYear,
                           self.datePicker.selectedMonth,
                           self.datePicker.selectedDay,
                           self.datePicker.selectedTime];
    self.dateLabel.textColor = [UIColor blackColor];
}

- (void)tapBackgroundView:(UITapGestureRecognizer *)recognizer {
    self.datePicker.hidden = YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = RGB(249, 249, 249);
    UILabel *title1 = [[UILabel alloc] init];
    title1.font = [UIFont systemFontOfSize:14];
    title1.text = @"量房日期";
    [header addSubview:title1];
    UILabel *title2 = [[UILabel alloc] init];
    title2.font = [UIFont systemFontOfSize:14];
    title2.text = @"量房时间";
    [header addSubview:title2];
    UILabel *title3 = [[UILabel alloc] init];
    title3.font = [UIFont systemFontOfSize:14];
    title3.text = @"接待导购";
    [header addSubview:title3];
    
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header);
        make.left.equalTo(header).offset(60);
    }];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(header);
    }];
    [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header);
        make.right.equalTo(header).offset(-60);
    }];
    
    return header;
}


#pragma mark - Property

- (BookingDatePickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[BookingDatePickerView alloc] init];
        _datePicker.backgroundColor = RGB(229, 229, 229);
        _datePicker.hidden = YES;
    }
    return _datePicker;
}

@end
