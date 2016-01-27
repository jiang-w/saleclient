//
//  CustomerAddressManagerVC.m
//  saleclient
//
//  Created by Frank on 16/1/27.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "CustomerAddressManagerVC.h"

@interface CustomerAddressManagerVC ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation CustomerAddressManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewLayoutAndStyle];
}

- (void)setViewLayoutAndStyle {
    self.backButton.titleLabel.textColor = [UIColor orangeColor];
}


#pragma mark - Event

- (IBAction)clickBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
