//
//  OSNCustomerManager.m
//  saleclient
//
//  Created by Frank on 15/12/7.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNCustomerManager.h"
#import "OSNNetworkService.h"

@implementation OSNCustomerManager

- (NSArray *)getCustomerList:(NSDictionary *)paramters {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmGetCustomerList" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    NSMutableArray *customerList = [NSMutableArray array];
    return customerList;
}

@end
