//
//  ImageShowView.h
//  saleclient
//
//  Created by Frank on 15/12/9.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageShowView : UIView

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, weak) UIViewController *parentVC;

@end
