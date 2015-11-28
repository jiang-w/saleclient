//
//  OSNCaseTagListVC.m
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNCaseTagListVC.h"
#import "OSNCaseManager.h"
#import "OSNTagListCell.h"

static NSString * const cellReuseIdentifier = @"cellIdentifier";
static NSString * const sectionReuseIdentifier = @"sectionIdentifier";

@interface OSNCaseTagListVC ()

@end

@implementation OSNCaseTagListVC
{
    NSMutableArray *_sectionHeaderArray;
    OSNTagListCell *_sampleCell;
    OSNTagPadView *_tagPadView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    _sectionHeaderArray = [NSMutableArray array];
    NSArray *groups = [[[OSNCaseManager alloc] init] getCaseTagList];
    for (OSNTagGroup *group in groups) {
        OSNTagListSection *section = [[OSNTagListSection alloc] initWithReuseIdentifier:sectionReuseIdentifier];
        section.group = group;
        section.delegate = self;
        [_sectionHeaderArray addObject:section];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionHeaderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OSNTagListSection *sectionHeader = _sectionHeaderArray[section];
    if (sectionHeader.isOpen && sectionHeader.group.list.count > 0) {
        return 1;
    }
    else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _sectionHeaderArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OSNTagListCell *cell = (OSNTagListCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[OSNTagListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_sampleCell) {
        _sampleCell = [[OSNTagListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    [self configureCell:_sampleCell atIndexPath:indexPath];
    CGFloat cellHeight = [_sampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)configureCell:(OSNTagListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    OSNTagPadView *tagView = cell.tagPadView;
    [tagView removeAllTags];
    
    OSNTagListSection *section = _sectionHeaderArray[indexPath.section];
    [section.group.list enumerateObjectsUsingBlock:^(OSNTag *tag, NSUInteger idx, BOOL *stop) {
        [tagView addTag:tag];
    }];
    
    tagView.selectedIndex = section.selectedTagIndex;
    tagView.delegate = section;
}


#pragma mark - OSNSectionHeaderViewDelegate

- (void)openedSectionHeaderView:(UIView *)sender {
    OSNTagListSection *sectionHeader = (OSNTagListSection *)sender;
    NSInteger sectionIndex = [_sectionHeaderArray indexOfObject:sectionHeader];
    NSMutableArray *indexPathsToInsert = [NSMutableArray array];
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)closedSectionHeaderView:(UIView *)sender {
    OSNTagListSection *sectionHeader = (OSNTagListSection *)sender;
    NSInteger sectionIndex = [_sectionHeaderArray indexOfObject:sectionHeader];
    NSMutableArray *indexPathsToDelete = [NSMutableArray array];
    [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)sectionHeader:(OSNTagListSection *)section didSelectTag:(OSNTag *)tag {
    NSLog(@"Selected Tag: %@", tag.name);
}

@end
