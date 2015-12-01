//
//  OSNCaseManager.m
//  saleclient
//
//  Created by Frank on 15/11/24.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNCaseManager.h"
#import "OSNNetworkService.h"
#import "OSNUserManager.h"

@implementation OSNCaseManager

- (NSArray *)getCaseTagList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *json = [defaults objectForKey:@"caseTagJson"];
    NSError *error;
    if (!json) {
        OSNUserInfo *userinfo = [OSNUserManager currentUser];
        OSNNetworkService *service = [OSNNetworkService sharedInstance];
        NSHTTPURLResponse *response;
        NSData *data = [service syncPostRequest:[NSString stringWithFormat:@"%@ipadDcCaseTagSelectData", BASEURL] parameters:@{@"userLoginId":userinfo.userLoginId,@"accessToken":userinfo.accessToken} returnResponse:&response error:&error];
        if (data) {
            json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [defaults setObject:json forKey:@"caseTagJson"];
        }
    }
    
    NSMutableArray *groups = [NSMutableArray array];
    if (json) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        NSArray *dataArr = dic[@"returnValue"][@"data"];
        if (dataArr) {
            for (NSDictionary *groupDic in dataArr) {
                OSNTagGroup *group = [[OSNTagGroup alloc] init];
                group.type = groupDic[@"type"];
                group.name = groupDic[@"name"];
                NSMutableArray *list = [NSMutableArray array];
                for (NSDictionary *itemDic in groupDic[[NSString stringWithFormat:@"%@List", group.type]]) {
                    OSNTag *item = [[OSNTag alloc] init];
                    item.enumId = itemDic[@"enumId"];
                    item.enumTypeId = itemDic[@"enumTypeId"];
                    if (itemDic[@"enumCode"] != [NSNull null]) {
                        item.enumCode = itemDic[@"enumCode"];
                    }
                    item.sequenceId = itemDic[@"sequenceId"];
                    item.name = itemDic[@"description"];
                    [list addObject:item];
                }
                OSNTag *allTag = [[OSNTag alloc] init];
                allTag.enumId = @"";
                allTag.sequenceId = @"0";
                allTag.name = @"全部";
                [list insertObject:allTag atIndex:0];
                group.list = list;
                
                [groups addObject:group];
            }
        }
    }
    
    return groups;
}

- (NSArray *)getCaseListWithParameters:(NSDictionary *)parameters {
    OSNUserInfo *userinfo = [OSNUserManager currentUser];
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSHTTPURLResponse *response;
    NSError *error;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    paramDic[@"userLoginId"] = userinfo.userLoginId;
    paramDic[@"accessToken"] = userinfo.accessToken;
    
    NSData *data = [service syncPostRequest:[NSString stringWithFormat:@"%@ipadDcCaseListData", BASEURL] parameters:paramDic returnResponse:&response error:&error];
    if (data) {
//        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSArray *dataArr = dic[@"returnValue"][@"data"];
        if (dataArr && dataArr.count > 0) {
            NSMutableArray *list = [NSMutableArray array];
            NSDictionary *dataDic = [dataArr firstObject];
            NSUInteger listCount = [dataDic[@"listSize"] integerValue];
            for (NSDictionary *item in dataDic[@"list"]) {
                OSNCaseEntity *entity = [[OSNCaseEntity alloc] init];
                entity.exhibitionId = item[@"exhibitionId"];
                entity.exhibitionTypeId = item[@"exhibitionTypeId"];
                entity.exhibitionName = item[@"exhibitionName"];
                entity.displayedId = item[@"displayedId"];
                entity.createDate = item[@"createDate"];
                entity.styleId = item[@"styleId"];
                entity.roomId = item[@"roomId"];
                entity.houseTypeId = item[@"houseTypeId"];
                entity.crowdId = item[@"crowdId"];
                entity.exhibitionPrice = item[@"exhibitionPrice"];
                entity.designerId = item[@"designerId"];
                entity.collectCount = item[@"collectCount"];
                entity.praiseCount = item[@"praiseCount"];
                entity.isPush = item[@"isPush"];
                entity.buildingId = item[@"buildingId"];
                entity.modelId = item[@"modelId"];
                entity.twoDMaxPath = item[@"twoDMaxPath"];
                entity.factoryId = item[@"factoryId"];
                entity.municipalId = item[@"municipalId"];
                entity.shopId = item[@"shopId"];
                entity.descriptionInof = item[@"description"];
                entity.unityThreeDPath = item[@"unityThreeDPath"];
                entity.personId = item[@"personId"];
                entity.personName = item[@"personName"];
                entity.personImagePath = item[@"personImagePath"];
                entity.defaultImage = item[@"defaultImage"];
                entity.exhibitionImageTypeId = item[@"exhibitionImageTypeId"];
                entity.imagePath = item[@"imagePath"];
                
                [list addObject:entity];
            }
            return list;
        }
    }
    return nil;
}

- (NSDictionary *)getCaseDetailWithExhibitionId:(NSString *)exhibitionId {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSArray *dataArray = [service requestDataWithServiceName:@"ipadDcCaseDetailData" andParamterDictionary:@{@"exhibitionId": exhibitionId}];
    if (dataArray && dataArray.count > 0) {
        return [dataArray firstObject];
    }
    else {
        return nil;
    }
}

@end
