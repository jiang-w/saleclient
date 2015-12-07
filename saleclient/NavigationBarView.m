//
//  NavigationBarView.m
//  saleclient
//
//  Created by Frank on 15/12/8.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "NavigationBarView.h"
#import <Masonry.h>
#import "AppDelegate.h"

@interface NavigationBarView()

@property(nonatomic, strong) UIButton *back;
@property(nonatomic, strong) UIButton *note;
@property(nonatomic, strong) UIButton *qcode;
@property(nonatomic, strong) UIButton *shopping;
@property(nonatomic, strong) UIButton *history;

@end

@implementation NavigationBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubviewStyleAndLayout];
    }
    return self;
}

- (void)setSubviewStyleAndLayout {
    [self addSubview:self.back];
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(56);
        make.bottom.equalTo(self).offset(-16);
    }];
    
    [self addSubview:self.history];
    [self.history mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-33);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
    }];
    
    [self addSubview:self.shopping];
    [self.shopping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self.history.mas_left).offset(-32);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
    }];
    
    [self addSubview:self.qcode];
    [self.qcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self.shopping.mas_left).offset(-32);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
    }];
    
    [self addSubview:self.note];
    [self.note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self.qcode.mas_left).offset(-32);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
    }];
}

- (UIButton *)back {
    if (!_back) {
        _back = [UIButton buttonWithType:UIButtonTypeCustom];
        [_back setTitle:@"返回" forState:UIControlStateNormal];
        [_back setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _back.contentEdgeInsets = UIEdgeInsetsMake(4, 16, 4, 16);
        _back.titleLabel.font = [UIFont systemFontOfSize:18];
        _back.layer.borderColor = [UIColor orangeColor].CGColor;
        _back.layer.borderWidth = 1;
        _back.layer.cornerRadius = 5;
        
        [_back addTarget:self action:@selector(goBackHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _back;
}

- (UIButton *)note {
    if (!_note) {
        _note = [UIButton buttonWithType:UIButtonTypeCustom];
        _note.imageView.image = [UIImage imageNamed:@"history_ico.png"];
    }
    return _note;
}

- (UIButton *)qcode {
    if (!_qcode) {
        _qcode = [UIButton buttonWithType:UIButtonTypeCustom];
        _qcode.imageView.image = [UIImage imageNamed:@"qcode_ico.png"];
    }
    return _qcode;
}

- (UIButton *)shopping {
    if (!_shopping) {
        _shopping = [UIButton buttonWithType:UIButtonTypeCustom];
        _shopping.imageView.image = [UIImage imageNamed:@"shopping_ico.png"];
    }
    return _shopping;
}

- (UIButton *)history {
    if (!_history) {
        _history = [UIButton buttonWithType:UIButtonTypeCustom];
        _history.imageView.image = [UIImage imageNamed:@"historyview_ico.png"];
    }
    return _history;
}


- (void)goBackHandle:(UIButton *)sender {
    AppDelegate *app = OSNMainDelegate;
    [app.mainNav popViewControllerAnimated:YES];
}

@end
