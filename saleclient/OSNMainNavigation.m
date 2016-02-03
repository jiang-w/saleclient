//
//  OSNMainNavigation.m
//  saleclient
//
//  Created by Frank on 15/12/3.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNMainNavigation.h"
#import "AppDelegate.h"

@class HomeViewController;

@interface OSNMainNavigation ()

@end

@implementation OSNMainNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeResponseStatus:) name:RESPONSE_STATUS_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeResponseStatus:(NSNotification *)notification {
    NSString *status = notification.userInfo[@"status"];
    switch ([status integerValue]) {
        case 10008:
        case 10009:
        {
            AppDelegate *appDelegate = OSNMainDelegate;
            appDelegate.window.rootViewController = appDelegate.signInViewController;
            break;
        }
        default:
            break;
    }
}

- (BOOL)isContainViewControllerForClass:(Class)contrClass {
    for (UIViewController *contr in self.viewControllers) {
        if ([contr isKindOfClass:contrClass]) {
            return YES;
        }
    }
    return NO;
}

- (void)popViewControllerForClass:(Class)contrClass {
    if ([self isContainViewControllerForClass:contrClass]) {
        while (self.viewControllers.count > 0) {
            if (![self.topViewController isKindOfClass:contrClass]) {
                [self popViewControllerAnimated:NO];
            }
            else {
                [self popViewControllerAnimated:NO];
                break;
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RESPONSE_STATUS_NOTIFICATION object:nil];
}

@end
