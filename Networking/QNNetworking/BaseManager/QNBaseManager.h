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
/*                                    CTAPIManagerInterceptor                                    */
/*************************************************************************************************/
/*
 CTAPIBaseManager的派生类必须符合这些protocal
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
/*
 使用场景：
 当我们确认一个api是否真正调用成功时，要看的不光是status，还有具体的数据内容是否为空。由于每个api中的内容对应的key都不一定一样，甚至于其数据结构也不一定一样，因此对每一个api的返回数据做判断是必要的，但又是难以组织的。
 为了解决这个问题，manager有一个自己的validator来做这些事情，一般情况下，manager的validator可以就是manager自身。
 1.有的时候可能多个api返回的数据内容的格式是一样的，那么他们就可以共用一个validator。
 2.有的时候api有修改，并导致了返回数据的改变。在以前要针对这个改变的数据来做验证，是需要在每一个接收api回调的地方都修改一下的。但是现在就可以只要在一个地方修改判断逻辑就可以了。
 3.有一种情况是manager调用api时使用的参数不一定是明文传递的，有可能是从某个变量或者跨越了好多层的对象中来获得参数，那么在调用api的最后一关会有一个参数验证，当参数不对时不访问api，同时自身的errorType将会变为CTAPIManagerErrorTypeParamsError。这个机制可以优化我们的app。
 
 william补充（2013-12-6）：
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 */
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
