//
//  OSNCustomerAddress.h
//  saleclient
//
//  Created by Frank on 16/1/29.
//  Copyright © 2016年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNCustomerAddress : NSObject

@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *buildingId;
@property (nonatomic, copy) NSString *buildingName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *buildingNo;
@property (nonatomic, copy) NSString *room;

@end
