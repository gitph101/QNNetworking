//
//  QNLogger.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/16.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QNService;

@interface QNLogger : NSObject

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(QNService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;

@end
