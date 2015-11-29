//
//  OSNProductManager.m
//  saleclient
//
//  Created by Frank on 15/11/23.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import "OSNProductManager.h"
#import "OSNNetworkService.h"
#import "OSNUserManager.h"

@implementation OSNProductManager

- (NSArray *)getProductTagList {
    OSNUserInfo *userinfo = [OSNUserManager currentUser];
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [service syncPostRequest:[NSString stringWithFormat:@"%@ipadOcnProductQueryItemData", BASEURL] parameters:@{@"userLoginId":userinfo.userLoginId,@"accessToken":userinfo.accessToken} returnResponse:&response error:&error];
    if (data) {
//        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSArray *dataArr = dic[@"returnValue"][@"data"];
        if (dataArr) {
            NSDictionary *groupDic = [dataArr firstObject];
            NSMutableArray *groups = [NSMutableArray array];
            
            OSNTagGroup *group = [[OSNTagGroup alloc] init];
            group.name = @"精品推荐";
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *itemDic in groupDic[@"productColumnList"]) {
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
            group.list = list;
            [groups addObject:group];
            
            group = [[OSNTagGroup alloc] init];
            group.name = @"产品分类";
            list = [NSMutableArray array];
            for (NSDictionary *itemDic in groupDic[@"productClassifyList"]) {
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
            group.list = list;
            [groups addObject:group];
            
            group = [[OSNTagGroup alloc] init];
            group.name = @"空间分类";
            list = [NSMutableArray array];
            for (NSDictionary *itemDic in groupDic[@"roomList"]) {
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
            group.list = list;
            [groups addObject:group];
            
            group = [[OSNTagGroup alloc] init];
            group.name = @"风格分类";
            list = [NSMutableArray array];
            for (NSDictionary *itemDic in groupDic[@"styleList"]) {
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
            group.list = list;
            [groups addObject:group];
            
            group = [[OSNTagGroup alloc] init];
            group.name = @"产品规格";
            list = [NSMutableArray array];
            for (NSDictionary *itemDic in groupDic[@"standardList"]) {
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
            group.list = list;
            [groups addObject:group];
            
            return groups;
        }
    }
    return nil;
}

@end
