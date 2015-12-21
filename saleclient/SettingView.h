//
//  SettingView.h
//  saleclient
//
//  Created by Frank on 15/12/21.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView

@property(nonatomic, weak) UIViewController *parentVC;

+ (instancetype)defaultView;

@end
