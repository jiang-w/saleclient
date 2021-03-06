//
//  OSNProductManager.h
//  saleclient
//
//  Created by Frank on 15/11/23.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNProductManager : NSObject

- (NSArray *)getProductTagList;

- (NSArray *)getProductListWithParameters:(NSDictionary *)parameters;

- (NSDictionary *)getProductDetailWithId:(NSString *)productId;

- (NSString *)getProductDetailWithQRCodeUrl:(NSString *)url;

@end
