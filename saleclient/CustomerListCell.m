//
//  CustomerListCell.m
//  saleclient
//
//  Created by Frank on 15/12/7.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CustomerListCell.h"
#import "CustomerDetailMaster.h"
#import "AppDelegate.h"

@interface CustomerListCell()

@property(nonatomic, strong) NSString *customerId;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *gender;
@property(nonatomic, strong) UILabel *mobile;
@property(nonatomic, strong) UILabel *status;
@property(nonatomic, strong) UILabel *type;
@property(nonatomic, strong) UILabel *createTime;
@property(nonatomic, strong) UILabel *guider;
@property(nonatomic, strong) UIButton *operation;

@end

@implementation CustomerListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView.mas_left).offset(90);
        }];
        
        [self.contentView addSubview:self.gender];
        [self.gender mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.name.mas_centerX).offset(90);
        }];
        
        [self.contentView addSubview:self.mobile];
        [self.mobile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.gender.mas_centerX).offset(100);
        }];
        
        [self.contentView addSubview:self.status];
        [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.mobile.mas_centerX).offset(140);
        }];
        
        [self.contentView addSubview:self.type];
        [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.status.mas_centerX).offset(120);
        }];
        
        [self.contentView addSubview:self.createTime];
        [self.createTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.type.mas_centerX).offset(180);
        }];
        
        [self.contentView addSubview:self.guider];
        [self.guider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.createTime.mas_centerX).offset(140);
        }];
        
        [self.contentView addSubview:self.operation];
        [self.operation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.guider.mas_centerX).offset(80);
        }];
        
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = RGB(244, 244, 244);
        [self.contentView addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCustomer:(OSNCustomerListItem *)customer {
    _customer = customer;
    if (customer) {
        self.customerId = customer.customerId;
        self.name.text = customer.customerName;
        self.gender.text = customer.genderName;
        self.mobile.text = customer.mobile;
        self.status.text = customer.statusName;
        self.type.text = customer.typeName;
        self.createTime.text = customer.createdStamp;
        self.guider.text = customer.guiderName;
    }
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont systemFontOfSize:14];
    }
    return _name;
}

- (UILabel *)gender {
    if (!_gender) {
        _gender = [[UILabel alloc] init];
        _gender.font = [UIFont systemFontOfSize:14];
    }
    return _gender;
}

- (UILabel *)mobile {
    if (!_mobile) {
        _mobile = [[UILabel alloc] init];
        _mobile.font = [UIFont systemFontOfSize:14];
    }
    return _mobile;
}

- (UILabel *)status {
    if (!_status) {
        _status = [[UILabel alloc] init];
        _status.font = [UIFont systemFontOfSize:14];
    }
    return _status;
}

- (UILabel *)type {
    if (!_type) {
        _type = [[UILabel alloc] init];
        _type.font = [UIFont systemFontOfSize:14];
    }
    return _type;
}

- (UILabel *)createTime {
    if (!_createTime) {
        _createTime = [[UILabel alloc] init];
        _createTime.font = [UIFont systemFontOfSize:13];
    }
    return _createTime;
}

- (UILabel *)guider {
    if (!_guider) {
        _guider = [[UILabel alloc] init];
        _guider.font = [UIFont systemFontOfSize:14];
    }
    return _guider;
}

- (UIButton *)operation {
    if (!_operation) {
        _operation = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operation setTitle:@"客户档案" forState:UIControlStateNormal];
        [_operation setTitleColor:RGB(67, 176, 250) forState:UIControlStateNormal];
        _operation.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_operation addTarget:self action:@selector(customerDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operation;
}


- (void)customerDetailButtonClick:(UIButton *)sender {
    CustomerDetailMaster *detail = [[CustomerDetailMaster alloc] initWithCustomerId:self.customerId];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.mainNav pushViewController:detail animated:YES];
}

@end
