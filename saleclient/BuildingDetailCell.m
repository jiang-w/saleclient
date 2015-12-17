//
//  BuildingDetailCell.m
//  saleclient
//
//  Created by Frank on 15/12/7.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "BuildingDetailCell.h"

@implementation BuildingDetailCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.image];
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self).offset(-40);
        }];
        
        [self addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.image.mas_bottom).offset(10);
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
        _name.font = [UIFont systemFontOfSize:14];
    }
    return _name;
}

@end
