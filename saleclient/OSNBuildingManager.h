//
//  OSNBuildingManager.h
//  saleclient
//
//  Created by Frank on 15/12/5.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNBuildingManager : NSObject

- (NSArray *)getCityAreaList;

- (NSArray *)getBuildingListWithParameters:(NSDictionary *)parameters;

@end
