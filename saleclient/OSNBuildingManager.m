//
//  OSNBuildingManager.m
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNBuildingManager.h"
#import "OSNNetworkService.h"
#import "OSNUserManager.h"

@implementation OSNBuildingManager

- (NSArray *)getCityAreaList {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    OSNUserInfo *user = [OSNUserManager sharedInstance].currentUser;
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    paramters[@"provinceId"] = user.provinceId;
    paramters[@"cityId"] = user.cityId;
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadUserCityAreaData" andParamterDictionary:paramters];
    NSArray *dataArr = dataDic[@"data"];
    
    NSMutableArray *cityAreas = [NSMutableArray array];
    if (dataArr && dataArr.count > 0) {
        NSArray *arr = [dataArr firstObject][@"areaList"];
        [arr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
            OSNAreaEntity *area = [[OSNAreaEntity alloc] init];
            area.provinceId = dic[@"provinceId"];
            area.cityId = dic[@"cityId"];
            area.areaId = dic[@"areaId"];
            area.provinceName = dic[@"provinceName"];
            area.cityName = dic[@"cityName"];
            area.areaName = dic[@"areaName"];
            
            [cityAreas addObject:area];
        }];
        
        OSNAreaEntity *allArea = [[OSNAreaEntity alloc] init];
        allArea.provinceId = user.provinceId;
        allArea.cityId = user.cityId;
        allArea.areaId = @"";
        allArea.provinceName = user.provinceName;
        allArea.cityName = user.cityName;
        allArea.areaName = @"全部区域";
        [cityAreas insertObject:allArea atIndex:0];
    }
    return cityAreas;
}

- (NSArray *)getBuildingListWithParameters:(NSDictionary *)parameters {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadBuildingListData" andParamterDictionary:parameters];
    NSArray *dataArr = [dataDic[@"data"] firstObject][@"list"];
    NSMutableArray *list = [NSMutableArray array];
    
    if (dataArr && dataArr.count > 0) {
        for (NSDictionary *item in dataArr) {
            OSNBuildingEntity *entity = [[OSNBuildingEntity alloc] init];
            entity.buildingId = item[@"buildingId"];
            entity.buildingName = item[@"buildingName"];
            entity.modelNumber = item[@"modelNumber"];
            entity.designCaseRealNumber = [item[@"designCaseRealNumber"] integerValue];
            entity.imagePath = item[@"imagePath"];
            entity.openingTime = item[@"openingTime"];
            entity.buildingDate = item[@"buildingDate"];
            entity.buildingArea = item[@"buildingArea"];
            entity.constructionArea = item[@"constructionArea"];
            entity.salesAddress = item[@"salesAddress"];
            entity.developersName = item[@"developersName"];
            entity.provinceId = item[@"provinceId"];
            entity.cityId = item[@"cityId"];
            entity.areaId = item[@"areaId"];
            entity.buildingLngLat = item[@"buildingLngLat"];
            entity.buildingLongitude = [item[@"buildingLongitude"] floatValue];
            entity.buildingLatitude = [item[@"buildingLatitude"] floatValue];
            entity.lastUpdatedStamp = item[@"lastUpdatedStamp"];
            entity.cityName = item[@"cityName"];
            
            [list addObject:entity];
        }
    }
    
    return list;
}

@end
