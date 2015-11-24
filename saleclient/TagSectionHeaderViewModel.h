//
//  TagSectionHeaderViewModel.h
//  saleclient
//
//  Created by Frank on 15/11/24.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagSectionHeaderViewModel : NSObject

@property(nonatomic, strong) OSNTagGroup *group;
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, assign) NSInteger index;

- (instancetype)initWithGroup:(OSNTagGroup *)group andIndex:(NSInteger)index;

@end
