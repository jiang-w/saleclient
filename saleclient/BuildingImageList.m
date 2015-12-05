//
//  BuildingImageList.m
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "BuildingImageList.h"
#import "BuildingImageCell.h"
#import "OSNBuildingManager.h"
#import "OSNUserManager.h"
#import <MJRefresh.h>

@interface BuildingImageList ()

@property(nonatomic, assign) NSUInteger viewSize;
@property(nonatomic, assign) NSUInteger viewIndex;
@property(nonatomic, copy) NSString *buildingName;
@property(nonatomic, copy) NSString *provinceId;
@property(nonatomic, copy) NSString *cityId;
@property(nonatomic, copy) NSString *areaId;
@property(nonatomic, strong) NSMutableArray *buildingList;

@end

@implementation BuildingImageList
{
    OSNBuildingManager *_manager;
}

static NSString * const reuseIdentifier = @"buildingImageCell";

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
        _buildingList = [NSMutableArray array];
        _manager = [[OSNBuildingManager alloc] init];
        
        OSNUserInfo *user = [OSNUserManager sharedInstance].currentUser;
        _provinceId = user.provinceId;
        _cityId = user.cityId;
        _areaId = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = RGB(244, 244, 244);
    self.collectionView.alwaysBounceVertical = YES;
    
    // Register cell classes
    [self.collectionView registerClass:[BuildingImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // 上拉刷新
    __weak __typeof__(self) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreBuildingList];
    }];

    [self loadBuildingList];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.buildingList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BuildingImageCell *cell = (BuildingImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.entity = self.buildingList[indexPath.row];
    return cell;
}

- (void)loadBuildingList {
    self.viewIndex = 1;
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("updateCaseList", nil);
    dispatch_async(queue, ^{
        NSArray *list = [weakSelf requestBuildingList];
        [weakSelf.buildingList removeAllObjects];
        [weakSelf.buildingList addObjectsFromArray:list];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 滚动到列表顶部
            CGFloat width = weakSelf.collectionView.frame.size.width;
            CGFloat height = weakSelf.collectionView.frame.size.height;
            [weakSelf.collectionView scrollRectToVisible:CGRectMake(0, 0, width, height) animated:NO];
            // 刷新列表数据
            [weakSelf.collectionView reloadData];
        });
    });
}

- (void)loadMoreBuildingList {
    self.viewIndex++;
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("updateCaseList", nil);
    dispatch_async(queue, ^{
        NSArray *list = [weakSelf requestBuildingList];
        [weakSelf.buildingList addObjectsFromArray:list];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    });
}

- (NSArray *)requestBuildingList {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"viewSize"] = [NSString stringWithFormat:@"%lu", self.viewSize];
    paramters[@"viewIndex"] = [NSString stringWithFormat:@"%lu", self.viewIndex];
    paramters[@"buildingName"] = self.buildingName?: @"";
    paramters[@"provinceId"] = self.provinceId;
    paramters[@"cityId"] = self.cityId;
    paramters[@"areaId"] = self.areaId;
    NSArray *list = [_manager getBuildingListWithParameters:paramters];
    return list;
}

#pragma mark - <BuildingLeftSiderDelegate>

- (void)didSelectArea:(OSNAreaEntity *)area andKeyword:(NSString *)keyword {
    self.provinceId = area.provinceId;
    self.cityId = area.cityId;
    self.areaId = area.areaId;
    self.buildingName = keyword;
    
    [self loadBuildingList];
}

@end
