//
//  QNLoggerConfiguration.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/16.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNAppContext.h"
#import "QNNetworkingConfiguration.h"

@interface QNLoggerConfiguration : NSObject

/** 渠道ID */
@property (nonatomic, strong) NSString *channelID;

/** app标志 */
@property (nonatomic, strong) NSString *appKey;

/** app名字 */
@property (nonatomic, strong) NSString *logAppName;

/** 服务名 */
@property (nonatomic, assign) NSString *serviceType;

/** 记录log用到的webapi方法名 */
@property (nonatomic, strong) NSString *sendLogMethod;

/** 记录action用到的webapi方法名 */
@property (nonatomic, strong) NSString *sendActionMethod;

/** 发送log时使用的key */
@property (nonatomic, strong) NSString *sendLogKey;

/** 发送Action记录时使用的key */
@property (nonatomic, strong) NSString *sendActionKey;

- (void)configWithAppType:(QNAppType)appType;

@end
