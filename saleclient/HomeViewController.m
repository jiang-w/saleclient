//
//  HomeViewController.m
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "HomeViewController.h"
#import "MasterViewController.h"
#import "OSNUserManager.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@property(nonatomic, strong) MasterViewController *contentNav;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    if (![OSNUserManager sharedInstance].currentUser) {
        [self openSignInWindow];
    }
    else {
        [[OSNUserManager sharedInstance] checkSessionIsValid];
    }
}

- (IBAction)openNavigationViewController:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.contentNav.currentIndex = btn.tag;
    [self.navigationController pushViewController:self.contentNav animated:YES];
}


#pragma mark - property

- (MasterViewController *)contentNav {
    if (!_contentNav) {
        _contentNav = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    }
    return _contentNav;
}

- (void)openSignInWindow {
    AppDelegate *appDelegate = OSNMainDelegate;
    appDelegate.window.rootViewController = appDelegate.signInViewController;
}

@end
