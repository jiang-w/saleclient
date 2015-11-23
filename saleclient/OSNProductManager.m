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

- (void)getProductTagList {
    OSNUserInfo *userinfo = [OSNUserManager currentUser];
    OSNNetworkService *service = [OSNNetworkService sharedInstance];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [service syncPostRequest:[NSString stringWithFormat:@"%@ipadOcnProductQueryItemData", BASEURL] parameters:@{@"userLoginId":userinfo.userLoginId,@"accessToken":userinfo.accessToken} returnResponse:&response error:&error];
    if (data) {
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    }
}

@end
