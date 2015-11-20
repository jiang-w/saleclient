//
//  UserInfo.h
//  saleclient
//
//  Created by Frank on 15/11/19.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNUserInfo : NSObject

@property (nonatomic, strong) NSString *userLoginId;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *provinceId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *factoryId;
@property (nonatomic, strong) NSString *municipalId;
@property (nonatomic, strong) NSString *shopId;

@end
