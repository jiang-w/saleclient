//
//  ProductTagSection.m
//  saleclient
//
//  Created by Frank on 15/11/30.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ProductTagSection.h"
#import <Masonry.h>

@interface ProductTagSection()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *expandButton;

@end

@implementation ProductTagSection

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-60);
        }];
        self.titleLabel.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.expandButton = [[UIButton alloc] init];
        [self.expandButton setImage:[UIImage imageNamed:@"pro_lm1.gif"] forState:UIControlStateNormal];
        [self.expandButton setImage:[UIImage imageNamed:@"pro_lm.gif"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.expandButton];
        [self.expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.width.height.mas_equalTo(40);
        }];
        self.expandButton.selected = YES;
        self.expandButton.userInteractionEnabled = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(tapSectionHeaderView:)];
        [self addGestureRecognizer:tapGesture];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)tapSectionHeaderView:sender {
    self.isOpen = !self.isOpen;
    if (self.delegate) {
        if (self.isOpen) {
            [self.delegate openedSectionHeaderView:self];
        }
        else {
            [self.delegate closedSectionHeaderView:self];
        }
    }
}


#pragma mark - property

- (BOOL)isOpen {
    return self.expandButton.selected;
}

- (void)setIsOpen:(BOOL)isOpen {
    self.expandButton.selected = isOpen;
}

- (void)setGroup:(OSNTagGroup *)group {
    _group = group;
    self.titleLabel.text = group.name;
}

#pragma mark - OSNTagPadViewDelegate

- (void)tagPadView:(OSNTagPadView *)view didSelectTag:(OSNTag *)tag andIndex:(NSUInteger)index {
    self.selectedTagIndex = index;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sectionHeader:didSelectTag:)]) {
            [self.delegate sectionHeader:self didSelectTag:self.group.list[self.selectedTagIndex]];
        }
    }
}

@end
