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

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextBox;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)signin:(id)sender {
    NSString *userName = self.userNameTextBox.text;
    NSString *password = self.passwordTextBox.text;
    BOOL isRemember = NO;
    if (IS_EMPTY_STRING(userName) || IS_EMPTY_STRING(password)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else {
        OSNUserManager *manager = [[OSNUserManager alloc] init];
        OSNUserInfo *user = [manager signiInWithUserName:userName andPassword:password isRemember:isRemember];
        if (user) {
            if (isRemember) {
                
            }
            HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            [OSNMainDelegate window].rootViewController = [[UINavigationController alloc] initWithRootViewController:home];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}


@end
