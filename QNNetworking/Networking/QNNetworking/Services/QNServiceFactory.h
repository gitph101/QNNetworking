//
//  QNServiceFactory.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/16.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QNService.h"

@interface QNServiceFactory : NSObject

+ (instancetype)sharedInstance;
- (QNService<QNServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end

