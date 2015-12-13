//
//  MasterViewController.h
//  saleclient
//
//  Created by Frank on 15/11/20.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterViewController;

@protocol MasterViewControllerDelegate <NSObject>

- (void)masterViewController:(MasterViewController *)master searchWithKeyword:(NSString *)keyword;

@end

@interface MasterViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>

@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, weak) id<MasterViewControllerDelegate> delegate;

@end
