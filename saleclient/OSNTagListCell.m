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
    NSMutableArray *_tagsViewArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _tagsViewArray = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
//    NSLog(@"rect: %f, %f",rect.size.width, rect.size.height);
    
//    NSLog(@"rect: %f, %f",self.contentView.frame.size.width, self.contentView.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetTagsView {
    for (UIView *tag in _tagsViewArray) {
        [tag removeFromSuperview];
    }
    [_tagsViewArray removeAllObjects];
    
//    for (int i = 0; i < self.tags.count; i++) {
//        OSNTagItem *tag = self.tags[i];
//        UIButton *tagView = [[UIButton alloc] initWithFrame:CGRectMake(80*i, 0, 60, 30)];
//        tagView.titleLabel.text = tag.name;
//        
//        [self.contentView addSubview:tagView];
////        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.bottom.left.right.equalTo(self.contentView);
////        }];
//        [_tagsViewArray addObject:tagView];
//    }
    
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.equalTo(self.contentView);
//    }];
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    [self resetTagsView];
}

@end
