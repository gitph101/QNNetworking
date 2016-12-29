//
//  QNAppContext.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/15.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNAppContext.h"
#import <AFNetworking/AFNetworking.h>
#import "QNNetworkingConfiguration.h"
#import "CTLocationManager.h"

@interface QNAppContext ()

// 用户的token管理
@property (nonatomic, copy, readwrite) NSString *accessToken;
@property (nonatomic, copy, readwrite) NSString *refreshToken;
@property (nonatomic, assign, readwrite) NSTimeInterval lastRefreshTime;

@property (nonatomic, copy, readwrite) NSString *sessionId; // 每次启动App时都会新生成,用于日志标记

@end


@implementation QNAppContext

@synthesize userInfo = _userInfo;
@synthesize userID = _userID;

+ (instancetype)sharedInstance
{
    static QNAppContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QNAppContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}


#pragma mark - public methods
- (void)updateAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken
{
    self.accessToken = accessToken;
    self.refreshToken = refreshToken;
    self.lastRefreshTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refreshToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)appStarted
{
    self.sessionId = [[NSUUID UUID].UUIDString copy];
    [[CTLocationManager sharedInstance] startLocation];
}

- (void)appEnded
{
    [[CTLocationManager sharedInstance] stopLocation];
}

- (void)cleanUserInfo
{
    self.accessToken = nil;
    self.refreshToken = nil;

    self.userInfo = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refreshToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

//保留方法 不知道什么用
- (BOOL)isOnline
{
    BOOL isOnline = NO;
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"CTNetworkingConfiguration" ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:filepath];
        isOnline = [settings[@"isOnline"] boolValue];
    } else {
        isOnline = kQNServiceIsOnline;
    }
    return isOnline;
}


#pragma mark - getters and setters
- (void)setUserID:(NSString *)userID
{
    _userID = [userID copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userID forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userID
{
    if (_userID == nil) {
        _userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    }
    return _userID;
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    _userInfo = [userInfo copy];
    [[NSUserDefaults standardUserDefaults] setObject:_userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)userInfo
{
    if (_userInfo == nil) {
        _userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    }
    return _userInfo;
}

- (BOOL)isLoggedIn
{
    BOOL result = (self.userID.length != 0);
    return result;
}

- (NSString *)appVersion
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

- (NSString *)type
{
    return @"ios";
}

- (NSString *)model
{
    return [[UIDevice currentDevice] name];
}

- (NSString *)os
{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)rom
{
    return [[UIDevice currentDevice] model];
}

- (NSString *)imei
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}
- (CGSize)resolution
{
    CGSize resolution = CGSizeZero;
    if ([self.deviceName isEqualToString:@"iPod1,1"] ||
        [self.deviceName isEqualToString:@"iPod2,1"] ||
        [self.deviceName isEqualToString:@"iPod3,1"] ||
        [self.deviceName isEqualToString:@"iPhone1,1"] ||
        [self.deviceName isEqualToString:@"iPhone1,2"] ||
        [self.deviceName isEqualToString:@"iPhone2,1"]) {
        
        resolution = CGSizeMake(320, 480);
    }
    else if ([self.deviceName isEqualToString:@"iPod4,1"] ||
             [self.deviceName isEqualToString:@"iPhone3,1"] ||
             [self.deviceName isEqualToString:@"iPhone3,3"] ||
             [self.deviceName isEqualToString:@"iPhone4,1"]) {
        
        resolution = CGSizeMake(640, 960);
    }
    else if ([self.deviceName isEqualToString:@"iPhone5,1"] ||
             [self.deviceName isEqualToString:@"iPhone5,2"] ||
             [self.deviceName isEqualToString:@"iPhone5,3"] ||
             [self.deviceName isEqualToString:@"iPhone5,4"] ||
             [self.deviceName isEqualToString:@"iPhone6,1"] ||
             [self.deviceName isEqualToString:@"iPhone6,2"]) {
        
        resolution = CGSizeMake(640, 1136);
    }
    else if ([self.deviceName isEqualToString:@"iPhone7,1"]) {
        resolution = CGSizeMake(1080, 1920);
    }
    else if ([self.deviceName isEqualToString:@"iPhone7,2"]) {
        resolution = CGSizeMake(750, 1334);
    }
    else if ([self.deviceName isEqualToString:@"iPad1,1"] ||
             [self.deviceName isEqualToString:@"iPad2,1"]) {
        resolution = CGSizeMake(768, 1024);
    }
    else if ([self.deviceName isEqualToString:@"iPad3,1"] ||
             [self.deviceName isEqualToString:@"iPad3,4"] ||
             [self.deviceName isEqualToString:@"iPad4,1"] ||
             [self.deviceName isEqualToString:@"iPad4,2"]) {
        resolution = CGSizeMake(1536, 2048);
    }
    else if ([self.deviceName isEqualToString:@"iPad2,5"]) {
        resolution = CGSizeMake(768, 1024);
    }
    else if ([self.deviceName isEqualToString:@"iPad4,4"] ||
             [self.deviceName isEqualToString:@"iPad4,5"]) {
        resolution = CGSizeMake(1536, 2048);
    }
    else {
        resolution = CGSizeMake(640, 960);
    }
    return resolution;
}


- (NSString *)deviceToken
{
    if (_deviceToken == nil) {
        _deviceToken = @"";
    }
    return _deviceToken;
}

- (NSData *)deviceTokenData
{
    if (_deviceTokenData == nil) {
        _deviceTokenData = [NSData data];
    }
    return _deviceTokenData;
}

- (CGFloat)latitude
{
    return [CTLocationManager sharedInstance].currentLocation.coordinate.latitude;
}

- (CGFloat)longitude
{
    return [CTLocationManager sharedInstance].currentLocation.coordinate.longitude;
}

- (NSString *)accessToken
{
    if (_accessToken == nil) {
        _accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
    }
    return _accessToken;
}

- (NSString *)refreshToken
{
    if (_refreshToken == nil) {
        _refreshToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"refreshToken"];
    }
    return _refreshToken;
}

@end
