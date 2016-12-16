//
//  QNAppContext.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/15.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface QNAppContext : NSObject

// 设备信息
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *model;
@property (nonatomic, copy, readonly) NSString *os;
@property (nonatomic, copy, readonly) NSString *rom;
@property (nonatomic, copy, readonly) NSString *imei;
@property (nonatomic, copy, readonly) NSString *deviceName;
@property (nonatomic, assign, readonly) CGSize resolution;


// 运行环境相关
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isOnline;

// 用户信息
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, readonly) BOOL isLoggedIn;

// app信息
@property (nonatomic, copy, readonly) NSString *sessionId; // 每次启动App时都会新生成
@property (nonatomic, readonly) NSString *appVersion;

// 推送相关
@property (nonatomic, copy) NSData *deviceTokenData;
@property (nonatomic, copy) NSString *deviceToken;

// 地理位置
@property (nonatomic, assign, readonly) CGFloat latitude;
@property (nonatomic, assign, readonly) CGFloat longitude;

//保留信息 但是不知道什么用
// 用户token相关
@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *refreshToken;
@property (nonatomic, assign, readonly) NSTimeInterval lastRefreshTime;

+ (instancetype)sharedInstance;
- (void)cleanUserInfo;
- (void)appStarted;
- (void)appEnded;
- (void)updateAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken;


- (BOOL)isOnline;

@end
