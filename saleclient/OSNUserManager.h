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

@property(nonatomic, strong) OSNUserInfo *currentUser;

+ (instancetype) sharedInstance;

- (OSNUserInfo *)signiInWithUserName:(NSString *)userName andPassword:(NSString *)password isRemember:(BOOL)remember;

- (BOOL)checkSessionIsValid;

- (NSArray *)getFocusImageData;

- (void)signOut;

- (NSArray *)getDesignerList;

- (NSString *)changePasswordWithCurrentPassword:(NSString *)currentPassword andNewPassword:(NSString *)newPassword;

@end
