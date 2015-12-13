//
//  CustomerListViewController.m
//  saleclient
//
//  Created by Frank on 15/12/7.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CustomerListViewController.h"
#import "OSNCustomerManager.h"
#import "CustomerListCell.h"
#import "CustomerListHeader.h"
#import <MJRefresh.h>
#import <Masonry.h>

@interface CustomerListViewController ()

@property(nonatomic, assign) NSUInteger viewSize;
@property(nonatomic, assign) NSUInteger viewIndex;
@property(nonatomic, copy) NSString *queryValue;
@property(nonatomic, strong) NSMutableArray *customerList;

@property(nonatomic, strong) UIView *tableHeader;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation CustomerListViewController
{
    OSNCustomerManager *_manager;
}

static NSString * const reuseIdentifier = @"customerListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewSize = 30;
    self.viewIndex = 1;
    self.customerList = [NSMutableArray array];
    _manager = [[OSNCustomerManager alloc] init];
    
    [self.view addSubview:self.tableHeader];
    [self.tableHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.tableHeader.mas_bottom);
    }];
  
    [self.tableView registerClass:[CustomerListCell class] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 上拉下拉刷新
    __weak __typeof__(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreCustomerList];
    }];
    MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadCustomerListData];
    }];
    mjHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = mjHeader;
    
    [weakSelf loadCustomerListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerListCell *cell = (CustomerListCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.customer = self.customerList[indexPath.row];
    return cell;
}


#pragma mark - request data

- (void)loadCustomerListData {
    self.viewIndex = 1;
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("loadCustomerList", nil);
    dispatch_async(queue, ^{
        NSArray *list = [weakSelf requestCustomerList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.customerList removeAllObjects];
            [weakSelf.customerList addObjectsFromArray:list];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    });
}

- (void)loadMoreCustomerList {
    self.viewIndex++;
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("loadCustomerList", nil);
    dispatch_async(queue, ^{
        NSArray *list = [weakSelf requestCustomerList];
        [weakSelf.customerList addObjectsFromArray:list];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    });
}

- (NSArray *)requestCustomerList {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"viewIndex"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewIndex];
    paramters[@"viewSize"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewSize];
    if (!IS_EMPTY_STRING(self.queryValue)) {
        paramters[@"queryValue"] = self.queryValue;
    }
    NSArray *list = [_manager getCustomerList:paramters];
    return list;
}


#pragma mark - property

- (UIView *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[CustomerListHeader alloc] init];
    }
    return _tableHeader;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)masterViewController:(MasterViewController *)master searchWithKeyword:(NSString *)keyword {
    NSLog(@"CustomerListViewController search keyword: %@", keyword);
    self.queryValue = keyword;
    [self loadCustomerListData];
}

@end
