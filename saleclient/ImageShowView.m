//
//  ImageShowView.m
//  saleclient
//
//  Created by Frank on 15/12/9.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ImageShowView.h"
#import "UIViewController+LewPopupViewController.h"

@implementation ImageShowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(580);
            make.height.mas_equalTo(580);
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewHandle:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapViewHandle:(UIGestureRecognizer *)gesture {
    [self.parentVC lew_dismissPopupView];
}

@end
