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

@class CaseTagSection;
@protocol CaseTagSectionDelegate <NSObject>

@required
- (void)openedSectionHeaderView:(UIView *)sender;
- (void)closedSectionHeaderView:(UIView *)sender;

@optional
- (void)sectionHeader:(CaseTagSection *)section didSelectTag:(OSNTag *)tag;

@end

@interface CaseTagSection : UITableViewHeaderFooterView <OSNTagPadViewDelegate>

@property(nonatomic, strong) OSNTagGroup *group;
@property(nonatomic, assign) NSUInteger selectedTagIndex;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, weak) id<CaseTagSectionDelegate> delegate;

@end
