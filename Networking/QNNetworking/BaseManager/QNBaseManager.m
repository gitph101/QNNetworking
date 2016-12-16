//
//  QNBaseManager.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/14.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNBaseManager.h"
#import "QNAppContext.h"
#import "QNApiTool.h"
#import "QNURLResponse.h"
#define AXCallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
__weak typeof(self) weakSelf = self;                                                        \
REQUEST_ID = [[QNApiTool shareInstance] call##REQUEST_METHOD##WithParams:params serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(QNURLResponse *response) { \
__strong typeof(weakSelf) strongSelf = weakSelf;                                        \
[strongSelf successedOnCallingAPI:response];                                            \
} fail:^(QNURLResponse *response) {                                                        \
__strong typeof(weakSelf) strongSelf = weakSelf;                                        \
[strongSelf failedOnCallingAPI:response withErrorType:QNManagerErrorTypeDefault];    \
}];                                                                                         \
[self.requestIdList addObject:@(REQUEST_ID)];                                               \
}



NSString * const kBSUserTokenInvalidNotification = @"kBSUserTokenInvalidNotification";
NSString * const kBSUserTokenIllegalNotification = @"kBSUserTokenIllegalNotification";

NSString * const kBSUserTokenNotificationUserInfoKeyRequestToContinue = @"kBSUserTokenNotificationUserInfoKeyRequestToContinue";
NSString * const kBSUserTokenNotificationUserInfoKeyManagerToContinue = @"kBSUserTokenNotificationUserInfoKeyManagerToContinue";

@interface QNBaseManager ()

@property (nonatomic, readwrite) QNManagerErrorType errorType;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong, readwrite) id fetchedRawData;

@end

@implementation QNBaseManager

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;        
        _fetchedRawData = nil;
        _errorMessage = nil;
        _errorType = QNManagerErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(QNManager)]) {
            self.child = (id <QNManager>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
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
-(NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    if ([self.validator manager:self isCorrectWithParamsData:params]) { //检查器 验证器验证参数是否正确
        if ([self shouldCallAPIWithParams:params]) {   //1.拦截器
            
            if ([self.child shouldLoadFromNative]) { //本地请求,比喻加载本地图片之类的
                [self loadDataFromNative];
            }
            
            if ([self isReachable]) {
                self.isLoading = YES;
                switch (self.child.requestType)
                {
                    case QNManagerRequestTypeGet:
                        AXCallAPI(GET, requestId);
                        break;
                    case QNManagerRequestTypePost:
                        AXCallAPI(POST, requestId);
                        break;
                    case QNManagerRequestTypePut:
                        AXCallAPI(PUT, requestId);
                        break;
                    case QNManagerRequestTypeDelete:
                        AXCallAPI(DELETE, requestId);
                        break;
                    default:
                        break;
                }
                NSMutableDictionary *paramsCopy = [params mutableCopy];
                paramsCopy[kQNBaseManagerRequestID] = @(requestId);
                //拦截器
                [self afterCallingAPIWithParams:paramsCopy];
                return requestId;
            }else{
                [self failedOnCallingAPI:nil withErrorType:QNManagerErrorTypeNoNetWork];
                return requestId;
            }
        }else {
            [self failedOnCallingAPI:nil withErrorType:QNManagerErrorTypeParamsError];
            return requestId;
        }
        
    }
    return requestId;
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(QNURLResponse *)response
{
    self.isLoading = NO;
    self.response = response;
    //本地请求
    if ([self.child shouldLoadFromNative]) {
        if (response.isCache == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:response.responseData forKey:[self.child methodName]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];

    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {//验证器
        if ([self beforePerformSuccessWithResponse:response]) {
            if ([self.child shouldLoadFromNative]) {
                if (response.isCache == YES) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
                if (self.isNativeDataEmpty) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
            } else {
                [self.delegate managerCallAPIDidSuccess:self];
            }
        }
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:QNManagerErrorTypeNoContent];
    }
    
}
- (void)failedOnCallingAPI:(QNURLResponse *)response withErrorType:(QNManagerErrorType)errorType
{
    self.isLoading = NO;
    self.response = response;
    
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self beforePerformFailWithResponse:response]) {
        [self.delegate managerCallAPIDidFailed:self];
    }
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for interceptor
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}
- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}
- (BOOL)beforePerformSuccessWithResponse:(QNURLResponse *)response
{
    BOOL result = YES;
    
    self.errorType = QNManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(QNURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}
- (void)loadDataFromNative
{
    NSString *methodName = self.child.methodName;
    NSDictionary *result = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:methodName];
    if (result) {
        self.isNativeDataEmpty = NO;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            QNURLResponse *response = [[QNURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:NULL]];
            [strongSelf successedOnCallingAPI:response];
        });
    } else {
        self.isNativeDataEmpty = YES;
    }
}
- (BOOL)beforePerformFailWithResponse:(QNURLResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(QNURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}


#pragma mark - getters and setters
- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}


- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (BOOL)isReachable
{
    BOOL isReachability = [QNAppContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = QNManagerErrorTypeNoNetWork;
    }
    return isReachability;
}
- (BOOL)shouldLoadFromNative
{
    return NO;
}


@end
