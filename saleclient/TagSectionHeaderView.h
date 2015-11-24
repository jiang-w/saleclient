//
//  SectionHeaderView.h
//  saleclient
//
//  Created by Frank on 15/11/24.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagSectionHeaderViewModel.h"

@class TagSectionHeaderViewDelegate;

@interface TagSectionHeaderView : UITableViewHeaderFooterView

@property(nonatomic, strong) TagSectionHeaderViewModel *viewModel;
@property(nonatomic, weak) TagSectionHeaderViewDelegate *delegate;

@end


@protocol TagSectionHeaderViewDelegate <NSObject>

- (void)openedSectionHeaderView:(TagSectionHeaderView *)view withIndex:(NSInteger)index;
- (void)closedSectionHeaderView:(TagSectionHeaderView *)view withIndex:(NSInteger)index;

@end