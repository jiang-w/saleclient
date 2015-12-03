//
//  OSNProductEntity.h
//  saleclient
//
//  Created by Frank on 15/12/3.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNProductEntity : NSObject

@property(nonatomic, copy) NSString *columnId;
@property(nonatomic, copy) NSString *productId;
@property(nonatomic, copy) NSString *lastUpdatedStamp;
@property(nonatomic, copy) NSString *typeId;
@property(nonatomic, copy) NSString *ocnProductId;
@property(nonatomic, copy) NSString *ocnProductCode;
@property(nonatomic, copy) NSString *ocnProductName;
@property(nonatomic, copy) NSString *ocnClassification;
@property(nonatomic, copy) NSString *ocnClassificationName;
@property(nonatomic, copy) NSString *ocnSpecificationID;
@property(nonatomic, copy) NSString *ocnSpecificationName;
@property(nonatomic, copy) NSString *ocnGenerationId;
@property(nonatomic, copy) NSString *imagePath;
@property(nonatomic, copy) NSString *isPush;
@property(nonatomic, copy) NSString *factoryId;
@property(nonatomic, copy) NSString *municipalId;
@property(nonatomic, copy) NSString *shopId;
@property(nonatomic, copy) NSString *productTypeId;
@property(nonatomic, copy) NSString *columnType;

@end
