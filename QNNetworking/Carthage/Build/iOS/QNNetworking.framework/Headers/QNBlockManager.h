//
//  QNBlockManager.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/19.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNURLResponse.h"
#import "QNApiTool.h"
#import "QNBaseManager.h"
@interface QNBlockManager : QNBaseManager<QNManager>

-(NSInteger)loadData;

-(void)GETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail;
-(void)POSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(QNCallback)success fail:(QNCallback)fail;
-(void)GETWithParams:(NSDictionary *)params urlString:(NSString *)urlString success:(QNCallback)success fail:(QNCallback)fail;
-(void)POSTWithParams:(NSDictionary *)params urlString:(NSString *)urlString success:(QNCallback)success fail:(QNCallback)fail;
@end
