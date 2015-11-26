//
//  OSNTagListCell.m
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNTagListCell.h"
#import "OSNTagButton.h"
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
        OSNTagButton *tagBtn = [OSNTagButton buttonWithTag:self.tags[i]];
        tagBtn.frame = CGRectMake(80 * i + 10, 0, 76, 30);
        
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
