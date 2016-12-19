//
//  TestBaseManager.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/16.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "TestBaseManager.h"
#import "QNNetworkingConfiguration.h"

@interface TestBaseManager ()<QNManagerValidator>

@end


@implementation TestBaseManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

- (NSString *)methodName
{
    return @"";
}

- (NSString *)serviceType
{
    return kQNServiceDemo;
}
- (QNManagerRequestType)requestType
{
    return QNManagerRequestTypeGet;
}

- (BOOL)shouldCache
{
    return YES;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{
    return params;
}


#pragma mark - CTAPIManagerValidator
- (BOOL)manager:(QNBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

- (BOOL)manager:(QNBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}


@end
