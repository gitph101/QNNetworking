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
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QNUrlCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QNUrlCache alloc] init];
    });
    return sharedInstance;
}



@end
