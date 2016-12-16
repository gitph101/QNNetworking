//
//  NSObject+QNNetworkingMethods_h.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/15.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "NSObject+QNNetworkingMethods.h"

@implementation NSObject (QNNetworkingMethods_h)

- (id)QN_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self QN_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)QN_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}


@end
