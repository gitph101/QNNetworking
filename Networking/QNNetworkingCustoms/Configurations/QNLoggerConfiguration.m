//
//  QNLoggerConfiguration.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/16.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNLoggerConfiguration.h"

@implementation QNLoggerConfiguration

- (void)configWithAppType:(QNAppType)appType
{
    switch (appType) {
        case QNAppTypexxx:
            self.appKey = @"xxxxxx";
            self.serviceType = @"xxxxx";
            self.sendLogMethod = @"xxxx";
            self.sendActionMethod = @"xxxxxx";
            self.sendLogKey = @"xxxxx";
            self.sendActionKey = @"xxxx";
            break;
    }
}


@end
