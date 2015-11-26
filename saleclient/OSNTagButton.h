//
//  OSNTagButton.h
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSNTagButton : UIButton

@property(nonatomic, strong) OSNTag *tagObject;

+ (instancetype)buttonWithTag:(OSNTag *)tag;

@end
