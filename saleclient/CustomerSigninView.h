//
//  CustomerSigninView.h
//  saleclient
//
//  Created by Frank on 15/12/9.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerSigninView : UIView <UITextFieldDelegate>

@property(nonatomic, weak) UIViewController *parentVC;


@property (nonatomic, strong) NSString *receptionId;
@property(nonatomic, copy) NSString *customerId;

+ (instancetype)defaultView;

@end
