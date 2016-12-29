//
//  QNDemoService.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/16.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNDemoService.h"
#import "QNAppContext.h"

@implementation QNDemoService

- (BOOL)isOnline
{
    return [QNAppContext sharedInstance].isOnline;
}

- (NSString *)offlineApiBaseUrl
{
    return @"https://www.baidu.com";
}

- (NSString *)onlineApiBaseUrl
{
    return @"https://www.baidu.com";
}

- (NSString *)offlineApiVersion
{
    return @"";
}

- (NSString *)onlineApiVersion
{
    return @"";
}

- (NSString *)onlinePublicKey
{
    return @"";
}

- (NSString *)offlinePublicKey
{
    return @"";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}


@end
