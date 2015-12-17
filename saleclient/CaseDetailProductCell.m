//
//  CaseDetailProductCell.m
//  saleclient
//
//  Created by Frank on 15/12/6.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseDetailProductCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CaseDetailProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.image];
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(6);
            make.bottom.equalTo(self).offset(-6);
            make.width.mas_equalTo(80);
        }];
        
        [self addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self.image.mas_right).offset(10);
        }];
        
        [self addSubview:self.code];
        [self.code mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.name.mas_bottom).offset(2);
            make.left.equalTo(self.image.mas_right).offset(10);
        }];
        
        [self addSubview:self.size];
        [self.size mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.code.mas_bottom).offset(2);
            make.left.equalTo(self.image.mas_right).offset(10);
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
        _name.font = [UIFont systemFontOfSize:13];
        _name.textColor = [UIColor blackColor];
    }
    return _name;
}

- (UILabel *)code {
    if (!_code) {
        _code = [[UILabel alloc] init];
        _code.font = [UIFont systemFontOfSize:12];
        _code.textColor = [UIColor grayColor];
    }
    return _code;
}

- (UILabel *)size {
    if (!_size) {
        _size = [[UILabel alloc] init];
        _size.font = [UIFont systemFontOfSize:12];
        _size.textColor = [UIColor grayColor];
    }
    return _size;
}

@end
