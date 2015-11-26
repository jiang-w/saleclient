//
//  OSNTagPadView.m
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNTagPadView.h"

@interface OSNTagPadView()

@property(nonatomic, strong) NSMutableArray *tags;

@end

@implementation OSNTagPadView


#pragma mark - Property

- (NSMutableArray *)tags {
    if(!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

#pragma mark - Public methods

- (void)addTagButton:(OSNTagButton *)button {
    [button addTarget:self action:@selector(tapTagHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self.tags addObject:button];
}

#pragma mark - Private methods

- (void)tapTagHandle:(OSNTagButton *)button {
    
}

@end
