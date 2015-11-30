//
//  CaseTagTable.m
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseTagTable.h"
#import "OSNCaseManager.h"
#import "CaseTagCell.h"

@interface CaseTagTable ()

@property(nonatomic, strong) CaseTagCell *sampleCell;
@property(nonatomic, strong) NSMutableArray *sectionHeaderArray;

@end

@implementation CaseTagTable

static NSString * const cellReuseIdentifier = @"cellIdentifier";
static NSString * const sectionReuseIdentifier = @"sectionIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self loadTagData];
}

- (NSMutableArray *)sectionHeaderArray {
    if (!_sectionHeaderArray) {
        _sectionHeaderArray = [NSMutableArray array];
    }
    return _sectionHeaderArray;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionHeaderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CaseTagSection *sectionHeader = _sectionHeaderArray[section];
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
    CaseTagCell *cell = (CaseTagCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[CaseTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.sampleCell) {
        self.sampleCell = [[CaseTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    [self configureCell:self.sampleCell atIndexPath:indexPath];
    CGFloat cellHeight = [self.sampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)configureCell:(CaseTagCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    OSNTagPadView *tagView = cell.tagPadView;
    [tagView removeAllTags];
    
    CaseTagSection *section = _sectionHeaderArray[indexPath.section];
    [section.group.list enumerateObjectsUsingBlock:^(OSNTag *tag, NSUInteger idx, BOOL *stop) {
        [tagView addTag:tag];
    }];
    
    tagView.selectedIndex = section.selectedTagIndex;
    tagView.delegate = section;
}


#pragma mark - CaseTagSectionDelegate

- (void)openedSectionHeaderView:(UIView *)sender {
    CaseTagSection *sectionHeader = (CaseTagSection *)sender;
    NSInteger sectionIndex = [_sectionHeaderArray indexOfObject:sectionHeader];
    NSMutableArray *indexPathsToInsert = [NSMutableArray array];
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)closedSectionHeaderView:(UIView *)sender {
    CaseTagSection *sectionHeader = (CaseTagSection *)sender;
    NSInteger sectionIndex = [_sectionHeaderArray indexOfObject:sectionHeader];
    NSMutableArray *indexPathsToDelete = [NSMutableArray array];
    [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)sectionHeader:(CaseTagSection *)section didSelectTag:(OSNTag *)tag {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(caseTagTable:didChangeSelectedTags:)]) {
            NSDictionary *selectedResult = [self getAllSelectedTagResult];
            [self.delegate caseTagTable:self didChangeSelectedTags:selectedResult];
        }
    }
}


#pragma mark - private method

- (NSDictionary *)getAllSelectedTagResult {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (CaseTagSection *section in _sectionHeaderArray) {
        NSString *groupType = section.group.type;
        OSNTag *tag = section.group.list[section.selectedTagIndex];
        dic[groupType] = tag.enumId;
    }
    return dic;
}

- (void)loadTagData {
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("loadTagData", nil);
    dispatch_sync(queue, ^{
        OSNCaseManager *manager = [[OSNCaseManager alloc] init];
        NSArray *groups = [manager getCaseTagList];
        for (OSNTagGroup *group in groups) {
            CaseTagSection *section = [[CaseTagSection alloc] initWithReuseIdentifier:sectionReuseIdentifier];
            section.group = group;
            section.delegate = weakSelf;
            [weakSelf.sectionHeaderArray addObject:section];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    });
}

@end
