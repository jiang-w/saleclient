//
//  OSNNetworkService.m
//  saleclient
//
//  Created by Frank on 15/11/19.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNNetworkService.h"

@interface OSNNetworkService()

@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property(nonatomic, strong) Reachability *reachability;

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

- (id)init {
    self = [super init];
    if (self) {
        self.reachability = Reachability.reachabilityForInternetConnection;
        self.manager = [AFHTTPRequestOperationManager manager];
        // 设置请求格式
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 设置返回格式
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // 检测网络状态
        __weak OSNNetworkService *weakSelf = self;
        [self.manager.reachabilityManager startMonitoring];
        [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Network Status: %@", AFStringFromNetworkReachabilityStatus(status));
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    [weakSelf.manager.operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [weakSelf.manager.operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    [weakSelf.manager.operationQueue setSuspended:YES];
                    break;
                default:
                    [weakSelf.manager.operationQueue setSuspended:YES];
                    break;
            }
        }];
    }
    return self;
}

- (void)asyncPostRequest:(NSString *)urlString parameters:(NSDictionary *)parameters
                 success:(void(^)(id responseObject))success
                 failure:(void(^)(NSError *error))failure {
    // 在向服务端发送请求状态栏显示网络活动标志
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_manager POST:urlString parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               if (success) {
                   success(responseObject);
               }
               [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               if (failure) {
                   failure(error);
               }
               [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
           }];
}

- (void)asyncGetRequest:(NSString *) urlString success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    // 在向服务端发送请求状态栏显示网络活动标志
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_manager GET:urlString parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success) {
                  success(responseObject);
              }
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure) {
                  failure(error);
              }
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }];
}

- (NSData *)syncPostRequest:(NSString *)urlString parameters:(NSDictionary *) parameter returnResponse:(NSHTTPURLResponse **)response error:(NSError **) error {
    // 在向服务端发送请求状态栏显示网络活动标志
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:@"POST" URLString:urlString parameters:parameter error:error];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    return data;
}

- (NSData *)syncGetRequest:(NSString *)urlString returnResponse:(NSHTTPURLResponse **)response error:(NSError **) error {
    // 在向服务端发送请求状态栏显示网络活动标志
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableURLRequest *request = [[[AFHTTPRequestSerializer alloc] init] requestWithMethod:@"GET" URLString:urlString parameters:nil error:error];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    return data;
}

@end
