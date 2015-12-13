//
//  CaseImageList.h
//  saleclient
//
//  Created by Frank on 15/11/29.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTagTable.h"

@interface CaseImageList : UICollectionViewController <CaseTagTableDelegate>

- (void)searchWithKeyword:(NSString *)keyword;

@end
