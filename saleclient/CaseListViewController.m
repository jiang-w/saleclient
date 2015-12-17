//
//  CaseListViewController.m
//  saleclient
//
//  Created by Frank on 15/11/22.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseListViewController.h"

@interface CaseListViewController()

@property(nonatomic, strong) CaseTagTable *sideViewController;
@property(nonatomic, strong) CaseImageList *imageListViewController;

@end

@implementation CaseListViewController

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

- (CaseTagTable *)sideViewController {
    if (!_sideViewController) {
        _sideViewController = [[CaseTagTable alloc] init];
        _sideViewController.delegate = self.imageListViewController;
    }
    return _sideViewController;
}

- (CaseImageList *)imageListViewController {
    if (!_imageListViewController) {
        _imageListViewController = [[CaseImageList alloc] init];
    }
    return _imageListViewController;
}

- (void)masterViewController:(MasterViewController *)master searchWithKeyword:(NSString *)keyword {
    NSLog(@"CaseListViewController search keyword: %@", keyword);
    [self.imageListViewController searchWithKeyword:keyword];
}

@end
