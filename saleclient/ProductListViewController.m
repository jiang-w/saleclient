//
//  ProductListViewController.m
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductImageList.h"
#import <Masonry.h>

@interface ProductListViewController ()

@property(nonatomic, strong) ProductTagTable *sideViewController;
@property(nonatomic, strong) ProductImageList *imageListViewController;

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.sideViewController.tableView];
    [self.sideViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(260);
    }];
    
    [self.view addSubview:self.imageListViewController.view];
    [self.imageListViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.left.equalTo(self.sideViewController.tableView.mas_right);
    }];
}


- (ProductTagTable *)sideViewController {
    if (!_sideViewController) {
        _sideViewController = [[ProductTagTable alloc] init];
        _sideViewController.delegate = self.imageListViewController;
    }
    return _sideViewController;
}

- (ProductImageList *)imageListViewController {
    if (!_imageListViewController) {
        _imageListViewController = [[ProductImageList alloc] init];
    }
    return _imageListViewController;
}

@end
