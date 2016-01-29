//
//  CustomerAddressManagerVC.m
//  saleclient
//
//  Created by Frank on 16/1/27.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "CustomerAddressManagerVC.h"
#import "OSNCustomerManager.h"
#import "AddressPickerView.h"
#import "BuildingPickerView.h"
#import <MBProgressHUD.h>
#import <Masonry.h>

@interface CustomerAddressManagerVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *addressList;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *buildingNoText;
@property (weak, nonatomic) IBOutlet UITextField *roomNoText;

@property (nonatomic, strong) AddressPickerView *addressPicker;
@property (nonatomic, strong) BuildingPickerView *buildingPicker;
@property (nonatomic, strong) OSNCustomerAddress *entity;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation CustomerAddressManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewLayoutAndStyle];
    [self initViewData];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddressLabel:)];
    [self.addressLabel addGestureRecognizer:tapRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBuildingLabel:)];
    [self.buildingLabel addGestureRecognizer:tapRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInnerView:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.addressList.dataSource = self;
    self.addressList.delegate = self;
}

- (void)setViewLayoutAndStyle {
    [self.view addSubview:self.addressPicker];
    [self.addressPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(6);
        make.left.right.equalTo(self.addressLabel);
        make.height.mas_equalTo(30);
    }];
    [self hiddenAddressPicker];
    
    [self.view addSubview:self.buildingPicker];
    [self.buildingPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buildingLabel.mas_bottom).offset(6);
        make.left.right.equalTo(self.buildingLabel);
        make.height.mas_equalTo(30);
    }];
    [self hiddenBuildingPicker];
}

- (void)initViewData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.addressList animated:YES];
    hud.labelText = @"加载中...";
    hud.opacity = 0;
    hud.activityIndicatorColor = [UIColor blackColor];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        OSNCustomerManager *customerManager = [[OSNCustomerManager alloc] init];
        self.dataList = [customerManager getAddressListWithCustomerId:self.customerId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.addressList reloadData];
            [MBProgressHUD hideHUDForView:self.addressList animated:YES];
        });
    });
}


#pragma mark - Event

- (IBAction)clickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSaveButton:(id)sender {
    self.entity.customerId = self.customerId;
    self.entity.name = self.customerName;
    self.entity.contactPhone = self.mobile;
    self.entity.address = self.addressLabel.text;
    self.entity.buildingNo = self.buildingNoText.text;
    self.entity.room = self.roomNoText.text;
    self.entity.state = self.dataList.count > 0 ? 0 : 1;
    
    OSNCustomerManager *customerManager = [[OSNCustomerManager alloc] init];
    if (self.entity.addressId) {
        [customerManager UpdateCustomerAddress:self.entity];
    }
    else {
        [customerManager CreateCustomerAddress:self.entity];
    }
}

- (void)tapAddressLabel:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    [self hiddenAllPicker];
    [self showAddressPicker];
}

- (void)tapBuildingLabel:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    [self hiddenAllPicker];
    [self showBuildingPicker];
    NSString *provinceId = self.entity.provinceId;
    NSString *cityId = self.entity.cityId;
    NSString *areaId = self.entity.areaId;
    if (provinceId) {
        [self.buildingPicker setProvinceCode:provinceId cityCode:cityId andCountyCode:areaId];
    }
}

- (void)tapInnerView:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
    [self hiddenAllPicker];
}


#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    OSNCustomerAddress *entity = self.dataList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@"
                           , entity.provinceName, entity.cityName, entity.areaName,
                           entity.address, entity.buildingName, entity.buildingNo, entity.room];
    return cell;
}

#pragma mark - Private

- (void)showAddressPicker {
    self.addressPicker.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.addressPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)hiddenAddressPicker {
    [UIView animateWithDuration:0.3 animations:^{
        [self.addressPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
        [self.view layoutIfNeeded];
    }];
    self.addressPicker.hidden = YES;
}

- (void)showBuildingPicker {
    self.buildingPicker.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.buildingPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(140);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)hiddenBuildingPicker {
    [UIView animateWithDuration:0.3 animations:^{
        [self.buildingPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
        [self.view layoutIfNeeded];
    }];
    self.buildingPicker.hidden = YES;
}

- (void)hiddenAllPicker {
    [self hiddenAddressPicker];
    [self hiddenBuildingPicker];
}

#pragma mark - Preporty

- (AddressPickerView *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [[AddressPickerView alloc] init];
        __weak CustomerAddressManagerVC *weakSelf = self;
        _addressPicker.block = ^(AddressPickerView *view, NSDictionary *userInfo) {
            weakSelf.entity.provinceId = userInfo[@"province"];
            weakSelf.entity.provinceName = userInfo[@"provinceName"];
            weakSelf.entity.cityId = userInfo[@"city"];
            weakSelf.entity.cityName = userInfo[@"cityName"];
            weakSelf.entity.areaId = userInfo[@"county"];
            weakSelf.entity.areaName = userInfo[@"countyName"];
            weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",
                                          weakSelf.entity.provinceName, weakSelf.entity.cityName, weakSelf.entity.areaName];
            weakSelf.addressLabel.textColor = [UIColor blackColor];
            [weakSelf hiddenAddressPicker];
        };
    }
    return _addressPicker;
}

- (BuildingPickerView *)buildingPicker {
    if (!_buildingPicker) {
        _buildingPicker = [[BuildingPickerView alloc] init];
        __weak CustomerAddressManagerVC *weakSelf = self;
        _buildingPicker.didSelectBlock = ^(BuildingPickerView *view, OSNBuildingEntity *entity) {
            weakSelf.buildingLabel.text = entity.buildingName;
            weakSelf.buildingLabel.textColor = [UIColor blackColor];
            weakSelf.entity.buildingId = entity.buildingId;
            weakSelf.entity.buildingName = entity.buildingName;
        };
    }
    return _buildingPicker;
}

- (OSNCustomerAddress *)entity {
    if (!_entity) {
        _entity = [[OSNCustomerAddress alloc] init];
    }
    return _entity;
}

@end
