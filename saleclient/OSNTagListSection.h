//
//  OSNSectionHeaderView.h
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSNTagGroup.h"
#import "OSNTagPadView.h"

@class OSNTagListSection;
@protocol OSNTagListSectionDelegate <NSObject>

@required
- (void)openedSectionHeaderView:(UIView *)sender;
- (void)closedSectionHeaderView:(UIView *)sender;

@optional
- (void)sectionHeader:(OSNTagListSection *)section didSelectTag:(OSNTag *)tag;

@end

@interface OSNTagListSection : UITableViewHeaderFooterView <OSNTagPadViewDelegate>

@property(nonatomic, strong) OSNTagGroup *group;
@property(nonatomic, assign) NSUInteger selectedTagIndex;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, weak) id<OSNTagListSectionDelegate> delegate;

@end
