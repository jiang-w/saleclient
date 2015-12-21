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
#import "SettingView.h"
#import "QRCodeScanViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeViewController ()

@property(nonatomic, strong) MasterViewController *contentNav;
@property (weak, nonatomic) IBOutlet UILabel *receptionText;
@property (weak, nonatomic) IBOutlet UIButton *completeReceptionButton;
@property (weak, nonatomic) IBOutlet UIScrollView *focusImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    OSNUserInfo *user = [OSNUserManager sharedInstance].currentUser;
    if (!user) {
        [self openSignInWindow];
    }
    else {
        [[OSNUserManager sharedInstance] checkSessionIsValid];
        self.userLabel.text = [NSString stringWithFormat:@"当前登录：%@", user.personName];
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
    
    [self loadFocusImage];
}

- (void)loadFocusImage {
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        OSNUserManager *manager = [[OSNUserManager alloc] init];
        NSArray *dataArr = [manager getFocusImageData];
        if (dataArr && dataArr.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGSize viewSize = weakSelf.focusImageView.frame.size;
                weakSelf.focusImageView.contentSize = CGSizeMake(viewSize.width * dataArr.count, viewSize.height);
                for (int i = 0; i < dataArr.count; i++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * viewSize.width, 0, viewSize.width, viewSize.height)];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:dataArr[i][@"imagePath"]]];
                    [weakSelf.focusImageView addSubview:imageView];
                }
            });
        }
    });
}


#pragma mark - event

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
    NSString *receptionId = [OSNCustomerManager currentReceptionId];
    if (!IS_EMPTY_STRING(receptionId)) {
        CustomerReceptionRecordViewController *record = [CustomerReceptionRecordViewController alloc];
        [self.navigationController pushViewController:record animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先接待客户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)openQRCodeScan:(id)sender {
//    QRCodeScanViewController *scanVC = [[QRCodeScanViewController alloc] init];
//    [self presentViewController:scanVC animated:NO completion:nil];
}

- (IBAction)settingButtonClick:(id)sender {
    SettingView *settingView = [SettingView defaultView];
    settingView.parentVC = self;
    [self lew_presentPopupView:settingView animation:[LewPopupViewAnimationFade new] dismissed:nil];
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
