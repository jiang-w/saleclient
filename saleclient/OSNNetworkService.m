//
//  OSNNetworkService.m
//  saleclient
//
//  Created by Frank on 15/11/19.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNNetworkService.h"

@interface OSNNetworkService()

@end

@implementation OSNNetworkService

+ (instancetype) sharedInstance {
    static dispatch_once_t  onceToken;
    static OSNNetworkService *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OSNNetworkService alloc] init];
    });
    return sharedInstance;
}

- (NSData *)syncPostRequest:(NSString *)urlString parameters:(NSDictionary *) parameter returnResponse:(NSHTTPURLResponse **)response error:(NSError **) error {
    // 在向服务端发送请求状态栏显示网络活动标志
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:@"POST" URLString:urlString parameters:parameter error:error];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    return data;
}

// 欧神诺服务请求
- (NSDictionary *)requestDataWithServiceName:(NSString *)serviceName andParamterDictionary:(NSDictionary *)paramters {
    NSDictionary *dataDic = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userLoginId = [[defaults objectForKey:@"userinfo"] objectForKey:@"userLoginId"];
    NSString *accessToken = [defaults objectForKey:@"accessToken"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:paramters];
    if (userLoginId && accessToken) {
        paramDic[@"userLoginId"] = userLoginId;
        paramDic[@"accessToken"] = accessToken;
//        NSLog(@"accessToken: %@", accessToken);
    }
    
    NSData *data = [self syncPostRequest:[BASEURL stringByAppendingString:serviceName] parameters:paramDic returnResponse:&response error:&error];
    if (data) {
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSString *status = jsonDic[@"returnValue"][@"status"];
        switch ([status integerValue]) {
            case 10004:// 用户登录成功
                dataDic = jsonDic[@"returnValue"];
                [defaults setObject:jsonDic[@"returnValue"][@"accessToken"] forKey:@"accessToken"];
                break;
            case 10002:// 用户密码错误
                break;
            case 10003:// 用户没有权限
            case 10008:
            case 10009:// 令牌失效
                [[NSNotificationCenter defaultCenter] postNotificationName:RESPONSE_STATUS_NOTIFICATION object:nil userInfo:@{@"status": status}];
                break;
            default:
                dataDic = jsonDic[@"returnValue"];
                break;
        }
    }
    
    return dataDic;
}

@end
