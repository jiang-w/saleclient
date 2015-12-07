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
    NSArray *dataArr = [dataDic[@"data"] firstObject][@"customerList"];
    NSMutableArray *customerList = [NSMutableArray array];
    if (dataArr && dataArr.count > 0) {
        for (NSDictionary *dic in dataArr) {
            OSNCustomerListItem *item = [[OSNCustomerListItem alloc] init];
            item.customerId = dic[@"customerId"];
            item.customerName = dic[@"customerName"];
            item.mobile = dic[@"mobile"];
            item.createdStamp = dic[@"createdStamp"];
            item.guiderName = dic[@"guiderName"];
            item.statusName = dic[@"statusName"];
            item.genderName = dic[@"genderName"];
            item.typeName = dic[@"typeName"] ?: @"";
            
            [customerList addObject:item];
        }
    }
    return customerList;
}

@end
