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
#import "DesignerPickerView.h"
#import "DesignerPickerViewModel.h"

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
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;
@property (weak, nonatomic) IBOutlet UITextField *buildingNo;
@property (weak, nonatomic) IBOutlet UITextField *roomNo;
@property (weak, nonatomic) IBOutlet UILabel *designerLabel;
@property (weak, nonatomic) IBOutlet UITextField *receptionShopName;
@property (weak, nonatomic) IBOutlet UITextField *receptionTime;
@property (weak, nonatomic) IBOutlet UITextField *receptionGuideName;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) AddressPickerView *addressPicker;
@property (nonatomic, strong) AgePickerView *agePicker;
@property (nonatomic, strong) BuildingPickerView *buildingPicker;
@property (nonatomic, strong) DesignerPickerView *designerPicker;

@property (nonatomic, strong, readonly) NSString *receptionId;
@property (nonatomic, strong) OSNCustomerInfo *customer;
@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation CustomerSigninView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _originalFrame = frame;
        [self initViewAndLayout];
        [self initViewDataWithCustomerId:self.receptionId];
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
}

- (void)tapDesignerLabel:(UITapGestureRecognizer *)recognizer {
    [self endEditing:YES];
    [self hiddenAllPicker];
    [self showDesignerPicker];
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
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else {
        [self updateCustomerInfoFromView];
        
        OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        paramters[@"customerName"] = self.customer.customerName;
        paramters[@"mobile"] = self.customer.mobile;
        paramters[@"genderId"] = !self.customer.genderId ? @"" : self.customer.genderId;
        paramters[@"qq"] = !self.customer.qq ? @"" : self.customer.qq;
        paramters[@"customerAge"] = !self.customer.customerAge ? @"" : self.customer.customerAge;
        paramters[@"notes"] = !self.customer.notes ? @"" : self.customer.notes;
        paramters[@"customerId"] = !self.customer.customerId ? @"" : self.customer.customerId;
        paramters[@"recommendCustomerId"] = !self.customer.recommendCustomerId ? @"" : self.customer.recommendCustomerId;
        paramters[@"recommendName"] = !self.customer.recommendName ? @"" : self.customer.recommendName;
        paramters[@"recommendMobile"] = !self.customer.recommendMobile ? @"" : self.customer.recommendMobile;
        paramters[@"typeId"] = !self.customer.typeId ? @"" : self.customer.typeId;
        
        [manage updateCustomerWithParamters:paramters];
        if ([self validateAddressInput] && self.customer.defaultAddress) {
            [manage UpdateCustomerAddress:self.customer.defaultAddress];
        }
        
        if (![self.receptionId isEqualToString:self.customer.customerId]) {
            NSString *customerId = [manage combineCustomerWithNewCustomerId:self.receptionId andExistCustomerId:self.customer.customerId];
            self.customer.customerId = customerId;
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
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
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else {
        [self.parentVC lew_dismissPopupView];
        
        HomeViewController *parent = (HomeViewController *)self.parentVC;
        CustomerAddressManagerVC *addressCV = [[CustomerAddressManagerVC alloc] initWithNibName:@"CustomerAddressManagerVC" bundle:nil];
        addressCV.customerId = self.customer.customerId;
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
    webView.url = [NSString stringWithFormat:@"http://bi.osnyun.com:11113/OSNBigData/console/userPortrait/userState.jsp?customerId='%@'", self.customer.customerId];
    [parent.navigationController pushViewController:webView animated:NO];
}


#pragma mark - delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.parentVC lew_dismissPopupView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.mobile && !IS_EMPTY_STRING(self.mobile.text)) {
        OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
        NSString *customerId = [manage validateCustomerMobile:self.mobile.text];
        if (customerId) {
            [self initViewDataWithCustomerId:customerId];
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
    
    [self.innerView addSubview:self.agePicker];
    [self.agePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageLabel.mas_bottom).offset(6);
        make.left.right.equalTo(self.ageLabel);
        make.height.mas_equalTo(0);
    }];
    
    [self.innerView addSubview:self.buildingPicker];
    [self.buildingPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buildingLabel.mas_bottom).offset(6);
        make.left.right.equalTo(self.buildingLabel);
        make.height.mas_equalTo(0);
    }];
    
    [self.innerView addSubview:self.designerPicker];
    [self.designerPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.designerLabel.mas_top).offset(-6);
        make.left.right.equalTo(self.designerLabel);
        make.height.mas_equalTo(0);
    }];
    
    [self hiddenAllPicker];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAddressLabel:)];
    [_addressLabel addGestureRecognizer:tapRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAgeLabel:)];
    [_ageLabel addGestureRecognizer:tapRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBuildingLabel:)];
    [_buildingLabel addGestureRecognizer:tapRecognizer];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDesignerLabel:)];
    [_designerLabel addGestureRecognizer:tapRecognizer];
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

- (void)initViewDataWithCustomerId:(NSString *)customerId {
    self.customer = [[OSNCustomerInfo alloc] init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
        NSDictionary *dataDic = [manage getCustomerWithId:customerId];
        self.customer.customerId = dataDic[@"customerId"];
        self.customer.customerName = dataDic[@"customerName"];
        self.customer.mobile = dataDic[@"mobile"];
        self.customer.genderId = dataDic[@"genderId"];
        self.customer.customerAge = dataDic[@"customerAge"];
        self.customer.email = dataDic[@"email"];
        self.customer.qq = dataDic[@"qq"];
        self.customer.notes = dataDic[@"notes"];
        self.customer.recommendCustomerId = dataDic[@"recommendCustomerId"];
        self.customer.recommendName = dataDic[@"recommendName"];
        self.customer.recommendMobile = dataDic[@"recommendMobile"];
        self.customer.receptionShopName = dataDic[@"receptionShopName"];
        self.customer.receptionTime = dataDic[@"receptionTime"];
        self.customer.receptionGuideName = dataDic[@"receptionGuideName"];
        self.customer.typeId = dataDic[@"typeId"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fillDataFromCustomerInfo:self.customer];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        OSNCustomerManager *customerManager = [[OSNCustomerManager alloc] init];
        NSArray *addressList = [customerManager getAddressListWithCustomerId:customerId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (OSNCustomerAddress *address in addressList) {
                if (address.state == 1) {
                    self.customer.defaultAddress = address;
                    break;
                }
            }
            
            if (self.customer.defaultAddress) {
                NSString *provinceId = self.customer.defaultAddress.provinceId;
                NSString *cityId = self.customer.defaultAddress.cityId;
                NSString *areaId = self.customer.defaultAddress.areaId;
                if (provinceId && cityId && areaId) {
                    [self.addressPicker setProvinceCode:provinceId cityCode:cityId andCountyCode:areaId];
                    NSString *buildingId = self.customer.defaultAddress.buildingId;
                    if (buildingId) {
                        [self.buildingPicker setProvinceCode:provinceId cityCode:cityId countyCode:areaId andBuildingId:buildingId];
                    }
                    else {
                        [self.buildingPicker setProvinceCode:provinceId cityCode:cityId andCountyCode:areaId];
                    }
                }
                if (self.customer.defaultAddress.address) {
                    self.addressText.text = self.customer.defaultAddress.address;
                }
                if (self.customer.defaultAddress.buildingNo) {
                    self.buildingNo.text = self.customer.defaultAddress.buildingNo;
                }
                if (self.customer.defaultAddress.room) {
                    self.roomNo.text = self.customer.defaultAddress.room;
                }
            }
        });
    });
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

- (void)showDesignerPicker {
    self.designerPicker.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.designerPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(140);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)hiddenDesignerPicker {
    [UIView animateWithDuration:0.3 animations:^{
        [self.designerPicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
        }];
        [self layoutIfNeeded];
    }];
    self.designerPicker.hidden = YES;
}

- (void)hiddenAllPicker {
    [self hiddenAgePicker];
    [self hiddenAddressPicker];
    [self hiddenBuildingPicker];
    [self hiddenDesignerPicker];
}

- (void)fillDataFromCustomerInfo:(OSNCustomerInfo *)customer {
    if (!IS_EMPTY_STRING(customer.customerName)) {
        self.name.text = customer.customerName;
    }
    
    if (!IS_EMPTY_STRING(customer.mobile)) {
        self.mobile.text = customer.mobile;
    }
    
    if ([customer.genderId isEqualToString:@"F"]) {
        self.genderSelect.selectedSegmentIndex = 1;
    }
    else if ([customer.genderId isEqualToString:@"M"]) {
        self.genderSelect.selectedSegmentIndex = 0;
    }
    else {
        self.genderSelect.selectedSegmentIndex = -1;
    }
    
    if (!IS_EMPTY_STRING(customer.qq)) {
        self.qqText.text = customer.qq;
    }
    
    if (!IS_EMPTY_STRING(customer.email)) {
        self.eMailText.text = customer.email;
    }
    
    if (!IS_EMPTY_STRING(customer.customerAge)) {
        [self.agePicker setAgeCode:customer.customerAge];
    }
    
    if (!IS_EMPTY_STRING(customer.notes)) {
        self.notesText.text = customer.notes;
    }
    
    if (!IS_EMPTY_STRING(customer.recommendName)) {
        self.recommendName.text = customer.recommendName;
    }
    
    if (!IS_EMPTY_STRING(customer.recommendMobile)) {
        self.recommendMobile.text = customer.recommendMobile;
    }
    
    if (!IS_EMPTY_STRING(customer.receptionShopName)) {
        self.receptionShopName.text = customer.receptionShopName;
    }
    
    if (!IS_EMPTY_STRING(customer.receptionTime)) {
        self.receptionTime.text = customer.receptionTime;
    }
    
    if (!IS_EMPTY_STRING(customer.receptionGuideName)) {
        self.receptionGuideName.text = customer.receptionGuideName;
    }

    // 家装客户姓名红色显示
    if (customer.customerId && [customer.typeId isEqualToString:@"ct1001"]) {
        self.name.textColor = [UIColor redColor];
    }
    else {
        self.name.textColor = [UIColor blackColor];
    }
}

- (void)updateCustomerInfoFromView {
    self.customer.customerName = IS_EMPTY_STRING(self.name.text) ? nil : self.name.text;
    self.customer.mobile = IS_EMPTY_STRING(self.mobile.text) ? nil : self.mobile.text;
    if (self.genderSelect.selectedSegmentIndex == 1) {
        self.customer.genderId = @"F";
    }
    else if (self.genderSelect.selectedSegmentIndex == 0) {
        self.customer.genderId = @"M";
    }
    else {
        self.customer.genderId = nil;
    }
    self.customer.qq = IS_EMPTY_STRING(self.qqText.text) ? nil : self.qqText.text;
    self.customer.email = IS_EMPTY_STRING(self.eMailText.text) ? nil : self.eMailText.text;
    self.customer.notes = IS_EMPTY_STRING(self.notesText.text) ? nil : self.notesText.text;
    self.customer.recommendName = IS_EMPTY_STRING(self.recommendName.text) ? nil : self.recommendName.text;
    self.customer.recommendMobile = IS_EMPTY_STRING(self.recommendMobile.text) ? nil : self.recommendMobile.text;
    self.customer.recommendCustomerId = self.customer.customerId;
    if (self.customer.defaultAddress) {
        self.customer.defaultAddress.name = IS_EMPTY_STRING(self.name.text) ? nil : self.name.text;
        self.customer.defaultAddress.contactPhone = IS_EMPTY_STRING(self.mobile.text) ? nil : self.mobile.text;
        self.customer.defaultAddress.address = IS_EMPTY_STRING(self.addressText.text) ? nil : self.addressText.text;
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
            if (weakSelf.customer.defaultAddress) {
                weakSelf.customer.defaultAddress.provinceId = userInfo[@"province"];
                weakSelf.customer.defaultAddress.provinceName = userInfo[@"provinceName"];
                weakSelf.customer.defaultAddress.cityId = userInfo[@"city"];
                weakSelf.customer.defaultAddress.cityName = userInfo[@"cityName"];
                weakSelf.customer.defaultAddress.areaId = userInfo[@"county"];
                weakSelf.customer.defaultAddress.areaName = userInfo[@"countyName"];
                [weakSelf.buildingPicker setProvinceCode:userInfo[@"province"] cityCode:userInfo[@"city"] andCountyCode:userInfo[@"county"]];
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
            weakSelf.customer.customerAge = userInfo[@"code"];
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
            weakSelf.customer.defaultAddress.buildingId = entity.buildingId;
        };
    }
    return _buildingPicker;
}

- (DesignerPickerView *)designerPicker {
    if (!_designerPicker) {
        DesignerPickerViewModel *viewModel = [[DesignerPickerViewModel alloc] init];
        _designerPicker = [[DesignerPickerView alloc] initWithViewModel:viewModel];
        __weak CustomerSigninView *weakSelf = self;
        _designerPicker.didSelectBlock = ^(DesignerPickerView *view, NSDictionary *designer) {
            weakSelf.designerLabel.text = designer[@"personName"];
            weakSelf.designerLabel.textColor = [UIColor blackColor];
            weakSelf.customer.designerId = designer[@"partyId"];
        };
    }
    return _designerPicker;
}

@end
