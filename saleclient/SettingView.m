//
//  SettingView.m
//  saleclient
//
//  Created by Frank on 15/12/21.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "SettingView.h"
#import "OSNUserManager.h"
#import "AppDelegate.h"
#import "LewPopupViewController.h"
#import "UIViewController+LewPopupViewController.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "OSNNetworkService.h"
#import "ChangePassword.h"

@interface SettingView()

@property(nonatomic, weak) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SettingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        _innerView.layer.borderWidth = 2;
        _innerView.layer.borderColor = [UIColor orangeColor].CGColor;
        [self addSubview:_innerView];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *build_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
        _versionLabel.text = [NSString stringWithFormat:@"当前版本：%@(build %@)", app_Version, build_Version];
        
        [self.innerView addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.innerView).offset(16);
            make.right.equalTo(self.innerView).offset(-16);
        }];
    }
    return self;
}

+ (instancetype)defaultView {
    SettingView *view = [[SettingView alloc]initWithFrame:CGRectMake(0, 0, 360, 420)];
    return view;
}

- (IBAction)logoutButtonClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出当前用户吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)changePasswordClick:(id)sender {
    ChangePassword *changePassword = [ChangePassword defaultView];
    changePassword.parentVC = self.parentVC;
    [self.parentVC lew_presentPopupView:changePassword animation:[LewPopupViewAnimationFade new] dismissed:nil];
}

- (IBAction)updateButtonClick:(id)sender {
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
//    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        OSNUserManager *manager = [OSNUserManager sharedInstance];
        [manager signOut];
        AppDelegate *appDelegate = OSNMainDelegate;
        appDelegate.window.rootViewController = appDelegate.signInViewController;
    }
}

/**
 *  检查更新回调
 *  @param response 检查更新的返回结果
 */
- (void)updateMethod:(NSDictionary *)response {
    if (response[@"downloadURL"]) {
        [[PgyUpdateManager sharedPgyManager] checkUpdate];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前版本已是最新" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 0, 30, 30);
        _closeButton.layer.cornerRadius = _closeButton.frame.size.height / 2;
        _closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_closeButton setTitle:@"╳" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _closeButton.layer.borderWidth = 1.5;
        _closeButton.layer.borderColor = [UIColor orangeColor].CGColor;
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)closeButtonClick:(id)sender {
    [self.parentVC lew_dismissPopupView];
}

@end
