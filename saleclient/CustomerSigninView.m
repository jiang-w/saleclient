//
//  CustomerSigninView.m
//  saleclient
//
//  Created by Frank on 15/12/9.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CustomerSigninView.h"
#import "UIViewController+LewPopupViewController.h"

@interface CustomerSigninView()

@end

@implementation CustomerSigninView

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
    CustomerSigninView *view = [[CustomerSigninView alloc]initWithFrame:CGRectMake(0, 0, 680, 520)];
    return view;
}

- (IBAction)cancelButtonClick:(id)sender {
    [self.parentVC lew_dismissPopupView];
}

@end
