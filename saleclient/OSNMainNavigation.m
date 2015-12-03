//
//  OSNMainNavigation.m
//  saleclient
//
//  Created by Frank on 15/12/3.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNMainNavigation.h"
#import "AppDelegate.h"

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

@end