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

+ (instancetype) sharedInstance {
    static dispatch_once_t  onceToken;
    static OSNUserManager *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OSNUserManager alloc] init];
    });
    return sharedInstance;
}

- (OSNUserInfo *)signiInWithUserName:(NSString *)userName andPassword:(NSString *)password isRemember:(BOOL)remember {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSArray *dataArray = [service requestDataWithServiceName:@"ipadUserLogin" andParamterDictionary:@{@"userLoginId":userName,@"password":password}];
    NSDictionary *usrDic = [dataArray firstObject];
    if (usrDic) {
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
        return info;
    }
    return nil;
}

- (OSNUserInfo *)currentUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *usrDic = [defaults objectForKey:@"userinfo"];
    if (usrDic) {
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
        return info;
    }
    return nil;
}

- (BOOL)checkSessionIsValid {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userLoginId = [[defaults objectForKey:@"userinfo"] objectForKey:@"userLoginId"];
    NSString *accessToken = [defaults objectForKey:@"accessToken"];
    
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSArray *dataArray = [service requestDataWithServiceName:@"ipadUserSessionJudge" andParamterDictionary:@{@"userLoginId": userLoginId, @"accessToken": accessToken}];
    return NO;
}

@end
