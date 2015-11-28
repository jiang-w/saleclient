//
//  OSNTagPadView.h
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSNTagButton.h"

@class OSNTagPadView;
@protocol OSNTagPadViewDelegate <NSObject>

- (void)tagPadView:(OSNTagPadView *)view didSelectTag:(OSNTag *)tag andIndex:(NSUInteger)index;

@end

@interface OSNTagPadView : UIView

@property(nonatomic, assign) UIEdgeInsets padding;
@property(nonatomic, assign) CGFloat lineSpace;
@property(nonatomic, assign) CGFloat tagSpace;
@property(nonatomic, assign) CGFloat maxLayoutWidth;
@property(nonatomic, assign) CGSize fixTagSize;
@property(nonatomic, assign) NSInteger selectedIndex;

@property(nonatomic, weak) id<OSNTagPadViewDelegate> delegate;

- (void)addTag:(OSNTag *)tag;

- (void)insertTag:(OSNTag *)tag atIndex:(NSUInteger)index;

- (void)removeTagAtIndex:(NSUInteger)index;

- (void)removeAllTags;

@end
