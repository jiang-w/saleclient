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

@interface CustomerSigninView()

@property(nonatomic, weak) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSelect;
@property (weak, nonatomic) IBOutlet UITextField *qqText;
@property (weak, nonatomic) IBOutlet UITextField *eMailText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *customerTypeSelect;
@property (weak, nonatomic) IBOutlet UITextField *provinceText;
@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UITextField *areaText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *notesText;
@property (weak, nonatomic) IBOutlet UITextField *recommendName;
@property (weak, nonatomic) IBOutlet UITextField *recommendMobile;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong, readonly) NSString *receptionId;
@property(nonatomic, copy) NSString *customerId;

@end

@implementation CustomerSigninView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        _innerView.layer.borderWidth = 2;
        _innerView.layer.borderColor = [UIColor orangeColor].CGColor;
        [self addSubview:_innerView];
        
        [_saveButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _saveButton.backgroundColor = RGB(252, 237, 226);
        _saveButton.layer.borderWidth = 1;
        _saveButton.layer.borderColor = [UIColor orangeColor].CGColor;
        _saveButton.layer.cornerRadius = 5;
        
        [_cancelButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _cancelButton.backgroundColor = RGB(252, 237, 226);
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.borderColor = [UIColor orangeColor].CGColor;
        _cancelButton.layer.cornerRadius = 5;
        
        _mobile.delegate = self;
        
        [self initViewData];
    }
    return self;
}

+ (instancetype)defaultView {
    CustomerSigninView *view = [[CustomerSigninView alloc]initWithFrame:CGRectMake(0, 0, 680, 520)];
    return view;
}


#pragma mark - event

- (IBAction)cancelButtonClick:(id)sender {
    [self.parentVC lew_dismissPopupView];
}

- (IBAction)saveButtonClick:(id)sender {
    if (IS_EMPTY_STRING(self.name.text) || IS_EMPTY_STRING(self.mobile.text)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名和手机号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
        else {
            paramters[@"genderId"] = @"M";
        }
        paramters[@"qq"] = self.qqText.text;
        paramters[@"email"] = self.eMailText.text;
        paramters[@"provinceId"] = self.provinceText.text;
        paramters[@"cityId"] = self.cityText.text;
        paramters[@"areaId"] = self.areaText.text;
        paramters[@"address"] = self.addressText.text;
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}


#pragma mark - delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.parentVC lew_dismissPopupView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!IS_EMPTY_STRING(self.mobile.text)) {
        OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
        self.customerId = [manage validateCustomerMobile:self.mobile.text];
        if (self.customerId) {
            NSDictionary *dataDic = [manage getCustomerWithId:self.customerId];
            if (dataDic) {
                [self fillDataFromDictionary:dataDic];
            }
        }
    }
}


#pragma mark - private method

- (void)initViewData {
    OSNUserInfo *userInfo = [OSNUserManager sharedInstance].currentUser;
    _provinceText.text = userInfo.provinceName;
    _cityText.text = userInfo.cityName;
    _areaText.text = userInfo.areaName;
    
    OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
    NSDictionary *dataDic = [manage getCustomerWithId:self.receptionId];
    if (dataDic) {
        [self fillDataFromDictionary:dataDic];
    }
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
    else {
        self.genderSelect.selectedSegmentIndex = 0;
    }
    
    NSString *qq = dictionary[@"qq"];
    if (!IS_EMPTY_STRING(qq)) {
        self.qqText.text = qq;
    }
    
    NSString *email = dictionary[@"email"];
    if (!IS_EMPTY_STRING(email)) {
        self.eMailText.text = email;
    }
    
    NSString *province = dictionary[@"provinceId"];
    if (!IS_EMPTY_STRING(province)) {
        self.provinceText.text = province;
    }
    
    NSString *city = dictionary[@"cityId"];
    if (!IS_EMPTY_STRING(city)) {
        self.cityText.text = city;
    }
    
    NSString *area = dictionary[@"areaId"];
    if (!IS_EMPTY_STRING(area)) {
        self.areaText.text = area;
    }
    
    NSString *address = dictionary[@"address"];
    if (!IS_EMPTY_STRING(address)) {
        self.addressText.text = address;
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
}


#pragma mark - property

- (NSString *)receptionId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"receptionId"];
}

@end
