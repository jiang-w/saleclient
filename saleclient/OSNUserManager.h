//
//  UserManageService.h
//  saleclient
//
//  Created by Frank on 15/11/19.
//  Copyright © 2015年 oceano. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSNUserInfo;

@interface OSNUserManager : NSObject

- (OSNUserInfo *)signiInWithUserName:(NSString *)userName andPassword:(NSString *)password isRemember:(BOOL)remember;

+ (OSNUserInfo *)currentUser;

@end
