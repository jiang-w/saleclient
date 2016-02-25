//
//  AppDelegate.h
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "OSNMainNavigation.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#define PGY_APPKEY @"d1b8862120e2d164a0cfcdcbe3ba6ca1"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) OSNMainNavigation *mainNav;
@property (strong, nonatomic) SignInViewController *signInViewController;

@end

