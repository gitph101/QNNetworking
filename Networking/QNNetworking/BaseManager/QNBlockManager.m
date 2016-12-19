//
//  QNBlockManager.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/19.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNBlockManager.h"

extern NSString * const kQNServiceMethUrl;

@interface QNBlockManager ()<QNManagerValidator,QNManagerParamSource, QNManagerCallBackDelegate>

@property(nonatomic,strong,readwrite)NSString *methodName;
@property(nonatomic,strong,readwrite)NSString *serviceType;
@property(nonatomic)QNManagerRequestType requestType;
@property(nonatomic,strong,readwrite)NSDictionary *params;
@property(nonatomic)BOOL shouldCache;

@property(nonatomic,strong,readwrite)QNCallback success;
@property(nonatomic,strong,readwrite)QNCallback fail;

@property(nonatomic,weak,readwrite)id<QNManagerParamSource> paramSourceDelegate;
@property(nonatomic,weak,readwrite)id<QNManagerParamSource> callBackDelegate;

@end


@implementation QNBlockManager

#pragma mark - public
-(void)GETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail
{
    self.methodName = methodName;
    self.serviceType = servieIdentifier;
    self.params = params;
    self.requestType = QNManagerRequestTypeGet;
}
-(void)POSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail
{
    self.methodName = methodName;
    self.serviceType = servieIdentifier;
    self.params = params;
    self.requestType = QNManagerRequestTypePost;
}

-(void)GETWithParams:(NSDictionary *)params urlString:(NSString *)urlString success:(QNCallback)success fail:(QNCallback)fail
{
    [self GETWithParams:params serviceIdentifier:kQNServiceMethUrl methodName:urlString success:success fail:fail];
}

-(void)POSTWithParams:(NSDictionary *)params urlString:(NSString *)urlString success:(QNCallback)success fail:(QNCallback)fail
{
    [self POSTWithParams:params serviceIdentifier:kQNServiceMethUrl methodName:urlString success:success fail:fail];
}
-(NSInteger)loadData
{
  return [self loadData];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
        self.paramSourceDelegate = self;
        self.callBackDelegate = self;
        self.shouldCache = YES;

    }
    return self;
}

- (NSDictionary *)reformParams:(NSDictionary *)apiparams
{
    return apiparams;
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
#pragma mark - QNManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(QNBaseManager *)manager
{
    return self.params;
}
#pragma mark - QNManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(QNBaseManager *)manager
{
    if (self.success) {
        self.success(manager.response);
    }
}
- (void)managerCallAPIDidFailed:(QNBaseManager *)manager
{
    if (self.fail) {
        self.fail(manager.response);
    }
}

#pragma mark - get and set
- (NSString *)methodName
{
    return _methodName;
}

- (NSString *)serviceType
{
    return _serviceType;
}
- (QNManagerRequestType)requestType
{
    return _requestType;
}

- (BOOL)shouldCache
{
    return _shouldCache;
}

@end
