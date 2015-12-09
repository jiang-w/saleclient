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

@interface CustomerSigninView()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *mobile;

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
        
        _mobile.delegate = self;
    }
    return self;
}

+ (instancetype)defaultView {
    CustomerSigninView *view = [[CustomerSigninView alloc]initWithFrame:CGRectMake(0, 0, 680, 520)];
    return view;
}

- (void)initViewData {
    OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
    NSDictionary *dataDic = [manage getCustomerWithId:self.receptionId];
    if (dataDic) {
        // 数据填充
    }
}


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
        if (!self.customerId) {
            self.customerId = [manage createCustomerWithParamters:paramters];
        }
        else {
            [manage updateCustomerWithParamters:paramters];
        }
        
        if (![self.receptionId isEqualToString:self.customerId]) {
            NSString *customerId = [manage combineCustomerWithNewCustomerId:self.receptionId andExistCustomerId:self.customerId];
            self.customerId = customerId;
            self.receptionId = customerId;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

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
                self.name.text = dataDic[@"customerName"];
            }
        }
    }
}

@end
