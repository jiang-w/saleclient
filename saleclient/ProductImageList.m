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
#import <Masonry.h>

@interface ProductImageList ()

@property(nonatomic, strong) UICollectionView *imageList;
@property(nonatomic, strong) OSNTagPadView *subTagView;

@property(nonatomic, assign) NSUInteger viewSize;
@property(nonatomic, assign) NSUInteger viewIndex;
@property(nonatomic, strong) NSMutableDictionary *paramters;
@property(nonatomic, strong) NSMutableArray *productList;

@end

@implementation ProductImageList

static NSString * const reuseIdentifier = @"productImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 244, 244);
    
    self.viewSize = 10;
    self.viewIndex = 1;
    self.paramters = [NSMutableDictionary dictionary];
    self.productList = [NSMutableArray array];
    [self.imageList registerClass:[ProductImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:self.imageList];
    [self.imageList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductImageCell *cell = (ProductImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}


#pragma mark - property

- (UICollectionView *)imageList {
    if (!_imageList) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(358, 285);
        layout.sectionInset = UIEdgeInsetsMake(26, 18, 26, 18);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        _imageList = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    return _imageList;
}

- (OSNTagPadView *)subTagView {
    if (!_subTagView) {
        _subTagView = [[OSNTagPadView alloc] init];
        _subTagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        _subTagView.lineSpace = 10;
        _subTagView.tagSpace = 8;
        _subTagView.maxLayoutWidth = self.view.frame.size.width;
        _subTagView.backgroundColor = [UIColor whiteColor];
    }
    return _subTagView;
}


#pragma mark - ProductTagTableDelegate

- (void)productTagTable:(ProductTagTable *)table didChangeSelectedTag:(OSNTag *)tag {
    [self setViewLayoutWithSectionSelectedTag:tag];
    [self setParamterDictionaryWithSectionSelectedTag:tag];
    
    __weak __typeof__(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("loadProudctList", nil);
    dispatch_async(queue, ^{
        OSNProductManager *manager = [[OSNProductManager alloc] init];
        NSArray *list = [manager getProductListWithParameters:weakSelf.paramters];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
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
    _paramters[@"viewSize"] = [NSString stringWithFormat:@"%lu", self.viewSize];
    _paramters[@"viewIndex"] = [NSString stringWithFormat:@"%lu", self.viewIndex];
    
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

@end
