//
//  QNNetworkingConfiguration.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/15.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#ifndef QNNetworkingConfiguration_h
#define QNNetworkingConfiguration_h

typedef NS_ENUM(NSInteger, QNAppType) {
    QNAppTypexxx
};

typedef NS_ENUM(NSUInteger, QNURLResponseStatus)
{
    QNURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的QNAPIBaseManager来决定。
    QNURLResponseStatusErrorTimeout,
    QNURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSString *QNKeychainServiceName = @"xxxxx";
static NSString *QNUDIDName = @"xxxx";
static NSString *QNPasteboardType = @"xxxx";

static BOOL kQNShouldUrlCache = NO;
static BOOL kQNShouldCache = NO;
static BOOL kQNServiceIsOnline = NO;
static NSTimeInterval kQNNetworkingTimeoutSeconds = 20.0f;
static NSTimeInterval kQNCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间
static NSUInteger kQNCacheCountLimit = 1000; // 最多1000条cache

// services
extern NSString * const kQNServiceDemo;
extern NSString * const kQNServiceMethUrl;


#endif /* QNNetworkingConfiguration_h */
