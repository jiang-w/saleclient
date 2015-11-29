//
//  CaseImageList.m
//  saleclient
//
//  Created by Frank on 15/11/29.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseImageList.h"
#import "CaseImageCell.h"
#import "OSNCaseManager.h"

@interface CaseImageList ()

@property(nonatomic, assign) NSUInteger viewSize;
@property(nonatomic, assign) NSUInteger viewIndex;
@property(nonatomic, strong) NSMutableArray *caseList;

@property(nonatomic, copy) NSString *roomId;
@property(nonatomic, copy) NSString *styleId;
@property(nonatomic, copy) NSString *houseTypeId;

@end

@implementation CaseImageList
{
    OSNCaseManager *_manager;
}

static NSString * const reuseIdentifier = @"caseImageCell";

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(358, 285);
    layout.sectionInset = UIEdgeInsetsMake(26, 18, 26, 18);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _viewSize = 6;
        _viewIndex = 1;
        _caseList = [NSMutableArray array];
        _manager = [[OSNCaseManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = RGB(244, 244, 244);
    // Register cell classes
    [self.collectionView registerClass:[CaseImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self loadCaseList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.caseList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath { 
    CaseImageCell *cell = (CaseImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.entity = self.caseList[indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - CaseTagTableDelegate

-(void)caseTagTable:(CaseTagTable *)table didChangeSelectedTags:(NSDictionary *)rusult {
    self.roomId = rusult[@"room"];
    self.styleId = rusult[@"style"];
    self.houseTypeId = rusult[@"houseType"];
    [self.caseList removeAllObjects];
    self.viewIndex = 1;
    [self loadCaseList];
    
    [self.collectionView reloadData];
}


#pragma mark - private method

- (void)loadCaseList {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"roomId"] = self.roomId;
    paramDic[@"styleId"] = self.styleId;
    paramDic[@"houseTypeId"] = self.houseTypeId;
    paramDic[@"viewSize"] = [NSString stringWithFormat:@"%lu", self.viewSize];
    paramDic[@"viewIndex"] = [NSString stringWithFormat:@"%lu", self.viewIndex];
    NSArray *list = [_manager getCaseListWithParameters:paramDic];
    [self.caseList addObjectsFromArray:list];
}

- (void)loadMoreCaseList {
    self.viewIndex++;
    [self loadCaseList];
}


@end
