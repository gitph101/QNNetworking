//
//  QNApiTool.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/14.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNApiTool.h"
#import <AFNetworking/AFNetworking.h>
#import "QNRequestGenerator.h"

static NSString * const kAXApiProxyDispatchItemKeyCallbackSuccess = @"kQNApiToolDispatchItemCallbackSuccess";
static NSString * const kAXApiProxyDispatchItemKeyCallbackFail = @"kQNApiToolDispatchItemCallbackFail";
@interface QNApiTool ()

@property(nonatomic,strong) NSMutableDictionary *dispatchTable;
@property(nonatomic,strong) NSNumber *recordedRequestId;
@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;

@end

@implementation QNApiTool

#pragma mark - life cycle

#pragma mark - public methods

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail
{
    NSURLRequest *request = [[QNRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}


- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail
{
    NSURLRequest *request = [[QNRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail
{
    NSURLRequest *request = [[QNRequestGenerator sharedInstance] generatePutRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail
{
    NSURLRequest *request = [[QNRequestGenerator sharedInstance] generateDeleteRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(QNCallback)success fail:(QNCallback)fail
{
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if (error) {
            QNURLResponse *qnResponse = [[QNURLResponse alloc]initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error ];
            fail?fail(qnResponse):nil;
        }else{
            QNURLResponse *ctResponse = [[QNURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:QNURLResponseStatusSuccess];
            success?success(ctResponse):nil;
        }
    }];
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    return requestId;
}

+(instancetype)shareInstance
{
    static QNApiTool *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[QNApiTool alloc]init];
    });
    return shareInstance;
}

+(instancetype)shareInstanceSynchronized
{
    static QNApiTool *shareInstance;
    if (!shareInstance) {
        @synchronized (self) {
            shareInstance = [[QNApiTool alloc]init];
        }
    }
    return shareInstance;
}

-(NSMutableDictionary *)dispatchTable
{
    if(_dispatchTable == nil){
        _dispatchTable = [[NSMutableDictionary alloc]init];
    }
    return _dispatchTable;
}

-(AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

@end
