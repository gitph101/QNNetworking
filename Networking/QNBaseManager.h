//
//  QNBaseManager.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/14.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QNBaseManager;

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString * const kQNBaseManagerRequestID = @"kQNBaseManagerRequestID";

/*************************************************************************************************/
/*                               QNAPIManagerApiCallBackDelegate                                 */
/*************************************************************************************************/

@protocol QNManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(QNBaseManager *)manager;
- (void)managerCallAPIDidFailed:(QNBaseManager *)manager;
@end
/*************************************************************************************************/
/*                               QNManagerCallbackDataReformer                                */
/*************************************************************************************************/
@protocol QNManagerDataReformer <NSObject>
@required
- (id)manager:(QNBaseManager *)manager reformData:(NSDictionary *)data;
@end

typedef NS_ENUM (NSUInteger, QNManagerErrorType){
    QNManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    QNManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    QNManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    QNManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    QNManagerErrorTypeTimeout,       //请求超时。QNProxy设置的是20秒超时，具体超时时间的设置请自己去看QNProxy的相关代码。
    QNManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, QNManagerRequestType){
    QNManagerRequestTypeGet,
    QNManagerRequestTypePost,
    QNManagerRequestTypePut,
    QNManagerRequestTypeDelete
};

/*************************************************************************************************/
/*                                         QNManager                                          */
/*************************************************************************************************/
/*
 QNBaseManager的派生类必须符合这些protocal
 */

@protocol QNManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (QNManagerRequestType)requestType;
- (BOOL)shouldCache;

// used for pagable API Managers mainly
@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;
- (BOOL)shouldLoadFromNative;

@end

/*************************************************************************************************/
/*                                QNManagerParamSourceDelegate                                */
/*************************************************************************************************/
//让manager能够获取调用API所需要的数据
@protocol QNManagerParamSource <NSObject>
@required
- (NSDictionary *)paramsForApi:(QNBaseManager *)manager;

@end



@interface QNBaseManager : NSObject

@property (nonatomic, weak) id<QNManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<QNManagerParamSource> paramSource;
@property (nonatomic, weak) NSObject<QNManager> *child; //里面会调用到NSObject的方法，所以这里不用id

@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) QNManagerErrorType errorType;
//@property (nonatomic, strong) CTURLResponse *response;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;


@end
