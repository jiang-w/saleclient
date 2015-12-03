//
//  ProductImageCell.m
//  saleclient
//
//  Created by Frank on 15/12/3.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ProductImageCell.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProductImageCell()

@property(nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) UILabel *name;

@end

@implementation ProductImageCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubviewAndLayout];
    }
    return self;
}

- (void)setSubviewAndLayout {
    [self.contentView addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    [bgView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
}

#pragma mark - property

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc]init];
        [_image setBackgroundColor:[UIColor whiteColor]];
        _image.layer.masksToBounds=YES; // 隐藏边界
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCaseImage)];
        [_image addGestureRecognizer:tapGesture];
        _image.userInteractionEnabled = YES;
    }
    return _image;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = [UIColor blackColor];
        _name.font = [UIFont systemFontOfSize:14];
    }
    return _name;
}

- (void)setEntity:(OSNProductEntity *)entity {
    _entity = entity;
    if (entity) {
        self.name.text = [NSString stringWithFormat:@"%@ %@", entity.ocnProductCode, entity.ocnProductName];
        [self.image sd_setImageWithURL:[NSURL URLWithString:entity.imagePath]];
    }
}


#pragma mark - event

- (void)didSelectFavoriteButton:(UIButton *)button {
    
}

- (void)didTapCaseImage {
//    CaseDetailViewController *detail = [[CaseDetailViewController alloc] initWithNibName:@"CaseDetailViewController" bundle:nil];
//    detail.exhibitionId = self.entity.exhibitionId;
//    UINavigationController *mainNav = (UINavigationController *)[OSNMainDelegate window].rootViewController;
//    [mainNav pushViewController:detail animated:YES];
}

@end
