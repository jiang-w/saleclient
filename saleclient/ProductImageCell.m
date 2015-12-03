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
@property(nonatomic, strong) UIButton *favorite;

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
        make.centerY.equalTo(bgView);
        make.left.lessThanOrEqualTo(bgView).offset(40);
    }];
    
    [bgView addSubview:self.favorite];
    [self.favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView).offset(-40);
        make.width.height.mas_offset(20);
        make.left.greaterThanOrEqualTo(self.name.mas_right).offset(2);
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
        _name.font = [UIFont systemFontOfSize:16];
    }
    return _name;
}

- (UIButton *)favorite {
    if (!_favorite) {
        _favorite = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favorite setImage:[UIImage imageNamed:@"link.png"] forState:UIControlStateNormal];
        [_favorite setImage:[UIImage imageNamed:@"link.png"] forState:UIControlStateSelected];
        [_favorite addTarget:self action:@selector(didSelectFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favorite;
}

//- (void)setEntity:(OSNCaseEntity *)entity {
//    _entity = entity;
//    if (entity) {
//        self.name.text = entity.exhibitionName;
//        //        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:entity.imagePath]]];
//        //        [self.image setImage:img];
//        [self.image sd_setImageWithURL:[NSURL URLWithString:entity.imagePath]];
//    }
//}


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
