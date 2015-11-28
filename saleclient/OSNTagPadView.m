//
//  OSNTagPadView.m
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNTagPadView.h"
#import <Masonry.h>

#define SAVE_CONTRAINT(c) [self.tagsContraints addObject:c]

@interface OSNTagPadView()

@property(nonatomic, strong) NSMutableArray *tagSubviews;
@property(nonatomic, strong) NSMutableArray *tagConstraints;

@end

@implementation OSNTagPadView

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedIndex = -1;
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    if (!self.tagSubviews.count) {
        return CGSizeZero;
    }
    
    CGFloat intrinsicWidth = 0;
    CGFloat intrinsicHeight = 0;
    
    if (self.maxLayoutWidth > 0) {
        CGFloat lineWidth = 0;
        CGFloat lineHeight = 0;
        for (OSNTagButton *btn in self.tagSubviews) {
            CGSize tagSize = [self getSizeOfTagButton:btn];
            
            if ([self isHeadTagButoon:btn]) {
                intrinsicWidth = MAX(intrinsicWidth, lineWidth);
                if (intrinsicHeight == 0) {
                    intrinsicHeight = lineHeight;
                }
                else {
                    intrinsicHeight += self.lineSpace + lineHeight;
                }
                
                lineWidth = tagSize.width;
                lineHeight = tagSize.height;
            }
            else {
                lineWidth += self.tagSpace + tagSize.width;
                lineHeight = MAX(lineHeight, tagSize.height);
            }
        }
        
        intrinsicWidth = MAX(intrinsicWidth, lineWidth);
        intrinsicWidth += self.padding.left + self.padding.right;
        
        if (intrinsicHeight == 0) {
            intrinsicHeight = lineHeight;
        }
        else {
            intrinsicHeight += self.lineSpace + lineHeight;
        }
        intrinsicHeight += self.padding.top + self.padding.bottom;
    }
    
//    NSLog(@"TagPadView ContentSize: (width: %.2f, height: %.2f)", intrinsicWidth, intrinsicHeight);
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

- (void)updateConstraints {
    if (!self.tagSubviews.count) {
        return;
    }
    
    [self removeAllConstraints];
    for (OSNTagButton *btn in self.tagSubviews) {
        [self setConstraintOfTagButton:btn];
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    self.maxLayoutWidth = self.frame.size.width;

    [super layoutSubviews];
}

#pragma mark - Property

- (NSMutableArray *)tagSubviews {
    if(!_tagSubviews) {
        _tagSubviews = [NSMutableArray array];
    }
    return _tagSubviews;
}

- (NSMutableArray *)tagsContraints
{
    if(!_tagConstraints) {
        _tagConstraints = [NSMutableArray array];
    }
    return _tagConstraints;
}

- (void)setMaxLayoutWidth:(CGFloat)maxLayoutWidth {
    if (maxLayoutWidth != _maxLayoutWidth) {
        _maxLayoutWidth = maxLayoutWidth;
        
        [self setNeedsUpdateConstraints];
    }
}

- (void)setSelectedIndex:(NSInteger)index {
    if (index >= 0 && index < self.tagSubviews.count) {
        if (_selectedIndex != -1 && _selectedIndex != index) {
            OSNTagButton *btn = self.tagSubviews[_selectedIndex];
            btn.selected = NO;
        }
        OSNTagButton *selectedBtn = self.tagSubviews[index];
        selectedBtn.selected = YES;
        _selectedIndex = index;
    }
}

#pragma mark - Public methods

- (void)addTag:(OSNTag *)tag {
    OSNTagButton *tagButton = [OSNTagButton buttonWithTag:tag];
    [tagButton addTarget:self action:@selector(tapTagHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tagButton];
    [self.tagSubviews addObject:tagButton];
    
    [self invalidateIntrinsicContentSize];
}

- (void)insertTag:(OSNTag *)tag atIndex:(NSUInteger)index {
    if (index < self.tagSubviews.count) {
        OSNTagButton *tagButton = [OSNTagButton buttonWithTag:tag];
        [tagButton addTarget:self action:@selector(tapTagHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:tagButton atIndex:index];
        [self.tagSubviews insertObject:tagButton atIndex:index];
        
        [self invalidateIntrinsicContentSize];
    }
    else {
        [self addTag:tag];
    }
}

- (void)removeTagAtIndex:(NSUInteger)index {
    if (index < self.tagSubviews.count) {
        [self.tagSubviews[index] removeFromSuperview];
        [self.tagSubviews removeObjectAtIndex:index];
        
        [self invalidateIntrinsicContentSize];
    }
}

- (void)removeAllTags {
    for (UIView *tag in self.tagSubviews) {
        [tag removeFromSuperview];
    }
    [self.tagSubviews removeAllObjects];
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Private methods

- (void)tapTagHandle:(OSNTagButton *)button {
    NSUInteger index = [self.tagSubviews indexOfObject:button];
    self.selectedIndex = index;
}

- (CGSize)getSizeOfTagButton:(OSNTagButton *)tagButton {
    if (CGSizeEqualToSize(self.fixTagSize, CGSizeZero)) {
        return tagButton.intrinsicContentSize;
    }
    else {
        return self.fixTagSize;
    }
}

- (BOOL)isHeadTagButoon:(OSNTagButton *)tagButton {
    NSUInteger index = [self.tagSubviews indexOfObject:tagButton];
    if (index == 0) {
        return YES;
    }
    
    BOOL isHead = NO;
    CGFloat xOffset = self.padding.left;
    for (int i = 0; i <= index; i++) {
        CGSize tagSize = [self getSizeOfTagButton:self.subviews[i]];
        
        if (xOffset == self.padding.left) {
            xOffset += tagSize.width;
        }
        else {
            xOffset += self.tagSpace + tagSize.width;
        }
        
        if (xOffset + self.padding.right > self.maxLayoutWidth) {
            xOffset = self.padding.left + tagSize.width;
            isHead = YES;
        }
        else {
            isHead = NO;
        }
    }
    return isHead;
}

- (void)setConstraintOfTagButton:(OSNTagButton *)tagButton {
    CGSize tagSize = [self getSizeOfTagButton:tagButton];
    NSUInteger index = [self.tagSubviews indexOfObject:tagButton];
    
    UIView *superView = self;
    CGFloat leftOffset = self.padding.left;
    CGFloat topOffset = self.padding.top;
    CGFloat tagSpace = self.tagSpace;
    CGFloat lineSpace = self.lineSpace;
    
    if (self.maxLayoutWidth > 0) {
        [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
            SAVE_CONTRAINT(make.width.mas_equalTo(tagSize.width));
            SAVE_CONTRAINT(make.height.mas_equalTo(tagSize.height));
//        SAVE_CONTRAINT(make.bottom.lessThanOrEqualTo(superView).offset(-bottomOffset));
//        SAVE_CONTRAINT(make.right.lessThanOrEqualTo(superView).offset(-rightOffset));
        }];
        
        if (index == 0) {
            // first tag
            [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
                SAVE_CONTRAINT(make.left.equalTo(superView).offset(leftOffset));
                SAVE_CONTRAINT(make.top.equalTo(superView).offset(topOffset));
            }];
        }
        else {
            OSNTagButton *prevTagBtn = self.tagSubviews[index - 1];
            if ([self isHeadTagButoon:tagButton]) {
                // new line
                [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    SAVE_CONTRAINT(make.left.equalTo(superView).offset(leftOffset));
                    SAVE_CONTRAINT(make.top.equalTo(prevTagBtn.mas_bottom).offset(lineSpace));
                }];
            }
            else {
                [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    SAVE_CONTRAINT(make.centerY.equalTo(prevTagBtn));
                    SAVE_CONTRAINT(make.left.equalTo(prevTagBtn.mas_right).offset(tagSpace));
                }];
            }
        }
    }
}

- (void)removeAllConstraints {
    for (id obj in self.tagConstraints) {
        if ([obj isKindOfClass:MASConstraint.class]) {
            [(MASConstraint *)obj uninstall];
        }
        else if([obj isKindOfClass:NSArray.class]) {
            for (MASConstraint * constraint in (NSArray *)obj) {
                [constraint uninstall];
            }
        }
        else {
            NSAssert(NO, @"Error:unknown class type: %@", obj);
        }
    }
    [self.tagConstraints removeAllObjects];
}

@end
