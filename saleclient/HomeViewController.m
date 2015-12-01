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

@interface HomeViewController ()

@property(nonatomic, strong) NavigationViewController *contentNav;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    BOOL isValid = [[OSNUserManager sharedInstance] checkSessionIsValid];
    if (!isValid) {
        
    }
}

- (IBAction)openNavigationViewController:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.contentNav.currentIndex = btn.tag;
    [self.navigationController pushViewController:self.contentNav animated:YES];
}

- (NavigationViewController *)contentNav {
    if (!_contentNav) {
        _contentNav = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController" bundle:nil];
    }
    return _contentNav;
}

@end
