//
//  CustomerAddressCell.m
//  saleclient
//
//  Created by Frank on 16/1/31.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import "CustomerAddressCell.h"

@interface CustomerAddressCell()

@property (weak, nonatomic) IBOutlet UIButton *preferBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

@implementation CustomerAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddressEntity:(OSNCustomerAddress *)addressEntity {
    if (_addressEntity != addressEntity) {
        _addressEntity = addressEntity;
        self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ 栋/座 %@ 室"
                                  , addressEntity.provinceName, addressEntity.cityName, addressEntity.areaName,
                                  addressEntity.address, addressEntity.buildingName,
                                  [addressEntity.buildingNo isEqual:[NSNull null]] ? @"-" : addressEntity.buildingNo,
                                  [addressEntity.room isEqual:[NSNull null]] ? @"-" : addressEntity.room];
        if (self.addressEntity.state == 1) {
            self.preferBtn.hidden = YES;
        }
        else {
            self.preferBtn.hidden = NO;
        }
    }
}


#pragma mark - Event

- (IBAction)ClickPreferButton:(id)sender {
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(customerAddressCell:willSetPreferAddress:)]) {
            [self.delegate customerAddressCell:self willSetPreferAddress:self.addressEntity];
        }
    }
}

- (IBAction)ClickEditButton:(id)sender {
    if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(customerAddressCell:willEditAddress:)]) {
            [self.delegate customerAddressCell:self willEditAddress:self.addressEntity];
        }
    }
}

- (IBAction)ClickDeleteButton:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(customerAddressCell:willDeleteAddress:)]) {
            [self.delegate customerAddressCell:self willDeleteAddress:self.addressEntity];
        }
    }
}

@end
