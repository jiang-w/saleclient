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
#import <MJRefresh.h>

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
        _viewSize = 10;
        _viewIndex = 1;
        _caseList = [NSMutableArray array];
        _manager = [[OSNCaseManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = RGB(244, 244, 244);
    self.collectionView.alwaysBounceVertical = YES;
    
    // Register cell classes
    [self.collectionView registerClass:[CaseImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // 上拉刷新
    __weak __typeof__(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreCaseList];
    }];
    // 加载数据
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - CaseTagTableDelegate

- (void)caseTagTable:(CaseTagTable *)table didChangeSelectedTags:(NSDictionary *)rusult {
    self.roomId = rusult[@"room"];
    self.styleId = rusult[@"style"];
    self.houseTypeId = rusult[@"houseType"];
    
    [self loadCaseList];
}


#pragma mark - private method

- (void)loadCaseList {
    self.viewIndex = 1;
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("updateCaseList", nil);
    dispatch_async(queue, ^{
        NSArray *list = [weakSelf requestCaseList];
        [weakSelf.caseList removeAllObjects];
        [weakSelf.caseList addObjectsFromArray:list];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 滚动到列表顶部
            CGFloat width = weakSelf.collectionView.frame.size.width;
            CGFloat height = weakSelf.collectionView.frame.size.height;
            [weakSelf.collectionView scrollRectToVisible:CGRectMake(0, 0, width, height) animated:NO];
            // 刷新列表数据
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    });
}

- (void)loadMoreCaseList {
    self.viewIndex++;
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("updateCaseList", nil);
    dispatch_async(queue, ^{
        NSArray *list = [weakSelf requestCaseList];
        [weakSelf.caseList addObjectsFromArray:list];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    });
}

- (NSArray *)requestCaseList {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"roomId"] = self.roomId;
    paramDic[@"styleId"] = self.styleId;
    paramDic[@"houseTypeId"] = self.houseTypeId;
    paramDic[@"viewSize"] = [NSString stringWithFormat:@"%lu", self.viewSize];
    paramDic[@"viewIndex"] = [NSString stringWithFormat:@"%lu", self.viewIndex];
    NSArray *list = [_manager getCaseListWithParameters:paramDic];
    return list;
}

@end
