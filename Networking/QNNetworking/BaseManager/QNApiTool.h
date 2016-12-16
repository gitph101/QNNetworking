//
//  QNApiTool.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/14.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNURLResponse.h"

typedef void(^QNCallback) (QNURLResponse *response);

@interface QNApiTool : NSObject

+(instancetype)shareInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail;

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail;

- (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail;

- (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail;

@end
