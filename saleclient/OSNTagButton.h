//
//  OSNTagButton.h
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSNTagViewModel.h"

@interface OSNTagButton : UIButton

+ (instancetype)buttonWithTagViewModel:(OSNTagViewModel *)viewModel;

@end
