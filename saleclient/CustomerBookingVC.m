//
//  CustomerBookingVC.m
//  saleclient
//
//  Created by Frank on 16/3/5.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "CustomerBookingVC.h"
#import "BookingDatePickerView.h"
#import "OSNCustomerManager.h"
#import "CustomerBookingCell.h"

@interface CustomerBookingVC () <UITableViewDelegate, UITableViewDataSource, BookingDatePickerViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *recordListView;
@property (weak, nonatomic) IBOutlet UITextField *remarkText;
@property (nonatomic, strong) BookingDatePickerView *datePicker;
@property (nonatomic, strong) NSMutableArray *reservationList;
@property (nonatomic, strong) NSMutableDictionary *timeZoneDic;

@end

@implementation CustomerBookingVC

static NSString * const cellReuseIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordListView.dataSource = self;
    self.recordListView.delegate = self;
    self.recordListView.bounces = NO;
    self.remarkText.delegate = self;
    
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
    
    self.timeZoneDic = [NSMutableDictionary dictionary];
    OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
    for (NSDictionary *item in [manager getReservationTimeZone]) {
        self.timeZoneDic[item[@"enumId"]] = item[@"description"];
    }
    
    [self loadCustomerReservationList];
}

- (void)loadCustomerReservationList {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
        NSArray *data = [manager getReservationListWithCustomerId:self.customerId];

        if (data) {
            __weak __typeof__(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.reservationList removeAllObjects];
                [weakSelf.reservationList addObjectsFromArray:data];
                [self.recordListView reloadData];
            });
        }
    });
}


#pragma mark - Event

- (IBAction)clickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapDateLabel:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    self.datePicker.hidden = NO;
    self.dateLabel.text = self.datePicker.description;
    self.dateLabel.textColor = [UIColor blackColor];
}

- (void)tapBackgroundView:(UITapGestureRecognizer *)recognizer {
    self.datePicker.hidden = YES;
}

- (IBAction)clickAddButton:(id)sender {
    [self.view endEditing:YES];
    self.datePicker.hidden = YES;
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-M-d"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",
                               self.datePicker.selectedYear, self.datePicker.selectedMonth, (long)self.datePicker.selectedDay]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    paramters[@"customerId"] = self.customerId;
    paramters[@"reservationDate"] = [formatter stringFromDate:date];
    paramters[@"reservationTimeId"] = self.datePicker.selectedTime;
    paramters[@"guideRemark"] = self.remarkText.text;
    OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
    BOOL seccuss = [manager addCustomerReservationWithParamters:paramters];
    if (seccuss) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"预约成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"预约失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self loadCustomerReservationList];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.datePicker.hidden = YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reservationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerBookingCell *cell = (CustomerBookingCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[CustomerBookingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    NSDictionary *dic = self.reservationList[indexPath.row];
    cell.dateLabel.text = dic[@"reservationDate"];
    cell.timeLabel.text = dic[@"reservationTime"];
    cell.guideNameLabel.text = dic[@"guideName"];
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

#pragma mark - UITableViewDataSource

- (void)didFinishSelectDatePicker:(BookingDatePickerView *)view {
    self.dateLabel.text = view.description;
}


#pragma mark - Property

- (BookingDatePickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[BookingDatePickerView alloc] init];
        _datePicker.backgroundColor = RGB(229, 229, 229);
        _datePicker.hidden = YES;
        _datePicker.delegate = self;
    }
    return _datePicker;
}

- (NSMutableArray *)reservationList {
    if (!_reservationList) {
        _reservationList = [NSMutableArray array];
    }
    return _reservationList;
}

@end
