//
//  HouseTypeCaseCell.m
//  saleclient
//
//  Created by Frank on 15/12/8.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "HouseTypeCaseCell.h"
#import <Masonry.h>

@implementation HouseTypeCaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.image];
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self).offset(-40);
        }];
        
        UIView *bottomBar = [[UIView alloc] init];
        bottomBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomBar];
        [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.image.mas_bottom);
        }];
        
        [bottomBar addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomBar);
            make.left.equalTo(bottomBar).offset(30);
        }];
        
        [bottomBar addSubview:self.favorite];
        [self.favorite mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomBar);
            make.right.equalTo(bottomBar).offset(-20);
            make.width.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
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

- (UIButton *)favorite {
    if (!_favorite) {
        _favorite = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favorite setImage:[UIImage imageNamed:@"link.png"] forState:UIControlStateNormal];
    }
    return _favorite;
}

@end
