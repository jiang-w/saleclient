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
#import "UIViewController+LewPopupViewController.h"

@interface SettingView()

@property(nonatomic, weak) IBOutlet UIView *innerView;

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
    }
    return self;
}

+ (instancetype)defaultView {
    SettingView *view = [[SettingView alloc]initWithFrame:CGRectMake(0, 0, 360, 420)];
    return view;
}

- (IBAction)logoutButtonClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出当前用户吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (IBAction)updateButtonClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前版本已是最新" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        OSNUserManager *manager = [OSNUserManager sharedInstance];
        [manager signOut];
        AppDelegate *appDelegate = OSNMainDelegate;
        appDelegate.window.rootViewController = appDelegate.signInViewController;
    }
}

@end
