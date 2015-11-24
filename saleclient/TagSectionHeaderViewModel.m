//
//  TagSectionHeaderViewModel.m
//  saleclient
//
//  Created by Frank on 15/11/24.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "TagSectionHeaderViewModel.h"

@implementation TagSectionHeaderViewModel

- (instancetype)initWithGroup:(OSNTagGroup *)group andIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        self.group = group;
        self.isOpen = false;
        self.index = index;
    }
    return self;
}

@end
