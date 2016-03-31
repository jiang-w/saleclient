//
//  OSNMacro.h
//  saleclient
//
//  Created by Frank on 15/11/19.
//  Copyright © 2015年 oceano. All rights reserved.
//

/* 基础服务地址 */
#define BASEURL @"http://crm.litijia.com/rpcmanager/control/"
/* CRM */
#define CRMURL @"http://crm.litijia.com/workplace/control/"

/* 通知 */
#define RESPONSE_STATUS_NOTIFICATION @"ResponseStatusNotification"

// 定义颜色
#define RGB(R,G,B)  [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
#define RGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]
#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 判断字符串是否为空
#define IS_EMPTY_STRING(str) (str == nil || str.length == 0)

// 获取当前系统的版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define OSNMainDelegate [UIApplication sharedApplication].delegate