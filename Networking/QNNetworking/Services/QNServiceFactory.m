//
//  QNServiceFactory.m
//  QNNetworking
//
//  Created by 研究院01 on 16/12/16.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import "QNServiceFactory.h"
#import "QNDemoService.h"

/*************************************************************************/

// service name list
NSString * const kQNServiceDemo = @"kQNServiceDemo";


@interface QNServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation QNServiceFactory

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QNServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QNServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (QNService<QNServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (QNService<QNServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kQNServiceDemo]) {
        return [[QNDemoService alloc] init];
    }
    
    return nil;
}

@end
