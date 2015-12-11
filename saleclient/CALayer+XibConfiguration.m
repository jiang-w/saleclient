//
//  CALayer+XibConfiguration.m
//  saleclient
//
//  Created by Frank on 15/12/12.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
