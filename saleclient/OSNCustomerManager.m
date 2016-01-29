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

+ (NSString *)currentReceptionId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"receptionId"];
}

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

- (NSString *)generateReceptionId {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmGenerateCustomerId" andParamterDictionary:nil];
    NSArray *dataArr = dataDic[@"data"];
    if (dataArr && dataArr.count > 0) {
        NSString *receptionId = [dataArr firstObject][@"customerId"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:receptionId forKey:@"receptionId"];
        NSLog(@"new reception：%@", receptionId);
        return receptionId;
    }
    else {
        return nil;
    }
}

- (NSString *)createCustomerWithParamters:(NSDictionary *)paramters {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmCreateCustomer" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    if (dataArr && dataArr.count > 0) {
        NSString *customerId = [dataArr firstObject][@"customerId"];
        NSLog(@"create customer：%@", customerId);
        return customerId;
    }
    else {
        return nil;
    }
}

- (void)updateCustomerWithParamters:(NSDictionary *)paramters {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmUpdateCustomer" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    if (dataArr && dataArr.count > 0) {
        NSString *customerId = [dataDic[@"data"] firstObject][@"customerId"];
        NSLog(@"update customer: %@", customerId);
    }
}

- (NSDictionary *)getCustomerWithId:(NSString *)customerId {
    NSDictionary *paramters = @{@"customerId": customerId};
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmGetCustomer" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    if (dataArr && dataArr.count > 0) {
        return [dataArr firstObject][@"customer"];
    }
    else {
        return nil;
    }
}

- (NSString *)validateCustomerMobile:(NSString *)mobile {
    NSDictionary *paramters = @{@"mobile": mobile};
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmValidateCustomerMobile" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    if (dataArr && dataArr.count > 0) {
        NSString *customerId = [dataArr firstObject][@"customerId"];
        NSLog(@"mobile number exist：%@", customerId);
        return customerId;
    }
    else {
        return nil;
    }
}

- (NSString *)combineCustomerWithNewCustomerId:(NSString *)newId andExistCustomerId:(NSString *)existId {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"newCustomerId"] = newId;
    paramters[@"existCustomerId"] = existId;
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmCombineCustomer" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    if (dataArr && dataArr.count > 0) {
        NSString *customerId = [dataArr firstObject][@"existCustomerId"];
        if (customerId) {
            NSLog(@"combine customer newId: %@ existId: %@ return: %@", newId, existId, customerId);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:customerId forKey:@"receptionId"];
            return customerId;
        }
    }
    return nil;
}

- (void)completeCustomerReception {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *receptionId = [defaults objectForKey:@"receptionId"];
    NSDictionary *paramters = @{@"receptionId": receptionId};
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmCompleteReception" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    [defaults setObject:@"" forKey:@"receptionId"];
}

- (NSString *)customerCollectGoodsWithParameters:(NSDictionary *)paramters {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCustomerCollectGoods" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    NSString *result = [dataArr firstObject][@"returnResult"];
    return result;
}

- (void)updateCustomerReceptionRecordWithParamters:(NSDictionary *)paramters {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    [service requestDataWithServiceName:@"ipadUpdateCustomerReceptionRecord" andParamterDictionary:paramters];
}

- (NSArray *)getCustomerReceptionRecordListWithParamters:(NSDictionary *)paramters {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadViewCustomerReceptionRecord" andParamterDictionary:paramters];
    NSArray *dataArr = [dataDic[@"data"] firstObject][@"list"];
    return dataArr;
}

- (void)CreateCustomerAddress:(OSNCustomerAddress *)address {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"customerId"] = address.customerId;
    paramters[@"name"] = address.name;
    paramters[@"contactPhone"] = address.contactPhone;
    paramters[@"provinceId"] = address.provinceId;
    paramters[@"provinceName"] = address.provinceName;
    paramters[@"cityId"] = address.cityId;
    paramters[@"cityName"] = address.cityName;
    paramters[@"areaId"] = address.areaId;
    paramters[@"areaName"] = address.areaName;
    paramters[@"state"] = [NSString stringWithFormat:@"%d", (int)address.state];
    paramters[@"buildingId"] = address.buildingId;
    paramters[@"buildingName"] = address.buildingName;
    paramters[@"address"] = address.address;
    paramters[@"buildingNo"] = address.buildingNo;
    paramters[@"room"] = address.room;
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmCreateCustomerAddress" andParamterDictionary:paramters];
    address.addressId = dataDic[@"data"][@"addressId"];
}

- (void)UpdateCustomerAddress:(OSNCustomerAddress *)address {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"customerId"] = address.customerId;
    paramters[@"name"] = address.name;
    paramters[@"contactPhone"] = address.contactPhone;
    paramters[@"provinceId"] = address.provinceId;
    paramters[@"provinceName"] = address.provinceName;
    paramters[@"cityId"] = address.cityId;
    paramters[@"cityName"] = address.cityName;
    paramters[@"areaId"] = address.areaId;
    paramters[@"areaName"] = address.areaName;
    paramters[@"state"] = [NSString stringWithFormat:@"%ld", (long)address.state];
    paramters[@"buildingId"] = address.buildingId;
    paramters[@"buildingName"] = address.buildingName;
    paramters[@"address"] = address.address;
    paramters[@"buildingNo"] = address.buildingNo;
    paramters[@"room"] = address.room;
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmUpdateCustomerAddress" andParamterDictionary:paramters];
}

- (OSNCustomerAddress *)GetCustomerAddressWithId:(NSString *)addressId {
    NSDictionary *paramters = @{@"addressId": addressId};
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmGetCustomerAddress" andParamterDictionary:paramters];
    OSNCustomerAddress *address = nil;
    return address;
}

- (NSArray *)getAddressListWithCustomerId:(NSString *)customerId {
    NSMutableArray *addressArray = [NSMutableArray array];
    NSDictionary *paramters = @{@"customerId": customerId};
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmListCustomerAddress" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    for (NSDictionary *item in dataArr) {
        OSNCustomerAddress *address = [[OSNCustomerAddress alloc] init];
        address.customerId = item[@"addressArray"];
        address.name = item[@"name"];
        address.contactPhone = item[@"contactPhone"];
        address.provinceId = item[@"provinceId"];
        address.provinceName = item[@"provinceName"];
        address.cityId = item[@"cityId"];
        address.cityName = item[@"cityName"];
        address.areaId = item[@"areaId"];
        address.areaName = item[@"areaName"];
        address.state = [item[@"state"] integerValue];
        address.buildingId = item[@"buildingId"];
        address.buildingName = item[@"buildingName"];
        address.address = item[@"address"];
        address.buildingNo = item[@"buildingNo"];
        address.room = item[@"room"];
        [addressArray addObject:address];
    }
    return addressArray;
}

@end
