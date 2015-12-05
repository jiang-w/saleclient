//
//  BuildingLeftSider.h
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLayoutTagView.h"

@protocol BuildingLeftSiderDelegate <NSObject>

- (void)didSelectArea:(OSNAreaEntity *)area andKeyword:(NSString *)keyword;

@end

@interface BuildingLeftSider : UIViewController <AutoLayoutTagViewDelegate>

@property(nonatomic, weak) id<BuildingLeftSiderDelegate> delegate;

@end
