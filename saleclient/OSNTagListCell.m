//
//  OSNTagListCell.m
//  saleclient
//
//  Created by Frank on 15/11/25.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNTagListCell.h"
#import "OSNTagViewModel.h"
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
        OSNTagItem *tag = self.tags[i];
//        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        tagBtn.frame = CGRectMake(80 * i, 0, 60, 30);
//        [tagBtn setTitle:tag.name forState:UIControlStateNormal];
//        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        tagBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [tagBtn addTarget:self action:@selector(tapTagButton:) forControlEvents:UIControlEventTouchUpInside];
        
        OSNTagViewModel *tagVM = [[OSNTagViewModel alloc] initWithText:tag.name];
        tagVM.fontSize = 14;
        tagVM.borderColor = [UIColor blackColor];
        tagVM.borderWidth = 1;
        tagVM.cornerRadius = 5;
        OSNTagButton *tagBtn = [OSNTagButton buttonWithTagViewModel:tagVM];
        tagBtn.frame = CGRectMake(80 * i, 0, 60, 30);
        
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
