//
//  QNUrlCache.m
//  QNNetworking
//
//  Created by 曲年 on 2016/12/18.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNUrlCache.h"

@implementation QNUrlCache

#pragma mark - life cycle

+ (void)openCache
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:40 * 1024 * 1024 diskPath:@"245"];
    [NSURLCache setSharedURLCache:URLCache];
}
+ (void)offCache
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:@"245"];
    [NSURLCache setSharedURLCache:URLCache];
}

@end
