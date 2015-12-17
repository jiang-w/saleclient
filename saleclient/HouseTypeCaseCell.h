//
//  HouseTypeCaseCell.h
//  saleclient
//
//  Created by Frank on 15/12/8.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseTypeCaseCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) UILabel *name;
//@property(nonatomic, strong) UIButton *favorite;
@property(nonatomic, copy) NSString *exhibitionId;

@end
