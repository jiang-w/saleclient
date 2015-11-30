//
//  ProductTagSection.h
//  saleclient
//
//  Created by Frank on 15/11/30.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSNTagGroup.h"
#import "OSNTagPadView.h"

@class ProductTagSection;
@protocol ProductTagSectionDelegate <NSObject>

@required
- (void)openedSectionHeaderView:(UIView *)sender;
- (void)closedSectionHeaderView:(UIView *)sender;

@optional
- (void)sectionHeader:(ProductTagSection *)section didSelectTag:(OSNTag *)tag;

@end

@interface ProductTagSection : UITableViewHeaderFooterView <OSNTagPadViewDelegate>

@property(nonatomic, strong) OSNTagGroup *group;
@property(nonatomic, assign) NSInteger selectedTagIndex;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, weak) id<ProductTagSectionDelegate> delegate;

@end
