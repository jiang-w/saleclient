//
//  CustomerAddressCell.h
//  saleclient
//
//  Created by Frank on 16/1/31.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomerAddressCell;
@protocol CustomerAddressCellDelegate <NSObject>

- (void)customerAddressCell:(CustomerAddressCell *)cell willEditAddress:(OSNCustomerAddress *)address;
- (void)customerAddressCell:(CustomerAddressCell *)cell willDeleteAddress:(OSNCustomerAddress *)address;
- (void)customerAddressCell:(CustomerAddressCell *)cell willSetPreferAddress:(OSNCustomerAddress *)address;

@end

@interface CustomerAddressCell : UITableViewCell

@property (nonatomic, strong) OSNCustomerAddress *addressEntity;
@property (nonatomic, weak) id <CustomerAddressCellDelegate> delegate;

@end
