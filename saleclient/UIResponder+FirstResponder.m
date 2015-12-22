//
//  UIResponder+FirstResponder.m
//  saleclient
//
//  Created by Frank on 15/12/22.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

@implementation UIResponder (FirstResponder)

static __weak id currentFirstResponder;

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
