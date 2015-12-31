//
//  OSNNetworkService.h
//  saleclient
//
//  Created by Frank on 15/11/19.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNNetworkService : NSObject

/**
 *  @return 返回单例对象
 */
+ (instancetype) sharedInstance;

/**
 *  欧神诺服务请求
 *
 *  @param serviceName 服务名称
 *  @param paramters   请求参数字典
 *
 *  @return 返回请求的数据
 */
- (NSDictionary *)requestDataWithServiceName:(NSString *)serviceName andParamterDictionary:(NSDictionary *)paramters;

- (NSData *)syncPostRequest:(NSString *)urlString parameters:(NSDictionary *) parameter returnResponse:(NSHTTPURLResponse **)response error:(NSError **) error;

@end
