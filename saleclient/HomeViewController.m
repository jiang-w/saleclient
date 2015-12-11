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
#import "OSNCustomerManager.h"
#import "AppDelegate.h"
#import "CustomerSigninView.h"
#import "LewPopupViewController.h"
#import "CustomerReceptionRecordViewController.h"

@interface HomeViewController ()

@property(nonatomic, strong) MasterViewController *contentNav;
@property (weak, nonatomic) IBOutlet UILabel *receptionText;
@property (weak, nonatomic) IBOutlet UIButton *completeReceptionButton;

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
    
    NSString *receptionId = [OSNCustomerManager currentReceptionId];
    if (receptionId && ![receptionId isEqualToString:@""]) {
        self.completeReceptionButton.hidden = NO;
        self.receptionText.text = @"正在接待";
        NSLog(@"正在接待：%@", receptionId);
    }
    else {
        self.completeReceptionButton.hidden = YES;
        self.receptionText.text = @"新接待";
    }
}

- (IBAction)openNavigationViewController:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.contentNav.currentIndex = btn.tag;
    [self.navigationController pushViewController:self.contentNav animated:YES];
}

- (IBAction)signinCustomer:(id)sender {
    NSString *receptionId = [OSNCustomerManager currentReceptionId];
    if (!receptionId || [receptionId isEqualToString:@""]) {
        OSNCustomerManager *manage = [[OSNCustomerManager alloc] init];
        receptionId = [manage generateReceptionId];
        if (receptionId) {
            self.receptionText.text = @"正在接待";
            self.completeReceptionButton.hidden = NO;
        }
    }
    else {
        CustomerSigninView *customerView = [CustomerSigninView defaultView];
        customerView.parentVC = self;
        [self lew_presentPopupView:customerView animation:[LewPopupViewAnimationFade new] dismissed:nil];
    }
}

- (IBAction)completeReception:(id)sender {
    OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
    [manager completeCustomerReception];
    self.completeReceptionButton.hidden = YES;
    self.receptionText.text = @"新接待";
}

- (IBAction)openReceptionRecord:(id)sender {
    CustomerReceptionRecordViewController *record = [CustomerReceptionRecordViewController alloc];
    [self.navigationController pushViewController:record animated:YES];
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
