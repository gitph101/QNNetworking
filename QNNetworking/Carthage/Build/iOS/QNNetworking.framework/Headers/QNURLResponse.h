//
//  QNURLResponse.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/15.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNNetworkingConfiguration.h"


@interface QNURLResponse : NSObject

@property (nonatomic, assign, readonly) QNURLResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;

@property (nonatomic, assign, readonly) BOOL isCache;



- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(QNURLResponseStatus)status;
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;
- (instancetype)initWithData:(NSData *)data;
@end
