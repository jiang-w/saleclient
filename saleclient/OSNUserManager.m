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
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadUserLogin" andParamterDictionary:@{@"userLoginId":userName,@"password":password}];
    NSMutableDictionary *usrDic = [NSMutableDictionary dictionaryWithDictionary:[dataDic[@"data"] firstObject]];
    if (dataDic && usrDic) {
        OSNUserInfo *info = [[OSNUserInfo alloc] init];
        info.userLoginId = usrDic[@"userLoginId"];
        info.personName = usrDic[@"personName"];
        info.provinceId = usrDic[@"provinceId"];
        info.cityId = usrDic[@"cityId"];
        if (usrDic[@"areaId"] == [NSNull null]) {
            usrDic[@"areaId"] = nil;
        }
        info.areaId = usrDic[@"areaId"];
        info.provinceName = usrDic[@"provinceName"];
        info.cityName = usrDic[@"cityName"];
        if (usrDic[@"areaName"] == [NSNull null]) {
            usrDic[@"areaName"] = nil;
        }
        info.areaName = usrDic[@"areaName"];
        info.factoryId = usrDic[@"factoryId"];
        info.municipalId = usrDic[@"municipalId"];
        info.shopId = usrDic[@"shopId"];
        
        _currentUser = info;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:usrDic forKey:@"userinfo"];
        
        return info;
    }
    return nil;
}

- (OSNUserInfo *)currentUser {
    if (!_currentUser) {
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
            _currentUser = info;
        }
    }
    return _currentUser;
}

- (BOOL)checkSessionIsValid {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadUserSessionJudge" andParamterDictionary:nil];
    NSString *status = dataDic[@"status"];
    if ([status isEqualToString:@"10007"]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray *)getFocusImageData {
    OSNUserInfo *usr = [self currentUser];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"factoryId"] = usr.factoryId;
    paramters[@"municipalId"] = usr.municipalId;
    paramters[@"shopId"] = usr.shopId;
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadFocusImageData" andParamterDictionary:paramters];
    NSArray *dataArr = [dataDic[@"data"] firstObject][@"focusImageList"];
    return dataArr;
}

- (void)signOut {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userinfo"];
    _currentUser = nil;
}

- (NSArray *)getDesignerList {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadCrmLookUpDesignerList" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    return dataArr;
}

- (NSString *)changePasswordWithCurrentPassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword {
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"currentPassword"] = currentPassword;
    paramters[@"newPassword"] = newPassword;
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadEditPassword" andParamterDictionary:paramters];
    NSString *status = dataDic[@"status"];
    return status;
}

@end
