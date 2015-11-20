//
//  UserManageService.m
//  saleclient
//
//  Created by Frank on 15/11/19.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNUserManager.h"
#import "OSNNetworkService.h"

@implementation OSNUserManager

- (OSNUserInfo *)signiInWithUserName:(NSString *)userName andPassword:(NSString *)password isRemember:(BOOL)remember {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [service syncPostRequest:[NSString stringWithFormat:@"%@/ipadUserLogin", BASEURL] parameters:@{@"userLoginId":userName,@"password":password} returnResponse:&response error:&error];
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if ([@"10004" isEqual: dic[@"returnValue"][@"status"]]) {
            NSDictionary *usrDic = [dic[@"returnValue"][@"data"] firstObject];
            OSNUserInfo *info = [[OSNUserInfo alloc] init];
            info.userLoginId = usrDic[@"userLoginId"];
            info.personName = usrDic[@"personName"];
            info.provinceId = usrDic[@"provinceId"];
            info.cityId = usrDic[@"cityId"];
            info.areaId = usrDic[@"areaId"];
            info.provinceName = usrDic[@"provinceName"];
            info.cityName = usrDic[@"cityName"];
            info.areaName = usrDic[@"areaName"];
            info.factoryId = usrDic[@"factoryId"];
            info.municipalId = usrDic[@"municipalId"];
            info.shopId = usrDic[@"shopId"];
            if (remember) {
                
            }
            return info;
        }
    }
    return nil;
}

- (OSNUserInfo *)currentUser {
    return nil;
}

@end
