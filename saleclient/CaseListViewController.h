//
//  CaseListViewController.h
//  saleclient
//
//  Created by Frank on 15/11/22.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTagTable.h"

@interface CaseListViewController : UIViewController <CaseTagTableDelegate>

- (instancetype)initWithFrame:(CGRect)frame;

@end
