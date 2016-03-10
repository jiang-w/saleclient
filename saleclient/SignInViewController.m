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
#import "UIResponder+FirstResponder.h"

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
    
//    self.userNameTextBox.delegate = self;
//    self.passwordTextBox.delegate = self;
    
    // 点击背景消失键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerBackgroundTap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionKeyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionKeyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];   //点击Return后键盘消失
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    CGRect frame = textField.frame;
//    CGFloat yOffset = self.view.frame.size.height - frame.origin.y - frame.size.height - 520;
//    if (yOffset < 0) {
//        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//        [UIView setAnimationDuration:0.3];
//        float width = self.view.frame.size.width;
//        float height = self.view.frame.size.height;
//        CGRect rect = CGRectMake(0, yOffset, width, height);
//        self.view.frame = rect;
//        [UIView commitAnimations];
//    }
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:0.3];
//    float width = self.view.frame.size.width;
//    float height = self.view.frame.size.height;
//    CGRect rect = CGRectMake(0, 0, width, height);
//    self.view.frame = rect;
//    [UIView commitAnimations];
//}


#pragma mark - event

- (void) handlerBackgroundTap:(UITapGestureRecognizer*)sender {
    // 取消输入框第一响应
//    [self.userNameTextBox resignFirstResponder];
//    [self.passwordTextBox resignFirstResponder];
    [self.view endEditing:YES];
}

- (IBAction)signin:(id)sender {
    // 取消输入框第一响应
//    [self.userNameTextBox resignFirstResponder];
//    [self.passwordTextBox resignFirstResponder];
    [self.view endEditing:YES];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NetworkStatus status = [app.hostReach currentReachabilityStatus];
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络异常"
                                                        message:@"无法连接到服务器，请检查网络"
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
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

- (void)actionKeyboardShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    NSLog(@"keyboard: %@", NSStringFromCGSize(keyboardSize));
    
    id responder = [UIResponder currentFirstResponder];
    if (responder && [responder isKindOfClass:[UITextField class]]) {
        UITextField *txtField = (UITextField *)responder;
//        NSLog(@"TextField: %@", NSStringFromCGRect(txtField.frame));
        
        CGFloat yOffset = self.view.frame.size.height - txtField.frame.origin.y - txtField.frame.size.height - keyboardSize.height - 20;
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
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0, 0, width, height);
    self.view.frame = rect;
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
