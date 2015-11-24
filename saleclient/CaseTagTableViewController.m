//
//  TagTableViewController.m
//  saleclient
//
//  Created by Frank on 15/11/24.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseTagTableViewController.h"
#import "OSNCaseManager.h"

@interface CaseTagTableViewController ()

@end

@implementation CaseTagTableViewController
{
    OSNCaseManager *_manager;
    NSMutableArray *_sectionHeaderViewList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sectionHeaderViewList = [NSMutableArray array];
    _manager = [[OSNCaseManager alloc] init];
    NSArray *groups = [_manager getCaseTagList];
    NSInteger index = 0;
    for (OSNTagGroup *group in groups) {
        TagSectionHeaderView *sectionHeader = [[TagSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.sectionHeaderHeight)];
        sectionHeader.viewModel = [[TagSectionHeaderViewModel alloc] initWithGroup:group andIndex:index];
        sectionHeader.delegate = self;
        [_sectionHeaderViewList addObject:sectionHeader];
        index++;
    }
    
    self.tableView.sectionHeaderHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionHeaderViewList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TagSectionHeaderView *sectionHeader = _sectionHeaderViewList[section];
    if (sectionHeader.viewModel.isOpen) {
        return sectionHeader.viewModel.group.list.count;
    }
    else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _sectionHeaderViewList[section];
}

- (void)openedSectionHeaderView:(TagSectionHeaderView *)view withIndex:(NSInteger)index {
    
}

- (void)closedSectionHeaderView:(TagSectionHeaderView *)view withIndex:(NSInteger)index {
    
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

@end
