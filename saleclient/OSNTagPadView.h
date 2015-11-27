//
//  OSNTagPadView.h
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSNTagButton.h"

@interface OSNTagPadView : UIView

@property(nonatomic, assign) UIEdgeInsets padding;
@property(nonatomic, assign) CGFloat lineSpace;
@property(nonatomic, assign) CGFloat tagSpace;
@property(nonatomic, assign) CGFloat maxLayoutWidth;
@property(nonatomic, assign) BOOL isSingleLine;
@property(nonatomic, assign) CGSize fixTagSize;

- (void)addTagButton:(OSNTagButton *)button;

- (void)insertTagButton:(OSNTagButton *)button atIndex:(NSUInteger)index;

- (void)removeTagButton:(OSNTagButton *)button;

- (void)removeTagAtIndex:(NSUInteger)index;

- (void)removeAllTags;

@end
