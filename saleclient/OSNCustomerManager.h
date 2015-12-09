//
//  OSNCustomerManager.h
//  saleclient
//
//  Created by Frank on 15/12/7.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNCustomerManager : NSObject

- (NSArray *)getCustomerList:(NSDictionary *)paramters;

- (NSString *)generateReceptionId;

- (NSString *)createCustomerWithParamters:(NSDictionary *)paramters;

- (void)updateCustomerWithParamters:(NSDictionary *)paramters;

- (NSDictionary *)getCustomerWithId:(NSString *)customerId;

- (NSString *)validateCustomerMobile:(NSString *)mobile;

- (NSString *)combineCustomerWithNewCustomerId:(NSString *)newId andExistCustomerId:(NSString *)existId;

- (void)completeCustomerReception;

+ (NSString *)currentReceptionId;

@end
