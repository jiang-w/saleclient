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
 *  异步POST方式请求
 *
 *  @param urlString  url字符串
 *  @param parameters POST请求的参数
 *  @param success    请求成功后执行的代码块
 *  @param failure    请求失败执行的代码块
 */
- (void)asyncPostRequest:(NSString *)urlString parameters:(NSDictionary *)parameters
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure;

/**
 *  异步GET方式请求
 *
 *  @param urlString url字符串
 *  @param success   请求成功后执行的代码块
 *  @param failure   请求失败执行的代码块
 */
- (void)asyncGetRequest:(NSString *) urlString success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 *  同步POST方式请求
 *
 *  @param urlString url字符串
 *  @param parameter POST请求的参数
 *  @param response  请求响应
 *  @param error     错误
 *
 *  @return 返回请求的数据
 */
- (NSData *)syncPostRequest:(NSString *)urlString parameters:(NSDictionary *) parameter returnResponse:(NSHTTPURLResponse **)response error:(NSError **) error;

/**
 *  同步GET方式请求
 *
 *  @param urlString url字符串
 *  @param response  请求响应
 *  @param error     错误
 *
 *  @return 返回请求的数据
 */
- (NSData *)syncGetRequest:(NSString *)urlString returnResponse:(NSHTTPURLResponse **)response error:(NSError **) error;


/**
 *  欧神诺服务请求
 *
 *  @param serviceName 服务名称
 *  @param paramters   请求参数字典
 *
 *  @return 返回请求的数据
 */
- (NSArray *)requestDataWithServiceName:(NSString *)serviceName andParamterDictionary:(NSDictionary *)paramters;

@end
