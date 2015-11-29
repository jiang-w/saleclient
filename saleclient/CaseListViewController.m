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

@property(nonatomic, assign) NSUInteger viewSize;
@property(nonatomic, assign) NSUInteger viewIndex;
@property(nonatomic, strong) NSMutableArray *caseList;
@property(nonatomic, strong) CaseTagTable *sideViewController;

@end

@implementation CaseListViewController
{
    OSNCaseManager *_manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _manager = [[OSNCaseManager alloc] init];
        _viewSize = 6;
        _viewIndex = 1;
        _caseList = [NSMutableArray array];
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
    
    [self loadCaseListView];
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
    paramDic[@"viewIndex"] = [NSString stringWithFormat:@"%lu", self.viewIndex];
    NSArray *list = [_manager getCaseListWithParameters:paramDic];
    [self.caseList addObjectsFromArray:list];
}

- (void)loadMoreCaseList {
    self.viewIndex++;
    [self loadCaseListView];
}

#pragma mark - CaseTagTableDelegate

-(void)didChangeSelectedTags {
    [self.caseList removeAllObjects];
    self.viewIndex = 1;
    [self loadCaseListView];
}

@end
