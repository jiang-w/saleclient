//
//  CustomerListItem.h
//  saleclient
//
//  Created by Frank on 15/12/7.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNCustomerListItem : NSObject

@property(nonatomic, copy) NSString *customerId;
@property(nonatomic, copy) NSString *customerName;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *createdStamp;
@property(nonatomic, copy) NSString *guiderName;
@property(nonatomic, copy) NSString *statusName;
@property(nonatomic, copy) NSString *genderName;
@property(nonatomic, copy) NSString *typeName;

@end
