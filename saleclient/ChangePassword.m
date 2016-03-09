//
//  ChangePasswordVC.m
//  saleclient
//
//  Created by Frank on 16/3/8.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "ChangePassword.h"
#import "UIViewController+LewPopupViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "OSNUserManager.h"

@interface ChangePassword ()

@property (nonatomic, weak) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UITextField *editPassword;
@property (weak, nonatomic) IBOutlet UITextField *checkPassword;


@end

@implementation ChangePassword

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        _innerView.layer.borderWidth = 2;
        _innerView.layer.borderColor = [UIColor orangeColor].CGColor;
        [self addSubview:_innerView];
    }
    return self;
}

+ (instancetype)defaultView {
    ChangePassword *view = [[ChangePassword alloc]initWithFrame:CGRectMake(0, 0, 420, 280)];
    return view;
}

- (IBAction)submitButtonClick:(id)sender {
    if (![self.editPassword.text isEqualToString:self.checkPassword.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSString *currentPassword = [NSString stringWithFormat:@"{SHA}%@", [self sha1:self.currentPassword.text]];
    NSString *newPassword = [NSString stringWithFormat:@"{SHA}%@", [self sha1:self.editPassword.text]];
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        OSNUserManager *manager = [[OSNUserManager alloc] init];
        NSString *status = [manager changePasswordWithCurrentPassword:currentPassword andNewPassword:newPassword];
        dispatch_async(dispatch_get_main_queue(), ^{
            switch ([status integerValue]) {
                case 40000: {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"原密码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    break;
                }
                case 40001: {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    
                    weakSelf.currentPassword.text = nil;
                    weakSelf.editPassword.text = nil;
                    weakSelf.checkPassword.text = nil;
                    break;
                }
                default: {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    break;
                }
            }
        });
    });
}

- (IBAction)cancelButtonClick:(id)sender {
    [self.parentVC lew_dismissPopupView];
}

//sha1加密方式
- (NSString *)sha1:(NSString *)input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
