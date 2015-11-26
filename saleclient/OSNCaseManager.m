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
    OSNUserInfo *userinfo = [OSNUserManager currentUser];
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [service syncPostRequest:[NSString stringWithFormat:@"%@ipadDcCaseTagSelectData", BASEURL] parameters:@{@"userLoginId":userinfo.userLoginId,@"accessToken":userinfo.accessToken} returnResponse:&response error:&error];
    if (data) {
//        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSArray *dataArr = dic[@"returnValue"][@"data"];
        if (dataArr) {
            NSMutableArray *groups = [NSMutableArray array];
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
                allTag.enumId = @"all";
                allTag.sequenceId = @"0";
                allTag.name = @"全部";
                [list insertObject:allTag atIndex:0];
                group.list = list;
                
                [groups addObject:group];
            }
            return groups;
        }
    }
    return nil;
}

@end
