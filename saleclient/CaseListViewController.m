//
//  CaseListViewController.m
//  saleclient
//
//  Created by Frank on 15/11/22.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseListViewController.h"
#import "OSNCaseManager.h"
#import <Masonry.h>

@interface CaseListViewController()

@property(nonatomic, strong) CaseTagTable *sideViewController;
@property(nonatomic, assign) NSUInteger viewSize;
@property(nonatomic, assign) NSUInteger viewIndex;

@end

@implementation CaseListViewController
{
    OSNCaseManager *_manager;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        [self.view setFrame:frame];
        _manager = [[OSNCaseManager alloc] init];
        _viewSize = 6;
        _viewIndex = 1;
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
        _sideViewController.delegate = self;
    }
    return _sideViewController;
}

- (void)loadCaseListView {
    NSDictionary *selectedResult = [self.sideViewController getAllSelectedTagResult];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"roomId"] = selectedResult[@"room"];
    paramDic[@"styleId"] = selectedResult[@"style"];
    paramDic[@"houseTypeId"] = selectedResult[@"houseType"];
    paramDic[@"viewSize"] = [NSString stringWithFormat:@"%lu", self.viewSize];
    paramDic[@"viewIndex"] = @"1";
    
    [_manager getCaseListWithParameters:paramDic];
}

#pragma mark - CaseTagTableDelegate

-(void)didChangeSelectedTags {
    [self loadCaseListView];
}

@end
