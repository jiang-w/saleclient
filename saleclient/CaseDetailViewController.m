//
//  CaseDetailViewController.m
//  saleclient
//
//  Created by Frank on 15/11/30.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseDetailViewController.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface CaseDetailViewController ()

@property(nonatomic, strong) OSNCaseEntity *caseEntity;
@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UIImageView *caseImage;
@property(nonatomic, strong) UIButton *history;
@property(nonatomic, strong) UIButton *shopping;
@property(nonatomic, strong) UIButton *qCode;
@property(nonatomic, strong) UIButton *notes;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UIImageView *personImage;
@property(nonatomic, strong) UILabel *personName;
@property(nonatomic, strong) UITableView *productTable;

@end

@implementation CaseDetailViewController

- (instancetype)initWithCaseEntity:(OSNCaseEntity *)entity {
    self = [super init];
    if (self) {
        _caseEntity = entity;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 244, 244);
    
    [self setSubViewAndLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setSubViewAndLayout {
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(76);
    }];
    
    [navView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView).offset(-16);
        make.left.equalTo(navView).offset(56);
    }];
    
    [navView addSubview:self.history];
    [self.history mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
        make.right.equalTo(navView).offset(-33);
    }];
    
    [navView addSubview:self.shopping];
    [self.shopping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
        make.right.equalTo(self.history.mas_left).offset(-32);
    }];
    
    [navView addSubview:self.qCode];
    [self.qCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
        make.right.equalTo(self.shopping.mas_left).offset(-32);
    }];
    
    [navView addSubview:self.notes];
    [self.notes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navView);
        make.width.mas_equalTo(37);
        make.height.mas_equalTo(51);
        make.right.equalTo(self.qCode.mas_left).offset(-32);
    }];
    
    UIView *rightSide = [[UIView alloc] init];
    rightSide.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightSide];
    [rightSide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_bottom);
        make.right.bottom.equalTo(self.view);
        make.width.mas_offset(280);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.right.equalTo(rightSide.mas_left);
        make.height.mas_equalTo(120);
    }];
    
    [self.view addSubview:self.caseImage];
    [self.caseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_bottom);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(rightSide.mas_left).offset(-20);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [rightSide addSubview:self.personImage];
    [self.personImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightSide).offset(10);
        make.top.equalTo(rightSide).offset(20);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(52);
    }];
    
    [rightSide addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightSide).offset(20);
        make.top.equalTo(self.personImage.mas_bottom).offset(10);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"推荐人群：";
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor grayColor];
    [rightSide addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(12);
        make.left.equalTo(rightSide).offset(20);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"所属标签：";
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor grayColor];
    [rightSide addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(12);
        make.left.equalTo(rightSide).offset(20);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"所属楼盘：";
    label3.font = [UIFont systemFontOfSize:14];
    label3.textColor = [UIColor grayColor];
    [rightSide addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(12);
        make.left.equalTo(rightSide).offset(20);
    }];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"所含产品：";
    label4.font = [UIFont systemFontOfSize:12];
    label4.textColor = [UIColor grayColor];
    [rightSide addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(46);
        make.left.equalTo(rightSide).offset(20);
    }];
    
    [rightSide addSubview:self.personName];
    [self.personName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.personImage.mas_right).offset(20);
        make.top.equalTo(self.personImage).offset(10);
    }];
    
    [rightSide addSubview:self.productTable];
    [self.productTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label4.mas_bottom).offset(6);
        make.left.equalTo(rightSide).offset(20);
        make.right.equalTo(rightSide).offset(-10);
        make.bottom.equalTo(bottomView.mas_top);
    }];
}


#pragma mark - property

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _backBtn.backgroundColor = [UIColor whiteColor];
        _backBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 16, 4, 16);
        _backBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        _backBtn.layer.borderWidth = 1;
        _backBtn.layer.cornerRadius = 5;
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)caseImage {
    if (!_caseImage) {
        _caseImage = [[UIImageView alloc] init];
        _caseImage.backgroundColor = [UIColor whiteColor];
        [_caseImage sd_setImageWithURL:[NSURL URLWithString:self.caseEntity.imagePath]];
    }
    return _caseImage;
}

- (UIButton *)history {
    if (!_history) {
        _history = [UIButton buttonWithType:UIButtonTypeCustom];
        [_history setImage:[UIImage imageNamed:@"historyview_ico.png"] forState:UIControlStateNormal];
    }
    return _history;
}

- (UIButton *)shopping {
    if (!_shopping) {
        _shopping = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shopping setImage:[UIImage imageNamed:@"shopping_ico.png"] forState:UIControlStateNormal];
    }
    return _shopping;
}

- (UIButton *)qCode {
    if (!_qCode) {
        _qCode = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qCode setImage:[UIImage imageNamed:@"qcode_ico.png"] forState:UIControlStateNormal];
    }
    return _qCode;
}

- (UIButton *)notes {
    if (!_notes) {
        _notes = [UIButton buttonWithType:UIButtonTypeCustom];
        [_notes setImage:[UIImage imageNamed:@"history_ico.png"] forState:UIControlStateNormal];
    }
    return _notes;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.text = self.caseEntity.exhibitionName;
        _name.font = [UIFont systemFontOfSize:24];
    }
    return _name;
}

- (UIImageView *)personImage {
    if (!_personImage) {
        _personImage = [[UIImageView alloc] init];
        [_personImage sd_setImageWithURL:[NSURL URLWithString:self.caseEntity.personImagePath]];
    }
    return _personImage;
}

- (UILabel *)personName {
    if (!_personName) {
        _personName = [[UILabel alloc] init];
        _personName.text = self.caseEntity.personName;
        _personName.font = [UIFont systemFontOfSize:14];
    }
    return _personName;
}

- (UITableView *)productTable {
    if (!_productTable) {
        _productTable = [[UITableView alloc] init];
    }
    return _productTable;
}


#pragma mark - event

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
