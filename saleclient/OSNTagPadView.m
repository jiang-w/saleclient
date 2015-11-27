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

@property(nonatomic, strong) NSMutableArray *tags;
@property(nonatomic, strong) NSMutableArray *tagsConstraints;

@end

@implementation OSNTagPadView

- (CGSize)intrinsicContentSize {
    if (!self.tags.count) {
        return CGSizeZero;
    }
    
    CGFloat intrinsicWidth = 0;
    CGFloat intrinsicHeight = 0;
    CGFloat currentX = self.padding.left;
    UIView *prevTag = nil;
    
    if (!self.isSingleLine && self.maxLayoutWidth > 0) {
        NSInteger lineCount = 0;
        for (UIView *tag in self.tags) {
            CGSize tagSize;
            if (CGSizeEqualToSize(self.fixTagSize, CGSizeZero)) {
                tagSize = tag.intrinsicContentSize;
            }
            else {
                tagSize = self.fixTagSize;
            }
            
            if (prevTag) {
                currentX += self.tagSpace;
                if ([self isEnableInsertTagWithWidth:tagSize.width atCurrentLocation:currentX]) {
                    currentX += tagSize.width;
                }
                else {
                    // new line
                    lineCount++;
                    currentX = self.padding.left + tagSize.width;
                    intrinsicHeight += tagSize.height + self.lineSpace;
                }
            }
            else {
                // first tag
                lineCount++;
                intrinsicHeight += tagSize.height;
                currentX += tagSize.width;
            }
            prevTag = tag;
            intrinsicWidth = MAX(currentX + self.padding.right, intrinsicWidth);
        }
        intrinsicHeight += self.padding.top + self.padding.bottom;
    }
    else {
        for (UIView *tag in self.tags) {
            CGSize tagSize;
            if (CGSizeEqualToSize(self.fixTagSize, CGSizeZero)) {
                tagSize = tag.intrinsicContentSize;
            }
            else {
                tagSize = self.fixTagSize;
            }

            if (prevTag) {
                currentX += self.tagSpace + tagSize.width;
            }
            else {
                currentX += tagSize.width;
                intrinsicHeight = self.padding.top + tagSize.height + self.padding.bottom;
            }
        }
        intrinsicWidth += currentX + self.padding.right;
    }
    
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

- (void)updateConstraints {
    if (!self.tags.count) {
        return;
    }
    
    // remove old constraints
    for (id obj in self.tagsConstraints) {
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
    [self.tagsConstraints removeAllObjects];
    
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
        for (UIView *tag in self.tags) {
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
        for (UIView *tag in self.tags) {
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
            
            prevTag = tag;
        }
    }
    
    [prevTag mas_makeConstraints:^(MASConstraintMaker *make) {
        SAVE_CONTRAINT(make.bottom.equalTo(superView).offset(-bottomOffset));
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

- (NSMutableArray *)tags {
    if(!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (NSMutableArray *)tagsContraints
{
    if(!_tagsConstraints) {
        _tagsConstraints = [NSMutableArray array];
    }
    return _tagsConstraints;
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
    [self.tags addObject:button];
    
    [self invalidateIntrinsicContentSize];
}

- (void)insertTagButton:(OSNTagButton *)button atIndex:(NSUInteger)index {
    if (index < self.tags.count) {
        [button addTarget:self action:@selector(tapTagHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:button atIndex:index];
        [self.tags insertObject:button atIndex:index];
        
        [self invalidateIntrinsicContentSize];
    }
    else {
        [self addTagButton:button];
    }
}

- (void)removeTagButton:(OSNTagButton *)button {
    NSUInteger index = [self.tags indexOfObject:button];
    if (NSNotFound == index) {
        return;
    }
    else {
        [self.tags[index] removeFromSuperview];
        [self.tags removeObjectAtIndex:index];
        
        [self invalidateIntrinsicContentSize];
    }
}

- (void)removeTagAtIndex:(NSUInteger)index {
    if (index < self.tags.count) {
        [self.tags[index] removeFromSuperview];
        [self.tags removeObjectAtIndex:index];
        
        [self invalidateIntrinsicContentSize];
    }
}

- (void)removeAllTags {
    for (UIView *tag in self.tags) {
        [tag removeFromSuperview];
    }
    [self.tags removeAllObjects];
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Private methods

- (void)tapTagHandle:(OSNTagButton *)button {
    
}

- (BOOL)isEnableInsertTagWithWidth:(CGFloat)width atCurrentLocation:(CGFloat)xOffset {
    return (xOffset + width + self.padding.right <= self.maxLayoutWidth);
}

@end
