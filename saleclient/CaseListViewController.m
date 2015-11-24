//
//  CaseListViewController.m
//  saleclient
//
//  Created by Frank on 15/11/22.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseListViewController.h"
#import "CaseTagTableViewController.h"
#import <Masonry.h>

@interface CaseListViewController()

@property(nonatomic, strong) CaseTagTableViewController *tagTableVC;

@end

@implementation CaseListViewController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        [self.view setFrame:frame];
        self.view.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tagTableVC.tableView];
    [self.tagTableVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(260);
    }];
}


- (CaseTagTableViewController *)tagTableVC {
    if (!_tagTableVC) {
        _tagTableVC = [[CaseTagTableViewController alloc] init];
    }
    return _tagTableVC;
}

@end
