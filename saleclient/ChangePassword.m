//
//  ChangePasswordVC.m
//  saleclient
//
//  Created by Frank on 16/3/8.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "ChangePassword.h"
#import "UIViewController+LewPopupViewController.h"

@interface ChangePassword ()

@property (nonatomic, weak) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *changePasswordText;
@property (weak, nonatomic) IBOutlet UITextField *againText;


@end

@implementation ChangePassword

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
    ChangePassword *view = [[ChangePassword alloc]initWithFrame:CGRectMake(0, 0, 420, 280)];
    return view;
}

- (IBAction)submitButtonClick:(id)sender {
    [self.parentVC lew_dismissPopupView];
}

- (IBAction)cancelButtonClick:(id)sender {
    [self.parentVC lew_dismissPopupView];
}

@end
