//
//  NavigationViewController.m
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *caseBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIButton *productBtn;
@property (weak, nonatomic) IBOutlet UIButton *clientBtn;

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeDisplayView:(id)sender {
    if (sender == self.homeBtn) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
