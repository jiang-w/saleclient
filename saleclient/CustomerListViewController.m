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

@interface CustomerListViewController ()

@property(nonatomic, assign) NSUInteger viewSize;
@property(nonatomic, assign) NSUInteger viewIndex;
@property(nonatomic, copy) NSString *queryValue;
@property(nonatomic, strong) NSMutableArray *customerList;

@end

@implementation CustomerListViewController

static NSString * const reuseIdentifier = @"customerListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewSize = 30;
    self.viewIndex = 1;
    self.queryValue = @"";
    self.customerList = [NSMutableArray array];
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadCustomerListData {
    self.viewIndex = 1;
    OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("loadCustomerList", nil);
    dispatch_async(queue, ^{
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        paramters[@"viewIndex"] = [NSString stringWithFormat:@"%lu", weakSelf.viewIndex];
        paramters[@"viewSize"] = [NSString stringWithFormat:@"%lu", weakSelf.viewSize];
        paramters[@"queryValue"] = weakSelf.queryValue;
        
        NSArray *list = [manager getCustomerList:paramters];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.customerList removeAllObjects];
            [weakSelf.customerList addObjectsFromArray:list];
            [self.tableView reloadData];
        });
    });
}

@end
