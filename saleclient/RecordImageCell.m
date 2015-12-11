//
//  RecordImageCell.m
//  saleclient
//
//  Created by Frank on 15/12/11.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "RecordImageCell.h"
#import <Masonry.h>

@implementation RecordImageCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubviewAndLayout];
    }
    return self;
}

- (void)setSubviewAndLayout {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-30);
    }];
    
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-8);
    }];
}


#pragma mark - property

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

@end
