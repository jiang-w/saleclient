//
//  OSNCaseTagListVC.m
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNCaseTagListVC.h"
#import "OSNCaseManager.h"

@interface OSNCaseTagListVC ()

@end

@implementation OSNCaseTagListVC
{
    OSNCaseManager *_manager;
    NSMutableArray *_sectionHeaderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 40;
    self.numberOfTagsInCell = 3;
    
    _manager = [[OSNCaseManager alloc] init];
    _sectionHeaderArray = [NSMutableArray array];
    for (OSNTagGroup *group in [_manager getCaseTagList]) {
        OSNTagListSection *section = [[OSNTagListSection alloc] initWithReuseIdentifier:@"SectionHeaderIdentifier"];
        section.group = group;
        section.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.sectionHeaderHeight);
        section.delegate = self;
        [_sectionHeaderArray addObject:section];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionHeaderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OSNTagListSection *sectionHeader = _sectionHeaderArray[section];
    if (sectionHeader.isOpen) {
        return floor(sectionHeader.group.list.count * 1.0 / self.numberOfTagsInCell);
    }
    else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _sectionHeaderArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}


#pragma mark - OSNSectionHeaderViewDelegate

- (void)openedSectionHeaderView:(UIView *)sender {
    OSNTagListSection *sectionHeader = (OSNTagListSection *)sender;
    NSInteger sectionIndex = [_sectionHeaderArray indexOfObject:sectionHeader];
    NSInteger count = floor(sectionHeader.group.list.count * 1.0 / self.numberOfTagsInCell);
    if (count > 0) {
        NSMutableArray *indexPathsToInsert = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

- (void)closedSectionHeaderView:(UIView *)sender {
    OSNTagListSection *sectionHeader = (OSNTagListSection *)sender;
    NSInteger sectionIndex = [_sectionHeaderArray indexOfObject:sectionHeader];
    NSInteger count = [self.tableView numberOfRowsInSection:sectionIndex];
    if (count > 0) {
        NSMutableArray *indexPathsToDelete = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

@end
