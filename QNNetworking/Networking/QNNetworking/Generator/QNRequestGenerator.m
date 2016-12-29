//
//  QNRequestGenerator.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/16.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNRequestGenerator.h"
#import <AFNetworking/AFNetworking.h>
#import "NSURLRequest+QNNetworkingMethods.h"
#import "QNService.h"
#import "QNServiceFactory.h"
#import "QNAppContext.h"


@interface QNRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation QNRequestGenerator

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QNRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QNRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    
    NSString *urlString = [self generateUrlStringWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    
    return request;
    
}
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSString *urlString = [self generateUrlStringWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;

}
- (NSURLRequest *)generatePutRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
     NSString *urlString = [self generateUrlStringWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"PUT" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;

}
- (NSURLRequest *)generateDeleteRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
   NSString *urlString = [self generateUrlStringWithServiceIdentifier:serviceIdentifier requestParams:requestParams methodName:methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"DElETE" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;
}


extern NSString * const kQNServiceMethUrl;

#pragma mark - privite
- (NSString *)generateUrlStringWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
 
    QNService *service = [[QNServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *urlString;
    
    if (service) {
        if (service.apiVersion.length != 0) {
            urlString = [NSString stringWithFormat:@"%@/%@/%@", service.apiBaseUrl, service.apiVersion, methodName];
        } else {
            urlString = [NSString stringWithFormat:@"%@/%@", service.apiBaseUrl, methodName];
        }
    }
    
    if([serviceIdentifier isEqualToString:kQNServiceMethUrl]){
        urlString = methodName;
    }
    return urlString;
}


-(void)generateHttpRequestHTTPHeaderField
{
    [self.httpRequestSerializer setValue:[QNAppContext sharedInstance].imei forHTTPHeaderField:@"imei"];
    [self.httpRequestSerializer setValue:[QNAppContext sharedInstance].appVersion  forHTTPHeaderField:@"version"];
    [self.httpRequestSerializer setValue:[QNAppContext sharedInstance].type forHTTPHeaderField:@"system"];
    [self.httpRequestSerializer setValue:[QNAppContext sharedInstance].os forHTTPHeaderField:@"osVersion"];
    [self.httpRequestSerializer setValue:[QNAppContext sharedInstance].model forHTTPHeaderField:@"model"];
    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    
}

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
//        _httpRequestSerializer.timeoutInterval = kQNNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

@end
