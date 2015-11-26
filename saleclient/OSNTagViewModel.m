//
//  OSNTagVIewModel.m
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNTagViewModel.h"

@implementation OSNTagViewModel

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        _text = text;
        _fontSize = 15;
        _textColor = [UIColor blackColor];
        _backgroundColor = [UIColor whiteColor];
        _enable = YES;
    }
    return self;
}

@end
