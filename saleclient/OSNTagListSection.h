//
//  OSNSectionHeaderView.h
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSNTagGroup.h"

@protocol OSNTagListSectionDelegate <NSObject>

@required
- (void)openedSectionHeaderView:(UIView *)sender;
- (void)closedSectionHeaderView:(UIView *)sender;

@end

@interface OSNTagListSection : UITableViewHeaderFooterView

@property(nonatomic, strong) OSNTagGroup *group;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, weak) id<OSNTagListSectionDelegate> delegate;

@end
