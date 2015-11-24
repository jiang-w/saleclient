//
//  SectionHeaderView.m
//  saleclient
//
//  Created by Frank on 15/11/24.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "TagSectionHeaderView.h"
#import <Masonry.h>

@interface TagSectionHeaderView()

@property(nonatomic, strong) UILabel *lblTitle;
@property(nonatomic, strong) UIButton *btnDisclosure;

@end

@implementation TagSectionHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(tapSectionView:)];
        [self addGestureRecognizer:tapGesture];
        
        [self addSubview:self.lblTitle];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-60);
        }];
        
        [self addSubview:self.btnDisclosure];
        [self.btnDisclosure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.width.height.mas_equalTo(40);
        }];
    }
    return self;
}

- (void)tapSectionView:(UITapGestureRecognizer *)sender {
    self.viewModel.isOpen = !self.viewModel.isOpen;
    self.btnDisclosure.selected = self.viewModel.isOpen;
    if (self.delegate) {
        if (self.viewModel.isOpen) {
            
        }
        else {
            
        }
    }
}

- (void)setViewModel:(TagSectionHeaderViewModel *)viewModel {
    _viewModel = viewModel;
    self.lblTitle.text = viewModel.group.name;
    self.btnDisclosure.selected = viewModel.isOpen;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
    }
    return _lblTitle;
}

- (UIButton *)btnDisclosure {
    if (!_btnDisclosure) {
        _btnDisclosure = [[UIButton alloc] init];
        [_btnDisclosure setImage:[UIImage imageNamed:@"pro_lm1.gif"] forState:UIControlStateNormal];
        [_btnDisclosure setImage:[UIImage imageNamed:@"pro_lm.gif"] forState:UIControlStateSelected];
    }
    return _btnDisclosure;
}

@end
