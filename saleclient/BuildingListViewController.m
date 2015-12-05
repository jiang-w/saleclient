//
//  BuildingListViewController.m
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "BuildingListViewController.h"
#import <Masonry.h>

@interface BuildingListViewController ()

@property(nonatomic, strong) BuildingLeftSider *sideViewController;
@property(nonatomic, strong) BuildingImageList *imageListViewController;

@end

@implementation BuildingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.sideViewController.view];
    [self.sideViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(260);
    }];
    
    [self.view addSubview:self.imageListViewController.view];
    [self.imageListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.left.equalTo(self.sideViewController.view.mas_right);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - property

- (BuildingLeftSider *)sideViewController {
    if (!_sideViewController) {
        _sideViewController = [[BuildingLeftSider alloc] init];
        _sideViewController.delegate = self.imageListViewController;
    }
    return _sideViewController;
}

- (BuildingImageList *)imageListViewController {
    if (!_imageListViewController) {
        _imageListViewController = [[BuildingImageList alloc] init];
    }
    return _imageListViewController;
}

@end
