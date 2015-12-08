//
//  ImageViewController.m
//  saleclient
//
//  Created by Frank on 15/12/8.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ImageViewController.h"
#import <Masonry.h>

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(600);
        make.height.mas_equalTo(500);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
    }
    return _image;
}

@end
