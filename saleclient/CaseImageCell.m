//
//  CaseImageCell.m
//  saleclient
//
//  Created by Frank on 15/11/29.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CaseImageCell.h"
#import "CaseDetailViewController.h"
#import "OSNCustomerManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CaseImageCell()

@property(nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UIButton *favorite;
@property(nonatomic, strong) UIButton *u3dBtn;

@end

@implementation CaseImageCell

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
        make.left.lessThanOrEqualTo(bgView).offset(20);
    }];
    
    [bgView addSubview:self.u3dBtn];
    [self.u3dBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView).offset(-6);
    }];
    
    [bgView addSubview:self.favorite];
    [self.favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(self.u3dBtn.mas_left).offset(-18);
        make.width.height.mas_offset(18);
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
        [_favorite addTarget:self action:@selector(didSelectFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favorite;
}

- (UIButton *)u3dBtn {
    if (!_u3dBtn) {
        _u3dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_u3dBtn setImage:[UIImage imageNamed:@"diy_wait.png"] forState:UIControlStateNormal];
        [_u3dBtn addTarget:self action:@selector(u3dButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _u3dBtn;
}

- (void)setEntity:(OSNCaseEntity *)entity {
    _entity = entity;
    if (entity) {
        self.name.text = entity.exhibitionName;
//        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:entity.imagePath]]];
//        [self.image setImage:img];
        [self.image sd_setImageWithURL:[NSURL URLWithString:entity.imagePath]];
        
        if (!IS_EMPTY_STRING(entity.ipadU3DPath)) {
            [self.u3dBtn setImage:[UIImage imageNamed:@"diy.png"] forState:UIControlStateNormal];
        }
        else {
            [_u3dBtn setImage:[UIImage imageNamed:@"diy_wait.png"] forState:UIControlStateNormal];
        }
    }
}


#pragma mark - event

- (void)didSelectFavoriteButton:(UIButton *)button {
    NSString *receptionId = [OSNCustomerManager currentReceptionId];
    if (!IS_EMPTY_STRING(receptionId)) {
        NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
        paramters[@"customerId"] = receptionId;
        paramters[@"collectType"] = @"Exhibition";
        paramters[@"goodsId"] = self.entity.exhibitionId;
        OSNCustomerManager *manager = [[OSNCustomerManager alloc] init];
        NSString *result = [manager customerCollectGoodsWithParameters:paramters];
        if ([result isEqualToString:@"alreadyCollect"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已添加此收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        if ([result isEqualToString:@"success"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"案例收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前还未接待客户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)u3dButtonClick:(id)sender {
    
}

- (void)didTapCaseImage {
    CaseDetailViewController *detail = [[CaseDetailViewController alloc] initWithNibName:@"CaseDetailViewController" bundle:nil];
    detail.exhibitionId = self.entity.exhibitionId;
    UINavigationController *mainNav = (UINavigationController *)[OSNMainDelegate window].rootViewController;
    [mainNav pushViewController:detail animated:YES];
}

@end
