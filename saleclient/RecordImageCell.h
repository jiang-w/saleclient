//
//  RecordImageCell.h
//  saleclient
//
//  Created by Frank on 15/12/11.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordImageCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) NSString *recordId;

@end
