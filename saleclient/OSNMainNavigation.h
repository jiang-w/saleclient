//
//  OSNMainNavigation.h
//  saleclient
//
//  Created by Frank on 15/12/3.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSNMainNavigation : UINavigationController

- (BOOL)isContainViewControllerForClass:(Class)contrClass;

- (void)popViewControllerForClass:(Class)contrClass;

@end
