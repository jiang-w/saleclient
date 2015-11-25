//
//  OSNTagListCell.m
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNTagListCell.h"
#import <Masonry.h>

@implementation OSNTagListCell
{
    NSMutableArray *_tagsButtonArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _tagsButtonArray = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)resetTagsView {
    for (UIView *tag in _tagsButtonArray) {
        [tag removeFromSuperview];
    }
    [_tagsButtonArray removeAllObjects];
    
    for (int i = 0; i < self.tags.count; i++) {
        OSNTagItem *tag = self.tags[i];
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        tagBtn.frame = CGRectMake(80 * i, 0, 60, 30);
        [tagBtn setTitle:tag.name forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [tagBtn addTarget:self action:@selector(tapTagButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:tagBtn];
        [_tagsButtonArray addObject:tagBtn];
    }
}

- (void)tapTagButton:(UIButton *)sender {

}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    [self resetTagsView];
}

@end
