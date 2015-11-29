//
//  CaseTagTable.h
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTagSection.h"

@class CaseTagTable;
@protocol CaseTagTableDelegate <NSObject>

- (void)caseTagTable:(CaseTagTable *)table didChangeSelectedTags:(NSDictionary *)rusult;

@end

@interface CaseTagTable : UITableViewController <CaseTagSectionDelegate>

@property(nonatomic, weak) id<CaseTagTableDelegate> delegate;

@end
