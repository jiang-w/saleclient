//
//  OSNCustomerInfo.h
//  saleclient
//
//  Created by Frank on 16/2/1.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNCustomerInfo : NSObject

@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *genderId;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *customerAge;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *recommendCustomerId;
@property (nonatomic, copy) NSString *recommendName;
@property (nonatomic, copy) NSString *recommendMobile;
@property (nonatomic, copy) NSString *receptionShopName;
@property (nonatomic, copy) NSString *receptionTime;
@property (nonatomic, copy) NSString *receptionGuideName;
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *designerId;
@property (nonatomic, strong) OSNCustomerAddress *defaultAddress;

@end
