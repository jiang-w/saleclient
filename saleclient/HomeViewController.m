//
//  HomeViewController.m
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "HomeViewController.h"
#import "NavigationViewController.h"
#import "OSNUserManager.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@property(nonatomic, strong) NavigationViewController *contentNav;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeServiceResponse:) name:RESPONSE_STATUS_NOTIFICATION object:nil];
    
    if (![OSNUserManager sharedInstance].currentUser) {
        [self openSignInWindow];
    }
}

- (IBAction)openNavigationViewController:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.contentNav.currentIndex = btn.tag;
    [self.navigationController pushViewController:self.contentNav animated:YES];
}


#pragma mark - property

- (NavigationViewController *)contentNav {
    if (!_contentNav) {
        _contentNav = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController" bundle:nil];
    }
    return _contentNav;
}


#pragma mark - private

- (void)openSignInWindow {
    AppDelegate *appDelegate = OSNMainDelegate;
    appDelegate.window.rootViewController = appDelegate.signInViewController;
}

- (void)observeServiceResponse:(NSNotification *)notification {
    NSString *status = notification.userInfo[@"status"];
    switch ([status integerValue]) {
        case 10003: {   // 没有权限
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有访问权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case 10008: {   // 令牌失效
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"令牌失效" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [self openSignInWindow];
            break;
        }
        default:
            break;
    }
}

@end
