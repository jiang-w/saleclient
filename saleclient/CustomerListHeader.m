//
//  CustomerListHeader.m
//  saleclient
//
//  Created by Frank on 15/12/7.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CustomerListHeader.h"

@interface CustomerListHeader()

@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *gender;
@property(nonatomic, strong) UILabel *mobile;
@property(nonatomic, strong) UILabel *status;
@property(nonatomic, strong) UILabel *type;
@property(nonatomic, strong) UILabel *createTime;
@property(nonatomic, strong) UILabel *guider;
@property(nonatomic, strong) UILabel *operation;

@end

@implementation CustomerListHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubviewStyleAndLayout];
        self.backgroundColor = RGB(248, 234, 218);
    }
    return self;
}

- (void)setSubviewStyleAndLayout {
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.mas_left).offset(90);
    }];
    
    [self addSubview:self.gender];
    [self.gender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.name.mas_centerX).offset(90);
    }];
    
    [self addSubview:self.mobile];
    [self.mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.gender.mas_centerX).offset(100);
    }];
    
    [self addSubview:self.status];
    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.mobile.mas_centerX).offset(140);
    }];
    
    [self addSubview:self.type];
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.status.mas_centerX).offset(120);
    }];
    
    [self addSubview:self.createTime];
    [self.createTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.type.mas_centerX).offset(160);
    }];
    
    [self addSubview:self.guider];
    [self.guider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.createTime.mas_centerX).offset(120);
    }];
    
    [self addSubview:self.operation];
    [self.operation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.guider.mas_centerX).offset(120);
    }];
}


- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont systemFontOfSize:14];
        _name.text = @"客户姓名";
        _name.textColor = [UIColor orangeColor];
    }
    return _name;
}

- (UILabel *)gender {
    if (!_gender) {
        _gender = [[UILabel alloc] init];
        _gender.font = [UIFont systemFontOfSize:14];
        _gender.text = @"性别";
        _gender.textColor = [UIColor orangeColor];
    }
    return _gender;
}

- (UILabel *)mobile {
    if (!_mobile) {
        _mobile = [[UILabel alloc] init];
        _mobile.font = [UIFont systemFontOfSize:14];
        _mobile.text = @"手机号码";
        _mobile.textColor = [UIColor orangeColor];
    }
    return _mobile;
}

- (UILabel *)status {
    if (!_status) {
        _status = [[UILabel alloc] init];
        _status.font = [UIFont systemFontOfSize:14];
        _status.text = @"客户状态";
        _status.textColor = [UIColor orangeColor];
    }
    return _status;
}

- (UILabel *)type {
    if (!_type) {
        _type = [[UILabel alloc] init];
        _type.font = [UIFont systemFontOfSize:14];
        _type.text = @"客户类型";
        _type.textColor = [UIColor orangeColor];
    }
    return _type;
}

- (UILabel *)createTime {
    if (!_createTime) {
        _createTime = [[UILabel alloc] init];
        _createTime.font = [UIFont systemFontOfSize:14];
        _createTime.text = @"创建时间";
        _createTime.textColor = [UIColor orangeColor];
    }
    return _createTime;
}

- (UILabel *)guider {
    if (!_guider) {
        _guider = [[UILabel alloc] init];
        _guider.font = [UIFont systemFontOfSize:14];
        _guider.text = @"导购";
        _guider.textColor = [UIColor orangeColor];
    }
    return _guider;
}

- (UILabel *)operation {
    if (!_operation) {
        _operation = [[UILabel alloc] init];
        _operation.font = [UIFont systemFontOfSize:14];
        _operation.text = @"操作";
        _operation.textColor = [UIColor orangeColor];
    }
    return _operation;
}

@end
