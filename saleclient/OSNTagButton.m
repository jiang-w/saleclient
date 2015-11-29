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
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = [UIColor whiteColor];
    self.contentEdgeInsets = UIEdgeInsetsMake(6, 4, 6, 4);
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    else {
        self.layer.borderColor = [UIColor blackColor].CGColor;
    }
    super.selected = selected;
}

@end
