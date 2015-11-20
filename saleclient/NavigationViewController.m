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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat pageHeight = CGRectGetHeight(self.scrollView.frame);
    self.scrollView.contentSize = CGSizeMake(pageWidth * 4 , pageHeight);
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
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
