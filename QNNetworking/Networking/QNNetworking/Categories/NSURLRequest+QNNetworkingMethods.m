//
//  NSURLRequest+QNNetworkingMethods.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/15.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "NSURLRequest+QNNetworkingMethods.h"
#import <objc/runtime.h>

static void *QNNetworkingRequestParams;

@implementation NSURLRequest (QNNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &QNNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &QNNetworkingRequestParams);
}


@end
