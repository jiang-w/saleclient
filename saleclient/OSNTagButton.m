//
//  OSNTagButton.m
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNTagButton.h"

@implementation OSNTagButton

+ (instancetype)buttonWithTag:(OSNTag *)tag {
    OSNTagButton *tagBtn = [super buttonWithType:UIButtonTypeCustom];
    tagBtn.tagObject = tag;
    [tagBtn setDefaultStyle];
    return tagBtn;
}

- (void)setDefaultStyle {
    [self setTitle:self.tagObject.name forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = [UIColor whiteColor];
    self.contentEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
}

@end