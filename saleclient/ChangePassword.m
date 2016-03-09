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
#import "UIResponder+FirstResponder.h"

@interface ChangePassword ()

@property (nonatomic, weak) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UITextField *editPassword;
@property (weak, nonatomic) IBOutlet UITextField *checkPassword;
@property (nonatomic, assign) CGRect originalFrame;


@end

@implementation ChangePassword

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = CGRectMake(302, 244, 420, 280);
        _innerView.layer.borderWidth = 2;
        _innerView.layer.borderColor = [UIColor orangeColor].CGColor;
        [self addSubview:_innerView];
        
        _originalFrame = _innerView.frame;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(actionKeyboardShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(actionKeyboardHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

+ (instancetype)defaultView {
    ChangePassword *view = [[ChangePassword alloc]initWithFrame:[UIScreen mainScreen].bounds];
    return view;
}

- (IBAction)submitButtonClick:(id)sender {
    [self endEditing:YES];
    if (![self.editPassword.text isEqualToString:self.checkPassword.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (IS_EMPTY_STRING(self.editPassword.text)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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


#pragma mark - notification

- (void)actionKeyboardShow:(NSNotification *)notification {
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
            CGRect rect = CGRectMake(self.innerView.frame.origin.x, self.innerView.frame.origin.x - 200, width, height);
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
