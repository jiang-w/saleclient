//
//  OSNAreaModel.h
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNAreaEntity : NSObject

@property(nonatomic, copy) NSString *provinceId;
@property(nonatomic, copy) NSString *cityId;
@property(nonatomic, copy) NSString *areaId;
@property(nonatomic, copy) NSString *provinceName;
@property(nonatomic, copy) NSString *cityName;
@property(nonatomic, copy) NSString *areaName;

@end
