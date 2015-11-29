//
//  OSNCaseTagListVC.h
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTagSection.h"

@protocol CaseTagTableDelegate <NSObject>

- (void)didChangeSelectedTags;

@end

@interface CaseTagTable : UITableViewController <CaseTagSectionDelegate>

@property(nonatomic, weak) id<CaseTagTableDelegate> delegate;

- (NSDictionary *)getAllSelectedTagResult;

@end
