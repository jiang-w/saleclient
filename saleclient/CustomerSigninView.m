//
//  CustomerSigninView.m
//  saleclient
//
//  Created by Frank on 15/12/9.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CustomerSigninView.h"
#import "UIViewController+LewPopupViewController.h"
#import "OSNCustomerManager.h"
#import "OSNUserManager.h"
#import "HomeViewController.h"
#import "CustomerDetailMaster.h"
#import "AddressPickerView.h"
#import "AgePickerView.h"
#import <Masonry.h>
#import "UIResponder+FirstResponder.h"
#import "OSNWebViewController.h"
#import "BuildingPickerView.h"
#import "CustomerAddressManagerVC.h"
#import "OSNCustomerManager.h"

@interface CustomerSigninView()

@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelect;
@property (weak, nonatomic) IBOutlet UITextField *qqText;
@property (weak, nonatomic) IBOutlet UITextField *eMailText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *customerTypeSelect;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *notesText;
@property (weak, nonatomic) IBOutlet UITextField *recommendName;
@property (weak, nonatomic) IBOutlet UITextField *recommendMobile;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) AddressPickerView *addressPicker;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (nonatomic, strong) AgePickerView *agePicker;
@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;
@property (nonatomic, strong) BuildingPickerView *buildingPicker;
@property (weak, nonatomic) IBOutlet UITextField *buildingNo;
@property (weak, nonatomic) IBOutlet UITextField *roomNo;

@property (nonatomic, strong) NSString *ageCode;
@property (nonatomic, strong, readonly) NSString *receptionId;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, strong) OSNCustomerAddress *customerAddress;

@end

@implementation CustomerSigninView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _originalFrame = frame;
        [self initViewAndLayout];
        [self initViewData];
    }
    return self;
}

+ (instancetype)defaultView {
    CustomerSigninView *view = [[CustomerSigninView alloc] initWithFrame:CGRectMake(0, 0, 680, 620)];
    return view;
}


#pragma mark - event

- (void)tapAddressLabel:(UITapGestureRecognizer *)recognizer {
    [self endEditing:YES];
    [self hiddenAllPicker];
    [self showAddressPicker];
}

- (void)tapAgeLabel:(UITapGestureRecognizer *)recognizer {
    [self endEditing:YES];
    [self hiddenAllPicker];
    [self showAgePicker];
}

- (void)tapBuildingLabel:(UITapGestureRecognizer *)recognizer {
    [self endEditing:YES];
    [self hiddenAllPicker];
    [self showBuildingPicker];
//    [self.buildingPicker setProvinceCode:self.provinceCode cityCode:self.cityCode andCountyCode:self.countyCode];
}

- (void)tapInnerView:(UITapGestureRecognizer *)recognizer {
    [self endEditing:YES];
    [self hiddenAllPicker];
}

- (IBAction)cancelButtonClick:(id)sender {
    [self.parentVC lew_dismissPopupView];
}

- (IBAction)saveButtonClick:(id)sender {
    if (IS_EMPTY_STRING(self.name.text) || IS_EMPTY_STRING(self.mobile.text)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名和手机号不能为空"
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else {
        OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        paramters[@"customerName"] = self.name.text;
        paramters[@"mobile"] = self.mobile.text;
        if (self.genderSelect.selectedSegmentIndex == 1) {
            paramters[@"genderId"] = @"F";
        }
        else if (self.genderSelect.selectedSegmentIndex == 0) {
            paramters[@"genderId"] = @"M";
        }
        
        paramters[@"qq"] = self.qqText.text;
        paramters[@"email"] = self.eMailText.text;
        paramters[@"customerAge"] = self.ageCode;
        paramters[@"notes"] = self.notesText.text;
        
        if (!self.customerId) {
            self.customerId = [manage createCustomerWithParamters:paramters];
        }
        else {
            paramters[@"customerId"] = self.customerId;
            paramters[@"recommendCustomerId"] = self.customerId;
            paramters[@"recommendName"] = self.recommendName.text;
            paramters[@"recommendMobile"] = self.recommendMobile.text;
            if (self.customerTypeSelect.selectedSegmentIndex == 0) {
                paramters[@"typeId"] = @"ct1001";
            }
            else {
                paramters[@"typeId"] = @"ct1000";
            }
            [manage updateCustomerWithParamters:paramters];
        }
        
        if (![self.receptionId isEqualToString:self.customerId]) {
            NSString *customerId = [manage combineCustomerWithNewCustomerId:self.receptionId andExistCustomerId:self.customerId];
            self.customerId = customerId;
        }
        
        if (self.customerAddress) {
            self.customerAddress.customerId = self.customerId;
            if ([self validateAddressInput]) {
                self.customerAddress.customerId = self.customerId;
                self.customerAddress.name = self.name.text;
                self.customerAddress.contactPhone = self.mobile.text;
                self.customerAddress.address = self.addressText.text;
                self.customerAddress.buildingNo = self.buildingNo.text;
                self.customerAddress.room = self.roomNo.text;
                
                OSNCustomerManager *customerManager = [[OSNCustomerManager alloc] init];
                if (self.customerAddress.addressId) {
                    [customerManager UpdateCustomerAddress:self.customerAddress];
                }
                else {
                    [customerManager CreateCustomerAddress:self.customerAddress];
                }
            }
        }
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (BOOL)validateAddressInput {
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

- (IBAction)openCustomerDetail:(id)sender {
    [self.parentVC lew_dismissPopupView];
    
    HomeViewController *parent = (HomeViewController *)self.parentVC;
    parent.contentNav.currentIndex = 3;
    [parent.navigationController pushViewController:parent.contentNav animated:NO];
    
    CustomerDetailMaster *customerDetail = [[CustomerDetailMaster alloc] initWithCustomerId:self.receptionId];
    [parent.navigationController pushViewController:customerDetail animated:NO];
}

- (IBAction)openAddressManager:(id)sender {
    if (IS_EMPTY_STRING(self.name.text) || IS_EMPTY_STRING(self.mobile.text)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名和手机号不能为空"
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else {
        [self.parentVC lew_dismissPopupView];
        
        HomeViewController *parent = (HomeViewController *)self.parentVC;
        CustomerAddressManagerVC *addressCV = [[CustomerAddressManagerVC alloc] initWithNibName:@"CustomerAddressManagerVC" bundle:nil];
        addressCV.customerId = self.customerId;
        addressCV.customerName = self.name.text;
        addressCV.mobile = self.mobile.text;
        [parent.navigationController pushViewController:addressCV animated:YES];
    }
}

- (IBAction)openWebView:(id)sender {
    [self.parentVC lew_dismissPopupView];
    
    HomeViewController *parent = (HomeViewController *)self.parentVC;
    OSNWebViewController *webView = [[OSNWebViewController alloc] init];
//    webView.url = @"http://bi.osnyun.com:11113/OSNBigData/console/userPortrait/userState.jsp?customerId=%271041316205%27";
    webView.url = [NSString stringWithFormat:@"http://bi.osnyun.com:11113/OSNBigData/console/userPortrait/userState.jsp?customerId='%@'", self.customerId];
    [parent.navigationController pushViewController:webView animated:NO];
}


#pragma mark - delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.parentVC lew_dismissPopupView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.mobile && !IS_EMPTY_STRING(self.mobile.text)) {
        OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
        self.customerId = [manage validateCustomerMobile:self.mobile.text];
        if (self.customerId) {
            NSDictionary *dataDic = [manage getCustomerWithId:self.customerId];
            if (dataDic) {
                [self fillDataFromDictionary:dataDic];
            }
            
            [self loadAddressDataWithCustomerId:self.customerId];
        }
    }
}


#pragma mark - notification

- (void)actionKeyboardShow:(NSNotification *)notification {
    [self hiddenAllPicker];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    id responder = [UIResponder currentFirstResponder];
    if (responder && [responder isKindOfClass:[UITextField class]]) {
        UITextField *txtField = (UITextField *)responder;
        CGRect txtFrame = txtField.frame;
        
        CGFloat yOffset = self.innerView.frame.size.height - txtFrame.origin.y - txtFrame.size.height - keyboardSize.height;
        if (yOffset < 0) {
            [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
            [UIView setAnimationDuration:0.3];
            float width = self.innerView.frame.size.width;
            float height = self.innerView.frame.size.height;
            CGRect rect = CGRectMake(0, yOffset, width, height);
            self.innerView.frame = rect;
            [UIView commitAnimations];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionKeyboardShow:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
}

- (void)actionKeyboardHide:(NSNotification *)notification {
    id responder = [UIResponder currentFirstResponder];
    if (responder && [responder isKindOfClass:[UITextField class]]) {
        UITextField *txtField = (UITextField *)responder;
        [txtField resignFirstResponder];
    }
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.3];
    self.innerView.frame = self.originalFrame;
    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionKeyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}


#pragma mark - private method

- (void)initViewAndLayout {
    [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    self.innerView.layer.borderWidth = 2;
    self.innerView.layer.borderColor = [UIColor orangeColor].CGColor;
    [self addSubview:self.innerView];
    [self.innerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.innerView addSubview:self.addressPicker];
    [self.addressPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(6);
        make.left.equalTo(self.addressLabel);
        make.right.equalTo(self.buildingLabel);
        make.height.mas_equalTo(30);
    }];
    [self hiddenAddressPicker];
    
    [self.innerView addSubview:self.agePicker];
    [self.agePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageLabel.mas_bottom).offset(6);
        make.left.right.equalTo(self.ageLabel);
        make.height.mas_equalTo(0);
    }];
    [self hiddenAgePicker];
    
    [self.innerView addSubview:self.buildingPicker];
    [self.buildingPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buildingLabel.mas_bottom).offset(6);
        make.left.right.equalTo(self.buildingLabel);
        make.height.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddressLabel:)];
    [_addressLabel addGestureRecognizer:tapRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAgeLabel:)];
    [_ageLabel addGestureRecognizer:tapRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBuildingLabel:)];
    [_buildingLabel addGestureRecognizer:tapRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInnerView:)];
    [_innerView addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionKeyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionKeyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.mobile.delegate = self;
}

- (void)showAgePicker {
    self.agePicker.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.agePicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(140);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)hiddenAgePicker {
    [UIView animateWithDuration:0.3 animations:^{
        [self.agePicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
        [self layoutIfNeeded];
    }];
    self.agePicker.hidden = YES;
}

- (void)showAddressPicker {
    self.addressPicker.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.addressPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(200);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)hiddenAddressPicker {
    [UIView animateWithDuration:0.3 animations:^{
        [self.addressPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
        [self layoutIfNeeded];
    }];
    self.addressPicker.hidden = YES;
}

- (void)showBuildingPicker {
    self.buildingPicker.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.buildingPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(140);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)hiddenBuildingPicker {
    [UIView animateWithDuration:0.3 animations:^{
        [self.buildingPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
        [self layoutIfNeeded];
    }];
    self.buildingPicker.hidden = YES;
}

- (void)hiddenAllPicker {
    [self hiddenAgePicker];
    [self hiddenAddressPicker];
    [self hiddenBuildingPicker];
}

- (void)initViewData {
    OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
    NSDictionary *dataDic = [manage getCustomerWithId:self.receptionId];
    if (dataDic) {
        [self fillDataFromDictionary:dataDic];
        
        if (self.customerId) {
            [self loadAddressDataWithCustomerId:self.customerId];
        }
    }
    
    NSArray *designers = [[OSNUserManager sharedInstance] getDesignerList];
}

- (void)fillDataFromDictionary:(NSDictionary *)dictionary {
    self.customerId = dictionary[@"customerId"];
    
    NSString *mobile = dictionary[@"mobile"];
    if (!IS_EMPTY_STRING(mobile)) {
        self.mobile.text = mobile;
    }
    
    NSString *name = dictionary[@"customerName"];
    if (!IS_EMPTY_STRING(name)) {
        self.name.text = name;
    }
    
    NSString *genderId = dictionary[@"genderId"];
    if ([genderId isEqualToString:@"F"]) {
        self.genderSelect.selectedSegmentIndex = 1;
    }
    else if ([genderId isEqualToString:@"M"]) {
        self.genderSelect.selectedSegmentIndex = 0;
    }
    else {
        self.genderSelect.selectedSegmentIndex = -1;
    }
    
    NSString *qq = dictionary[@"qq"];
    if (!IS_EMPTY_STRING(qq)) {
        self.qqText.text = qq;
    }
    
    NSString *email = dictionary[@"email"];
    if (!IS_EMPTY_STRING(email)) {
        self.eMailText.text = email;
    }
    
    NSString *ageCode = dictionary[@"customerAge"];
    if (!IS_EMPTY_STRING(ageCode)) {
        [self.agePicker setAgeCode:ageCode];
    }
    
    NSString *notes = dictionary[@"notes"];
    if (!IS_EMPTY_STRING(notes)) {
        self.notesText.text = notes;
    }
    
    NSString *recommendName = dictionary[@"recommendName"];
    if (!IS_EMPTY_STRING(recommendName)) {
        self.recommendName.text = recommendName;
    }
    
    NSString *recommendMobile = dictionary[@"recommendMobile"];
    if (!IS_EMPTY_STRING(recommendMobile)) {
        self.recommendMobile.text = recommendMobile;
    }
    
    NSString *typeId = dictionary[@"typeId"];
    if ([typeId isEqualToString:@"ct1000"]) {
        self.customerTypeSelect.selectedSegmentIndex = 1;
    }
    else {
        self.customerTypeSelect.selectedSegmentIndex = 0;
    }
    
    // 家装客户姓名红色显示
    if (self.customerId && [typeId isEqualToString:@"ct1001"]) {
        self.name.textColor = [UIColor redColor];
    }
    else {
        self.name.textColor = [UIColor blackColor];
    }
}

- (void)loadAddressDataWithCustomerId:(NSString *)customerId {
    OSNCustomerManager *customerManager = [[OSNCustomerManager alloc] init];
    NSArray *addressList = [customerManager getAddressListWithCustomerId:customerId];
    for (OSNCustomerAddress *address in addressList) {
        if (address.state == 1) {
            self.customerAddress = address;
            break;
        }
    }
    if (!self.customerAddress) {
        self.customerAddress = [[OSNCustomerAddress alloc] init];
        self.customerAddress.customerId = customerId;
        self.customerAddress.state = 1;
    }
    OSNUserInfo *userInfo = [OSNUserManager sharedInstance].currentUser;
    if ([self.customerAddress.provinceId isEqual:[NSNull null]]) {
        self.customerAddress.provinceId = userInfo.provinceId;
    }
    if ([self.customerAddress.cityId isEqual:[NSNull null]]) {
        self.customerAddress.cityId = userInfo.cityId;
    }
    if ([self.customerAddress.areaId isEqual:[NSNull null]]) {
        self.customerAddress.areaId = userInfo.areaId;
    }
    
    [self.addressPicker setProvinceCode:self.customerAddress.provinceId cityCode:self.customerAddress.cityId andCountyCode:self.customerAddress.areaId];
    if ([self.customerAddress.buildingId isEqual:[NSNull null]]) {
        [self.buildingPicker setProvinceCode:self.customerAddress.provinceId cityCode:self.customerAddress.cityId andCountyCode:self.customerAddress.areaId];
    }
    else {
        [self.buildingPicker setProvinceCode:self.customerAddress.provinceId cityCode:self.customerAddress.cityId countyCode:self.customerAddress.areaId andBuildingId:self.customerAddress.buildingId];
    }
    if (![self.customerAddress.address isEqual:[NSNull null]]) {
        self.addressText.text = self.customerAddress.address;
    }
    if (![self.customerAddress.buildingNo isEqual:[NSNull null]]) {
        self.buildingNo.text = [self.customerAddress.buildingNo isEqual:[NSNull null]] ? @"" : self.customerAddress.buildingNo;
    }
    if (![self.customerAddress.room isEqual:[NSNull null]]) {
        self.roomNo.text = [self.customerAddress.room isEqual:[NSNull null]] ? @"" : self.customerAddress.room;
    }
}


#pragma mark - property

- (NSString *)receptionId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"receptionId"];
}

- (AddressPickerView *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [[AddressPickerView alloc] init];
        _addressPicker.hidden = YES;
        __weak CustomerSigninView *weakSelf = self;
        _addressPicker.block = ^(AddressPickerView *view, NSDictionary *userInfo) {
            weakSelf.addressLabel.text = view.description;
            weakSelf.addressLabel.textColor = [UIColor blackColor];
            if (weakSelf.customerAddress) {
                weakSelf.customerAddress.provinceId = userInfo[@"province"];
                weakSelf.customerAddress.provinceName = userInfo[@"provinceName"];
                weakSelf.customerAddress.cityId = userInfo[@"city"];
                weakSelf.customerAddress.cityName = userInfo[@"cityName"];
                weakSelf.customerAddress.areaId = userInfo[@"county"];
                weakSelf.customerAddress.areaName = userInfo[@"countyName"];
            }
            [weakSelf hiddenAddressPicker];
        };
    }
    return _addressPicker;
}

- (AgePickerView *)agePicker {
    if (!_agePicker) {
        _agePicker = [[AgePickerView alloc] init];
        __weak CustomerSigninView *weakSelf = self;
        _agePicker.didSelectBlock = ^(AgePickerView *view, NSDictionary *userInfo) {
            weakSelf.ageLabel.text = userInfo[@"description"];
            weakSelf.ageLabel.textColor = [UIColor blackColor];
            weakSelf.ageCode = userInfo[@"code"];
        };
        _agePicker.dissmissBlock = ^(AgePickerView *view) {
            [weakSelf hiddenAgePicker];
        };
    }
    return _agePicker;
}

- (BuildingPickerView *)buildingPicker {
    if (!_buildingPicker) {
        _buildingPicker = [[BuildingPickerView alloc] init];
        __weak CustomerSigninView *weakSelf = self;
        _buildingPicker.didSelectBlock = ^(BuildingPickerView *view, OSNBuildingEntity *entity) {
            weakSelf.buildingLabel.text = entity.buildingName;
            weakSelf.buildingLabel.textColor = [UIColor blackColor];
        };
    }
    return _buildingPicker;
}

@end
