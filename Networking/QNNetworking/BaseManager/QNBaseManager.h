//
//  QNBaseManager.h
//  QNNetworking
//
//  Created by 研究院01 on 16/12/14.
//  Copyright © 2016年 研究院01. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QNBaseManager;
@class QNURLResponse;

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
/*
 这里实现了两种缓存方法
 1.QNCache是本地实现的缓存，把网络数据主动的存储到NSCache里面。支持单个接口请求的缓存
 2.urlCache:iOS5以后url支持内存缓存和磁盘缓存，只需要服务器设置cache-control即可。只支持整体缓存
 */

@protocol QNManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (QNManagerRequestType)requestType;

// used for pagable API Managers mainly
@optional
- (BOOL)shouldCache;
- (NSString *)urlString;
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;
- (BOOL)shouldLoadFromNative;

@end

/*************************************************************************************************/
/*                                    CTAPIManagerInterceptor                                    */
/*************************************************************************************************/
/*
 QNAPIBaseManager的派生类必须符合这些protocal
 */
@protocol QNManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(QNBaseManager *)manager beforePerformSuccessWithResponse:(QNURLResponse *)response;
- (void)manager:(QNBaseManager *)manager afterPerformSuccessWithResponse:(QNURLResponse *)response;

- (BOOL)manager:(QNBaseManager *)manager beforePerformFailWithResponse:(QNURLResponse *)response;
- (void)manager:(QNBaseManager *)manager afterPerformFailWithResponse:(QNURLResponse *)response;

- (BOOL)manager:(QNBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(QNBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end


/*************************************************************************************************/
/*                                QNManagerParamSourceDelegate                                */
/*************************************************************************************************/
//让manager能够获取调用API所需要的数据
@protocol QNManagerParamSource <NSObject>
@required
- (NSDictionary *)paramsForApi:(QNBaseManager *)manager;

@end

/*************************************************************************************************/
/*                                     QNManagerValidator                                     */
/*************************************************************************************************/
//验证器，用于验证API的返回或者调用API的参数是否正确
@protocol QNManagerValidator <NSObject>
@required
/*
 所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 因为判断逻辑都在这里做掉了。
 而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
 */
- (BOOL)manager:(QNBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

- (BOOL)manager:(QNBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end



@interface QNBaseManager : NSObject

@property (nonatomic, weak) id<QNManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<QNManagerParamSource> paramSource;
@property (nonatomic, weak) id<QNManagerInterceptor> interceptor;//拦截器
@property (nonatomic, weak) id<QNManagerValidator> validator;//检查器
@property (nonatomic, weak) NSObject<QNManager> *child; //里面会调用到NSObject的方法，所以这里不用id

@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) QNManagerErrorType errorType;
@property (nonatomic, strong) QNURLResponse *response;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

-(NSInteger)loadData;

@end
