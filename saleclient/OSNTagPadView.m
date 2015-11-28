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

- (CGSize)intrinsicContentSize {
    if (!self.tagSubviews.count) {
        return CGSizeZero;
    }
    
    CGFloat intrinsicWidth = 0;
    CGFloat intrinsicHeight = 0;
    
    if (!self.isSingleLine && self.maxLayoutWidth > 0) {
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
    else {
        for (OSNTagButton *btn in self.tagSubviews) {
            CGSize tagSize = [self getSizeOfTagButton:btn];
            
            if (intrinsicWidth == 0) {
                intrinsicWidth = tagSize.width;
            }
            else {
                intrinsicWidth += self.tagSpace + tagSize.width;
            }
            
            intrinsicHeight = MAX(intrinsicHeight, tagSize.height);
        }
        intrinsicWidth += self.padding.left + self.padding.right;
        intrinsicHeight += self.padding.top + self.padding.bottom;
    }
    
//    NSLog(@"TagPadView ContentSize: (width: %.2f, height: %.2f)", intrinsicWidth, intrinsicHeight);
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

- (void)updateConstraints {
    if (!self.tagSubviews.count) {
        return;
    }
    
    // remove old constraints
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
    
    UIView *superView = self;
    CGFloat leftOffset = self.padding.left;
    CGFloat rightOffset = self.padding.right;
    CGFloat topPadding = self.padding.top;
    CGFloat bottomOffset = self.padding.bottom;
    CGFloat tagSpace = self.tagSpace;
    CGFloat lineSpace = self.lineSpace;
    CGFloat currentX = self.padding.left;
    
    UIView *prevTag = nil;
    if (!self.isSingleLine && self.maxLayoutWidth > 0) {
        for (UIView *tag in self.tagSubviews) {
            CGSize tagSize;
            if (CGSizeEqualToSize(self.fixTagSize, CGSizeZero)) {
                tagSize = tag.intrinsicContentSize;
            }
            else {
                tagSize = self.fixTagSize;
            }
            
            [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                SAVE_CONTRAINT(make.right.lessThanOrEqualTo(superView).offset(-rightOffset));
            }];
            
            if (prevTag) {
                currentX += self.tagSpace;
                if ([self isEnableInsertTagWithWidth:tagSize.width atCurrentLocation:currentX]) {
                    [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                        SAVE_CONTRAINT(make.left.equalTo(prevTag.mas_right).offset(tagSpace));
                        SAVE_CONTRAINT(make.centerY.equalTo(prevTag));
                    }];
                    currentX += tagSize.width;
                }
                else {
                    // new line
                    [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                        SAVE_CONTRAINT(make.top.equalTo(prevTag.mas_bottom).offset(lineSpace));
                        SAVE_CONTRAINT(make.left.equalTo(superView).offset(leftOffset));
                    }];
                    currentX = leftOffset + tagSize.width;
                }
            }
            else {
                //first one
                [tag mas_makeConstraints:^(MASConstraintMaker *make)
                 {
                     SAVE_CONTRAINT(make.top.equalTo(superView).offset(topPadding));
                     SAVE_CONTRAINT(make.left.equalTo(superView).offset(leftOffset));
                 }];
                currentX += tagSize.width;
            }
            
            [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                SAVE_CONTRAINT(make.width.mas_equalTo(tagSize.width));
                SAVE_CONTRAINT(make.height.mas_equalTo(tagSize.height));
            }];
            
            prevTag = tag;
        }
    }
    else {
        for (UIView *tag in self.tagSubviews) {
            CGSize tagSize;
            if (CGSizeEqualToSize(self.fixTagSize, CGSizeZero)) {
                tagSize = tag.intrinsicContentSize;
            }
            else {
                tagSize = self.fixTagSize;
            }
            
            if (prevTag) {
                [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                    SAVE_CONTRAINT(make.left.equalTo(prevTag.mas_right).offset(tagSpace));
                    SAVE_CONTRAINT(make.centerY.equalTo(prevTag));
                }];
            }
            else {
                //first one
                [tag mas_makeConstraints:^(MASConstraintMaker *make)
                 {
                     SAVE_CONTRAINT(make.top.equalTo(superView).offset(topPadding));
                     SAVE_CONTRAINT(make.left.equalTo(superView).offset(leftOffset));
                 }];
            }
            
            [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                SAVE_CONTRAINT(make.width.mas_equalTo(tagSize.width));
                SAVE_CONTRAINT(make.height.mas_equalTo(tagSize.height));
            }];
            
            prevTag = tag;
        }
    }
    
    [prevTag mas_makeConstraints:^(MASConstraintMaker *make) {
        SAVE_CONTRAINT(make.bottom.lessThanOrEqualTo(superView).offset(-bottomOffset));
    }];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    if (!self.isSingleLine) {
        self.maxLayoutWidth = self.frame.size.width;
    }
    
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

#pragma mark - Public methods

- (void)addTagButton:(OSNTagButton *)button {
    [button addTarget:self action:@selector(tapTagHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self.tagSubviews addObject:button];
    
    [self invalidateIntrinsicContentSize];
}

- (void)insertTagButton:(OSNTagButton *)button atIndex:(NSUInteger)index {
    if (index < self.tagSubviews.count) {
        [button addTarget:self action:@selector(tapTagHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:button atIndex:index];
        [self.tagSubviews insertObject:button atIndex:index];
        
        [self invalidateIntrinsicContentSize];
    }
    else {
        [self addTagButton:button];
    }
}

- (void)removeTagButton:(OSNTagButton *)button {
    NSUInteger index = [self.tagSubviews indexOfObject:button];
    if (NSNotFound == index) {
        return;
    }
    else {
        [self.tagSubviews[index] removeFromSuperview];
        [self.tagSubviews removeObjectAtIndex:index];
        
        [self invalidateIntrinsicContentSize];
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
    
}

- (BOOL)isEnableInsertTagWithWidth:(CGFloat)width atCurrentLocation:(CGFloat)xOffset {
    return (xOffset + width + self.padding.right <= self.maxLayoutWidth);
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
    CGFloat rightOffset = self.padding.right;
    CGFloat topOffset = self.padding.top;
    CGFloat bottomOffset = self.padding.bottom;
    CGFloat tagSpace = self.tagSpace;
    CGFloat lineSpace = self.lineSpace;
    
    [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        SAVE_CONTRAINT(make.width.mas_equalTo(tagSize.width));
        SAVE_CONTRAINT(make.height.mas_equalTo(tagSize.height));
    }];
    
    if (index == 0) {
        // first tag
        [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
            SAVE_CONTRAINT( make.left.greaterThanOrEqualTo(superView).offset(leftOffset));
            SAVE_CONTRAINT(make.top.equalTo(superView).offset(topOffset));
        }];
    }
    else {
        OSNTagButton *prevTag = self.tagSubviews[index - 1];

    }
}


@end
