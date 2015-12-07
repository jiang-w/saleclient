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

@interface CustomerListViewController ()

@property(nonatomic, assign) NSUInteger viewSize;
@property(nonatomic, assign) NSUInteger viewIndex;
@property(nonatomic, copy) NSString *queryValue;
@property(nonatomic, strong) NSMutableArray *customerList;

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
    self.queryValue = @"";
    self.customerList = [NSMutableArray array];
    _manager = [[OSNCustomerManager alloc] init];
  
    [self.tableView registerClass:[CustomerListCell class] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    // 上拉刷新
    __weak __typeof__(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreCustomerList];
    }];
    
    [self loadCustomerListData];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CustomerListHeader *header = [[CustomerListHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}


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
    paramters[@"viewIndex"] = [NSString stringWithFormat:@"%lu", self.viewIndex];
    paramters[@"viewSize"] = [NSString stringWithFormat:@"%lu", self.viewSize];
    paramters[@"queryValue"] = self.queryValue;
    NSArray *list = [_manager getCustomerList:paramters];
    return list;
}


@end
