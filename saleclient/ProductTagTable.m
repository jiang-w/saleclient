//
//  ProductTagTable.m
//  saleclient
//
//  Created by Frank on 15/11/30.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ProductTagTable.h"
#import "OSNProductManager.h"
#import "OSNTagPadView.h"
#import "ProductTagCell.h"

@interface ProductTagTable ()

@property(nonatomic, strong) ProductTagCell *sampleCell;
@property(nonatomic, strong) NSMutableArray *sectionHeaderArray;

@end

@implementation ProductTagTable

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


#pragma mark - property

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
    ProductTagSection *sectionHeader = _sectionHeaderArray[section];
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
    ProductTagCell *cell = (ProductTagCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[ProductTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.sampleCell) {
        self.sampleCell = [[ProductTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    [self configureCell:self.sampleCell atIndexPath:indexPath];
    CGFloat cellHeight = [self.sampleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)configureCell:(ProductTagCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    OSNTagPadView *tagView = cell.tagPadView;
    [tagView removeAllTags];
    
    ProductTagSection *section = _sectionHeaderArray[indexPath.section];
    [section.group.list enumerateObjectsUsingBlock:^(OSNTag *tag, NSUInteger idx, BOOL *stop) {
        [tagView addTag:tag];
    }];
    
    tagView.selectedIndex = section.selectedTagIndex;
    tagView.delegate = section;
}


#pragma mark - ProductTagTableDelegate

- (void)openedSectionHeaderView:(UIView *)sender {
    ProductTagSection *sectionHeader = (ProductTagSection *)sender;
    NSInteger sectionIndex = [_sectionHeaderArray indexOfObject:sectionHeader];
    NSMutableArray *indexPathsToInsert = [NSMutableArray array];
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)closedSectionHeaderView:(UIView *)sender {
    ProductTagSection *sectionHeader = (ProductTagSection *)sender;
    NSInteger sectionIndex = [_sectionHeaderArray indexOfObject:sectionHeader];
    NSMutableArray *indexPathsToDelete = [NSMutableArray array];
    [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)sectionHeader:(ProductTagSection *)section didSelectTag:(OSNTag *)tag {
    for (ProductTagSection *item in self.sectionHeaderArray) {
        if (item != section) {
            item.selectedTagIndex = -1;
        }
    }
    [self.tableView reloadData];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(productTagTable:didChangeSelectedTag:)]) {
            [self.delegate productTagTable:self didChangeSelectedTag:tag];
        }
    }
}


#pragma mark - private method

- (void)loadTagData {
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("loadTagData", nil);
    dispatch_sync(queue, ^{
        OSNProductManager *manager = [[OSNProductManager alloc] init];
        NSArray *groups = [manager getProductTagList];
        for (OSNTagGroup *group in groups) {
            ProductTagSection *section = [[ProductTagSection alloc] initWithReuseIdentifier:sectionReuseIdentifier];
            if (weakSelf.sectionHeaderArray.count == 0) {
                section.selectedTagIndex = 0;
            }
            else {
                section.selectedTagIndex = -1;
            }
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
