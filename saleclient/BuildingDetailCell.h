//
//  BuildingDetailCell.h
//  saleclient
//
//  Created by Frank on 15/12/7.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildingDetailCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) NSString *modelId;

@end
