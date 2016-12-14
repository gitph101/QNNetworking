//
//  QNBaseManager.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/14.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNBaseManager.h"

NSString * const kBSUserTokenInvalidNotification = @"kBSUserTokenInvalidNotification";
NSString * const kBSUserTokenIllegalNotification = @"kBSUserTokenIllegalNotification";

NSString * const kBSUserTokenNotificationUserInfoKeyRequestToContinue = @"kBSUserTokenNotificationUserInfoKeyRequestToContinue";
NSString * const kBSUserTokenNotificationUserInfoKeyManagerToContinue = @"kBSUserTokenNotificationUserInfoKeyManagerToContinue";

@interface QNBaseManager ()


@end

@implementation QNBaseManager

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}


#pragma mark - calling api
-(NSInteger)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}
-(void)loadDataWithParams:(NSDictionary *)params
{

}

@end
