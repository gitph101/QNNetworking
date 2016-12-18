//
//  QNCacheObject.h
//  QNNetworking
//
//  Created by 曲年 on 2016/12/18.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNCacheObject : NSObject

@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content;
- (void)updateContent:(NSData *)content;

@end
