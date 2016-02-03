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
#import "CustomerAddressCell.h"
#import <MBProgressHUD.h>
#import <Masonry.h>

@interface CustomerAddressManagerVC () <UITableViewDataSource, UITableViewDelegate, CustomerAddressCellDelegate>

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
@property (nonatomic, strong) UIAlertView *saveAlert;
@property (nonatomic, strong) UIAlertView *deleteAleart;

@end

@implementation CustomerAddressManagerVC

static NSString * const reuseIdentifier = @"addressListCell";

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionKeyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
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
    
    self.addressList.bounces = NO;
    self.addressList.allowsSelection = NO;
    self.addressList.dataSource = self;
    self.addressList.delegate = self;
    self.addressList.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (IBAction)clickClearButton:(id)sender {
    [self initEditText];
}

- (IBAction)clickSaveButton:(id)sender {
    [self.view endEditing:YES];
    [self hiddenAllPicker];
    
    if (![self validateInput]) {
        self.saveAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"地址信息不能为空" delegate:nil
                                 cancelButtonTitle:@"确定" otherButtonTitles: nil];
    }
    else {
        self.saveAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"是否要保存地址" delegate:self
                                 cancelButtonTitle:@"取消" otherButtonTitles: @"确定", nil];
    }
    [self.saveAlert show];
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
    CustomerAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomerAddressCell" owner:self options:nil];
        for (id obj in nib) {
            if ([obj isKindOfClass:[CustomerAddressCell class]]) {
                cell = (CustomerAddressCell *)obj;
                cell.delegate = self;
                break;
            }
        }
    }
    OSNCustomerAddress *entity = self.dataList[indexPath.row];
    cell.addressEntity = entity;
    return cell;
}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//        OSNCustomerAddress *address = self.dataList[indexPath.row];
//        [self fillEditTextWithAddress:address];
////        [tableView setEditing:NO animated:YES];
//    }];
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//        OSNCustomerAddress *address = self.dataList[indexPath.row];
//        self.entity = address;
//        self.deleteAleart = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除此地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [self.deleteAleart show];
////        [tableView setEditing:NO animated:YES];
//    }];
//    return @[deleteAction, editAction];
//}

- (void)customerAddressCell:(CustomerAddressCell *)cell willEditAddress:(OSNCustomerAddress *)address {
    [self fillEditTextWithAddress:address];
}

- (void)customerAddressCell:(CustomerAddressCell *)cell willDeleteAddress:(OSNCustomerAddress *)address {
    self.entity = address;
    self.deleteAleart = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除此地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.deleteAleart show];
}

- (void)customerAddressCell:(CustomerAddressCell *)cell willSetPreferAddress:(OSNCustomerAddress *)address {
    OSNCustomerManager *customerManager = [[OSNCustomerManager alloc] init];
    [customerManager SetDefaultAddressWithId:address.addressId];
    [self initViewData];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.saveAlert) {
        if (buttonIndex == 1) {
            self.entity.customerId = self.customerId;
            self.entity.name = self.customerName;
            self.entity.contactPhone = self.mobile;
            self.entity.address = self.addressText.text;
            self.entity.buildingNo = self.buildingNoText.text;
            self.entity.room = self.roomNoText.text;
            
            OSNCustomerManager *customerManager = [[OSNCustomerManager alloc] init];
            if (self.entity.addressId) {
                [customerManager UpdateCustomerAddress:self.entity];
            }
            else {
                self.entity.state = self.dataList.count > 0 ? 0 : 1;
                [customerManager CreateCustomerAddress:self.entity];
            }
            _entity = nil;
            [self initEditText];
            [self initViewData];
        }
    }
    
    if (alertView == self.deleteAleart) {
        if (buttonIndex == 1) {
            OSNCustomerManager *customerManager = [[OSNCustomerManager alloc] init];
            [customerManager deleteCustomerAddressWithId:self.entity.addressId];
            _entity = nil;
            [self initViewData];
        }
    }
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

- (void)fillEditTextWithAddress:(OSNCustomerAddress *)address {
    [self.addressPicker setProvinceCode:address.provinceId cityCode:address.cityId andCountyCode:address.areaId];
    [self.buildingPicker setProvinceCode:address.provinceId cityCode:address.cityId countyCode:address.areaId andBuildingId:address.buildingId];
    self.addressText.text = address.address;
    if (![address.buildingNo isEqual:[NSNull null]]) {
        self.buildingNoText.text = address.buildingNo;
    }
    if (![address.room isEqual:[NSNull null]]) {
        self.roomNoText.text = address.room;
    }
    self.entity.addressId = address.addressId;
    self.entity.state = address.state;
}

- (void)initEditText {
    self.addressLabel.text = @"选择省市区";
    self.addressLabel.textColor = RGB(205, 205, 210);
    self.buildingLabel.text = @"选择楼盘";
    self.buildingLabel.textColor = RGB(205, 205, 210);
    self.addressText.text = @"";
    self.buildingNoText.text = @"";
    self.roomNoText.text = @"";
}

- (BOOL)validateInput {
    if ([self.addressLabel.text isEqualToString:@"选择省市区"]) {
        return NO;
    }
    if ([self.buildingLabel.text isEqualToString:@"选择省市区"]) {
        return NO;
    }
    if ([self.addressText.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
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
            [weakSelf.buildingPicker setProvinceCode:weakSelf.entity.provinceId cityCode:weakSelf.entity.cityId andCountyCode:weakSelf.entity.areaId];
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


#pragma mark - Notification

- (void)actionKeyboardShow:(NSNotification *)notification {
    [self hiddenAllPicker];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

@end
