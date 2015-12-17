//
//  ProductTagCell.m
//  saleclient
//
//  Created by Frank on 15/11/30.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "ProductTagCell.h"
#import "OSNTagButton.h"

@implementation ProductTagCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _tagPadView = [[OSNTagPadView alloc] init];
        _tagPadView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        _tagPadView.lineSpace = 10;
        _tagPadView.tagSpace = 8;
        _tagPadView.maxLayoutWidth = 260;
        _tagPadView.fixTagSize =CGSizeMake(105, 30);
        
        [self.contentView addSubview:_tagPadView];
        [_tagPadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

@end
