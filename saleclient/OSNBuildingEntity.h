//
//  OSNBuildingEntity.h
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNBuildingEntity : NSObject

@property(nonatomic, copy) NSString *buildingId;
@property(nonatomic, copy) NSString *buildingName;
@property(nonatomic, copy) NSString *modelNumber;
@property(nonatomic, assign) NSInteger designCaseRealNumber;
@property(nonatomic, copy) NSString *imagePath;
@property(nonatomic, copy) NSString *openingTime;
@property(nonatomic, copy) NSString *buildingDate;
@property(nonatomic, copy) NSString *buildingArea;
@property(nonatomic, copy) NSString *constructionArea;
@property(nonatomic, copy) NSString *salesAddress;
@property(nonatomic, copy) NSString *developersName;
@property(nonatomic, copy) NSString *provinceId;
@property(nonatomic, copy) NSString *cityId;
@property(nonatomic, copy) NSString *areaId;
@property(nonatomic, copy) NSString *buildingLngLat;
@property(nonatomic, assign) float buildingLongitude;
@property(nonatomic, assign) float buildingLatitude;
@property(nonatomic, copy) NSString *lastUpdatedStamp;
@property(nonatomic, copy) NSString *cityName;
@property(nonatomic, copy) NSString *buildingPlace;

@end
