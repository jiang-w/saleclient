//
//  HomeViewController.m
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "HomeViewController.h"
#import "NavigationViewController.h"


@interface HomeViewController ()

@property(nonatomic, strong) NavigationViewController *nav;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.nav = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController" bundle:nil];
}

- (IBAction)openNavigationViewController:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.nav.currentIndex = btn.tag;
    [self.navigationController pushViewController:self.nav animated:YES];
}

@end
