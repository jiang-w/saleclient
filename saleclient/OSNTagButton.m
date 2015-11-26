//
//  OSNTagButton.m
//  saleclient
//
//  Created by Frank on 15/11/26.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNTagButton.h"

@implementation OSNTagButton

+ (instancetype)buttonWithTagViewModel:(OSNTagViewModel *)viewModel {
    OSNTagButton *tagBtn = [super buttonWithType:UIButtonTypeCustom];
    if (viewModel.attributedText) {
        [tagBtn setAttributedTitle:viewModel.attributedText forState:UIControlStateNormal];
    }
    else {
        [tagBtn setTitle:viewModel.text forState:UIControlStateNormal];
        [tagBtn setTitleColor:viewModel.textColor forState:UIControlStateNormal];
        tagBtn.titleLabel.font = viewModel.font ?: [UIFont systemFontOfSize:viewModel.fontSize];
    }
    tagBtn.backgroundColor = viewModel.backgroundColor;
    tagBtn.contentEdgeInsets = viewModel.padding;
    tagBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if (viewModel.backgroundImage) {
        [tagBtn setBackgroundImage:viewModel.backgroundImage forState:UIControlStateNormal];
    }
    if (viewModel.borderColor) {
        tagBtn.layer.borderColor = viewModel.borderColor.CGColor;
    }
    if (viewModel.borderWidth) {
        tagBtn.layer.borderWidth = viewModel.borderWidth;
    }
    tagBtn.layer.cornerRadius = viewModel.cornerRadius;
    tagBtn.layer.masksToBounds = YES;
    tagBtn.userInteractionEnabled = viewModel.enable;
    return tagBtn;
}

@end
