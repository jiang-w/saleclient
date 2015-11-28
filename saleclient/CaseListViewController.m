//
//  CaseListViewController.m
//  saleclient
//
//  Created by Frank on 15/11/22.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseListViewController.h"
#import "CaseTagTable.h"
#import <Masonry.h>

@interface CaseListViewController()

@property(nonatomic, strong) CaseTagTable *sideViewController;

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
        make.width.mas_equalTo(280);
    }];
}

- (CaseTagTable *)sideViewController {
    if (!_sideViewController) {
        _sideViewController = [[CaseTagTable alloc] init];
    }
    return _sideViewController;
}

@end
