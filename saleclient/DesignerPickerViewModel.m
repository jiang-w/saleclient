//
//  DesignerPickerViewModel.m
//  saleclient
//
//  Created by Frank on 16/2/1.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "DesignerPickerViewModel.h"
#import "OSNUserManager.h"

@implementation DesignerPickerViewModel

- (instancetype)init {
    if (self = [super init]) {
        _designers = [[OSNUserManager sharedInstance] getDesignerList];
    }
    return self;
}

@end
