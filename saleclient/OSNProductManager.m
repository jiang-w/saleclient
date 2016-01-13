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
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadOcnProductQueryItemData" andParamterDictionary:nil];
    NSArray *dataArr = dataDic[@"data"];
    NSMutableArray *groups = [NSMutableArray array];
    
    if (dataArr) {
        NSDictionary *groupDic = [dataArr firstObject];
        OSNTagGroup *group = [[OSNTagGroup alloc] init];
        group.name = @"精品推荐";
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *itemDic in groupDic[@"productColumnList"]) {
            OSNTag *item = [[OSNTag alloc] init];
            item.enumId = itemDic[@"columnId"];
            item.enumTypeId = itemDic[@"columnType"];
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
                    subTag.enumId = sub[@"enumItemId"];
                    subTag.enumTypeId = sub[@"enumId"];
                    if (sub[@"enumItemCode"] != [NSNull null]) {
                        subTag.enumCode = sub[@"enumItemCode"];
                    }
                    subTag.sequenceId = sub[@"sequenceId"];
                    subTag.name = sub[@"description"];
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

- (NSArray *)getProductListWithParameters:(NSDictionary *)parameters {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadOcnProductListData" andParamterDictionary:parameters];
    NSArray *dataArr = [dataDic[@"data"] firstObject][@"list"];
    NSMutableArray *list = [NSMutableArray array];
    
    if (dataArr && dataArr.count > 0) {
        for (NSDictionary *item in dataArr) {
            OSNProductEntity *entity = [[OSNProductEntity alloc] init];
            entity.columnId = item[@"columnId"];
            entity.productId = item[@"ocnProductId"];
            entity.lastUpdatedStamp = item[@"lastUpdatedStamp"];
            entity.typeId = item[@"typeId"];
            entity.ocnProductId = item[@"ocnProductId"];
            entity.ocnProductCode = item[@"ocnProductCode"];
            entity.ocnProductName = item[@"ocnProductName"];
            entity.ocnClassification = item[@"ocnClassification"];
            entity.ocnClassificationName = item[@"ocnClassificationName"];
            entity.ocnGenerationId = item[@"ocnGenerationId"];
            entity.imagePath = item[@"imagePath"];
            entity.isPush = item[@"isPush"];
            entity.factoryId = item[@"factoryId"];
            entity.municipalId = item[@"municipalId"]; 
            entity.shopId = item[@"shopId"];
            entity.productTypeId = item[@"productTypeId"];
            entity.columnType = item[@"columnType"];
            
            [list addObject:entity];
        }
    }
    
    return list;
}

- (NSDictionary *)getProductDetailWithId:(NSString *)productId {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadOcnProductDetailData" andParamterDictionary:@{@"ocnProductId": productId}];
    NSArray *dataArr = dataDic[@"data"];
    
    if (dataArr && dataArr.count > 0) {
        return [dataArr firstObject];
    }
    else {
        return nil;
    }
}

- (NSString *)getProductDetailWithQRCodeUrl:(NSString *)url {
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSDictionary *dataDic = [service requestDataWithServiceName:@"ipadFindOcnProductIdByQrcodeUrl" andParamterDictionary:@{@"qrcodeUrl": url}];
    NSString *productId = dataDic[@"ocnProductId"];
    return productId;
}

@end
