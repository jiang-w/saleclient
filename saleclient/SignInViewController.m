//
//  SignInViewController.m
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "SignInViewController.h"
#import "HomeViewController.h"
#import "OSNUserManager.h"
#import "AppDelegate.h"

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextBox;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    OSNUserInfo *userinfo = [OSNUserManager sharedInstance].currentUser;
    if (userinfo) {
        self.userNameTextBox.text = userinfo.userLoginId;
    }
    
    self.userNameTextBox.delegate = self;
    self.passwordTextBox.delegate = self;
    
    // 点击背景消失键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    // 取消输入框第一响应
    [self.userNameTextBox resignFirstResponder];
    [self.passwordTextBox resignFirstResponder];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];   //点击Return后键盘消失
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    CGFloat yOffset = self.view.frame.size.height - frame.origin.y - frame.size.height - 520;
    if (yOffset < 0) {
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:0.3];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        CGRect rect = CGRectMake(0, yOffset, width, height);
        self.view.frame = rect;
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.3];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0, 0, width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
}


#pragma mark - event

- (IBAction)signin:(id)sender {
    // 取消输入框第一响应
    [self.userNameTextBox resignFirstResponder];
    [self.passwordTextBox resignFirstResponder];
    
    NSString *userName = self.userNameTextBox.text;
    NSString *password = self.passwordTextBox.text;
    BOOL isRemember = YES;
    if (IS_EMPTY_STRING(userName) || IS_EMPTY_STRING(password)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else {
        OSNUserInfo *user = [[OSNUserManager sharedInstance] signiInWithUserName:userName andPassword:password isRemember:isRemember];
        if (user) {
            if (isRemember) {
                
            }
            AppDelegate *appDelegate = OSNMainDelegate;
            HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            appDelegate.mainNav = [[OSNMainNavigation alloc] initWithRootViewController:home];
            appDelegate.window.rootViewController = appDelegate.mainNav;
            
            self.userNameTextBox.text = @"";
            self.passwordTextBox.text = @"";
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}


@end
