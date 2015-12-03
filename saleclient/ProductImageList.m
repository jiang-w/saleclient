//
//  ProductImageList.m
//  saleclient
//
//  Created by Frank on 15/12/3.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ProductImageList.h"
#import "ProductImageCell.h"
#import <Masonry.h>

@interface ProductImageList ()

@property(nonatomic, strong) UICollectionView *imageList;
@property(nonatomic, strong) OSNTagPadView *subTagView;

@property(nonatomic, strong) UIView *testView;

@end

@implementation ProductImageList

static NSString * const reuseIdentifier = @"productImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 244, 244);
    
    [self.imageList registerClass:[ProductImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:self.imageList];
    [self.imageList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [self.testView addSubview:self.subTagView];
//    [self.subTagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.testView);
//    }];
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
        _imageList.backgroundColor = [UIColor redColor];
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
        _subTagView.fixTagSize =CGSizeMake(105, 30);
        _subTagView.backgroundColor = [UIColor yellowColor];
    }
    return _subTagView;
}

- (UIView *)testView {
    if (!_testView) {
        _testView = [[UIView alloc] init];
        _testView.backgroundColor = [UIColor yellowColor ];
    }
    return _testView;
}


- (void)productTagTable:(ProductTagTable *)table didChangeSelectedTag:(OSNTag *)tag {
    if (tag.subTags && tag.subTags.count > 0) {
        
        [self.view addSubview:self.testView];
        [self.testView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(100);
        }];
        
        [self.imageList  mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.testView.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    else {
        [self.testView removeFromSuperview];
        
        [self.imageList mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
    }
}

- (void)configureTagViewWithSubTags:(NSArray *)tags {
    OSNTagPadView *tagView = self.subTagView;
//    tagView.selectedIndex = -1;
    [tagView removeAllTags];
    
    [tags enumerateObjectsUsingBlock:^(OSNTag *tag, NSUInteger idx, BOOL *stop) {
        [tagView addTag:tag];
    }];
    tagView.selectedIndex = 0;
}

@end
