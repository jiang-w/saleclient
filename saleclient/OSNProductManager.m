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
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSArray *dataArr = [service requestDataWithServiceName:@"ipadOcnProductQueryItemData" andParamterDictionary:nil];
    NSMutableArray *groups = [NSMutableArray array];
    
    if (dataArr) {
        NSDictionary *groupDic = [dataArr firstObject];
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
            NSArray *subTags = itemDic[@"subClassify"];
            if (subTags && subTags.count > 0) {
                NSMutableArray *subArr = [NSMutableArray array];
                for (NSDictionary *sub in subTags) {
                    OSNTag *subTag = [[OSNTag alloc] init];
                    subTag.enumId = itemDic[@"enumId"];
                    subTag.enumTypeId = itemDic[@"enumTypeId"];
                    if (sub[@"enumCode"] != [NSNull null]) {
                        subTag.enumCode = itemDic[@"enumCode"];
                    }
                    subTag.sequenceId = itemDic[@"sequenceId"];
                    subTag.name = itemDic[@"description"];
                    [subArr addObject:subTag];
                }
                item.subTags = subArr;
            }
            
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
    }
    return groups;
}

@end
