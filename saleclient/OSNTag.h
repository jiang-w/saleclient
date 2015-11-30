//
//  OSNTagItem.h
//  saleclient
//
//  Created by Frank on 15/11/24.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSNTag : NSObject

@property (nonatomic, strong) NSString *enumId;
@property (nonatomic, strong) NSString *enumTypeId;
@property (nonatomic, strong) NSString *enumCode;
@property (nonatomic, strong) NSString *sequenceId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *subTags;

@end
