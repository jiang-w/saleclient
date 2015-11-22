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

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)openNavigationViewController:(id)sender {
    NavigationViewController *nav = [[NavigationViewController alloc] initWithNibName:@"NavigationViewController" bundle:nil];
    [self.navigationController pushViewController:nav animated:YES];
}

@end
