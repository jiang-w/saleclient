//
//  HouseTypeDetailViewController.h
//  saleclient
//
//  Created by Frank on 15/12/8.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLayoutTagView.h"

@interface HouseTypeDetailViewController : UIViewController <AutoLayoutTagViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, copy) NSString *buildingId;
@property(nonatomic, copy) NSString *modelId;

@end
