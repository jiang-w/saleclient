//
//  CaseListViewController.m
//  saleclient
//
//  Created by Frank on 15/11/22.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseListViewController.h"
#import "OSNCaseTagListVC.h"
#import <Masonry.h>

@interface CaseListViewController()

@property(nonatomic, strong) OSNCaseTagListVC *sideViewController;

@end

@implementation CaseListViewController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        [self.view setFrame:frame];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.sideViewController.tableView];
    [self.sideViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(260);
    }];
}

- (OSNCaseTagListVC *)sideViewController {
    if (!_sideViewController) {
        _sideViewController = [[OSNCaseTagListVC alloc] init];
    }
    return _sideViewController;
}

@end
