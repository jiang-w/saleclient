//
//  ProductImageList.m
//  saleclient
//
//  Created by Frank on 15/12/3.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ProductImageList.h"
#import "ProductImageCell.h"
#import "OSNProductManager.h"
#import <MJRefresh.h>

@interface ProductImageList ()

@property(nonatomic, strong) UICollectionView *imageList;
@property(nonatomic, strong) OSNTagPadView *subTagView;
@property(nonatomic, strong) NSMutableDictionary *paramters;
@property(nonatomic, strong) NSMutableArray *productList;
@property(nonatomic, assign) NSUInteger viewSize;
@property(nonatomic, assign) NSUInteger viewIndex;
@property(nonatomic, copy) NSString *keyword;

@end

@implementation ProductImageList

static NSString * const reuseIdentifier = @"productImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 244, 244);
    
    self.viewIndex = 1;
    self.viewSize = 20;
    self.paramters = [NSMutableDictionary dictionaryWithDictionary:@{@"recommendId": @"10000", @"type": @"recommend"}];
    self.productList = [NSMutableArray array];
    [self.imageList registerClass:[ProductImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:self.imageList];
    [self.imageList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak __typeof__(self) weakSelf = self;
    // 下拉刷新
    self.imageList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadProductList];
        [weakSelf.imageList.mj_footer resetNoMoreData];
    }];
    
    // 上拉刷新
    self.imageList.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreProductList];
    }];
    // 加载数据
    [self loadProductList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchWithKeyword:(NSString *)keyword {
    self.keyword = keyword;
    [self loadProductList];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductImageCell *cell = (ProductImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.entity = self.productList[indexPath.row];
    return cell;
}


#pragma mark - property

- (UICollectionView *)imageList {
    if (!_imageList) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(168, 200);
        layout.sectionInset = UIEdgeInsetsMake(26, 18, 26, 18);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 24;
        _imageList = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imageList.backgroundColor = [UIColor whiteColor];
        _imageList.dataSource = self;
    }
    return _imageList;
}

- (OSNTagPadView *)subTagView {
    if (!_subTagView) {
        _subTagView = [[OSNTagPadView alloc] init];
        _subTagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        _subTagView.lineSpace = 10;
        _subTagView.tagSpace = 10;
        _subTagView.maxLayoutWidth = self.view.frame.size.width;
        _subTagView.backgroundColor = [UIColor whiteColor];
        _subTagView.delegate = self;
    }
    return _subTagView;
}


#pragma mark - <ProductTagTableDelegate>

- (void)productTagTable:(ProductTagTable *)table didChangeSelectedTag:(OSNTag *)tag {
    [self setViewLayoutWithSectionSelectedTag:tag];
    [self setParamterDictionaryWithSectionSelectedTag:tag];
    self.keyword = nil;
    [self loadProductList];
}


#pragma mark - <OSNTagPadViewDelegate>

- (void)tagPadView:(OSNTagPadView *)view didSelectTag:(OSNTag *)tag andIndex:(NSUInteger)index {
    self.paramters[@"subClassifyId"] = tag.enumId;
    self.keyword = nil;
    [self loadProductList];
}


#pragma mark - private method

- (void)setViewLayoutWithSectionSelectedTag:(OSNTag *)tag {
    if (tag.subTags && tag.subTags.count > 0) {
        [self configureTagViewWithSubTags:tag.subTags];
        
        [self.view addSubview:self.subTagView];
        [self.subTagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
        }];
        
        [self.imageList  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subTagView.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    else {
        [self.subTagView removeFromSuperview];
        
        [self.imageList mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
    }
}

- (void)configureTagViewWithSubTags:(NSArray *)tags {
    [self.subTagView removeAllTags];
    
    [tags enumerateObjectsUsingBlock:^(OSNTag *tag, NSUInteger idx, BOOL *stop) {
        [self.subTagView addTag:tag];
    }];
    self.subTagView.selectedIndex = 0;
}

- (void)setParamterDictionaryWithSectionSelectedTag:(OSNTag *)tag {
    if ([tag.enumTypeId isEqualToString:@"WORKPLACE_TYPE"]) {
        _paramters[@"recommendId"] = tag.enumId;
        _paramters[@"type"] = @"recommend";
    }
    if ([tag.enumTypeId isEqualToString:@"WEBSITE_OCN_CLASS"]) {
        _paramters[@"classifyId"] = tag.enumId;
        _paramters[@"type"] = @"classify";
        if (tag.subTags.count > 0) {
            OSNTag *selSubTag = tag.subTags[self.subTagView.selectedIndex];
            _paramters[@"subClassifyId"] = selSubTag.enumId;
        }
    }
    if ([tag.enumTypeId isEqualToString:@"WEBSITE_ROOM_SPACE"]) {
        _paramters[@"type"] = @"room";
        _paramters[@"roomId"] = tag.enumId;
    }
    if ([tag.enumTypeId isEqualToString:@"WEBSITE_HOME_STYLE"]) {
        _paramters[@"type"] = @"style";
        _paramters[@"styleId"] = tag.enumId;
    }
    if ([tag.enumTypeId isEqualToString:@"WEBSITE_OCN_SPCFCTN"]) {
        _paramters[@"type"] = @"standard";
        _paramters[@"standardId"] = tag.enumId;
    }
}


- (void)loadProductList {
    self.viewIndex = 1;
    self.paramters[@"viewIndex"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewIndex];
    self.paramters[@"viewSize"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewSize];
    if (self.keyword && self.keyword.length > 0) {
        self.paramters[@"queryItemValue"] = self.keyword;
    }
    else {
        [self.paramters removeObjectForKey:@"queryItemValue"];
    }
    
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("updateProductList", nil);
    dispatch_async(queue, ^{
        OSNProductManager *manager = [[OSNProductManager alloc] init];
        NSArray *list = [manager getProductListWithParameters:weakSelf.paramters];
        
        [weakSelf.productList removeAllObjects];
        [weakSelf.productList addObjectsFromArray:list];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 滚动到列表顶部
            CGFloat width = weakSelf.imageList.frame.size.width;
            CGFloat height = weakSelf.imageList.frame.size.height;
            [weakSelf.imageList scrollRectToVisible:CGRectMake(0, 0, width, height) animated:NO];
            // 刷新列表数据
            [weakSelf.imageList reloadData];
            [weakSelf.imageList.mj_header endRefreshing];
        });
    });
}

- (void)loadMoreProductList {
    self.viewIndex++;
    self.paramters[@"viewIndex"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewIndex];
    self.paramters[@"viewSize"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.viewSize];
    
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("updateCaseList", nil);
    dispatch_async(queue, ^{
        OSNProductManager *manager = [[OSNProductManager alloc] init];
        NSArray *list = [manager getProductListWithParameters:weakSelf.paramters];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (list.count > 0) {
                [weakSelf.productList addObjectsFromArray:list];
                [weakSelf.imageList reloadData];
                [weakSelf.imageList.mj_footer endRefreshing];
            }
            else {
                [weakSelf.imageList.mj_footer endRefreshingWithNoMoreData];
            }
        });
    });
}

@end
