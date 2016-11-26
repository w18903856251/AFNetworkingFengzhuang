//
//  RTHttpClient.m
//  AFNetworking封装
//
//  Created by zhangqian on 16/11/25.
//  Copyright © 2016年 Development. All rights reserved.
//

#import "RTHttpClient.h"

#import <AFNetworking.h>
#import <objc/runtime.h>

#define TIME_OUT_INTERVAL   30.f  //超时时间


#define MAX_CONCURRENTOPERATION 3

// 服务器地址
#define TEST @"http://121.40.242.116"                  //测试环境1
#define TEST1 @"http://test.2schome.net"                  //预发布环境
#define TEST2 @"http://app.local.bolext.cn/"             //测试环境2
#define FINAL @"http://www.hx2car.com"    //生产环境


#if DEBUG
#define    BASE_URL         TEST
#else
#define    BASE_URL         FINAL
#endif

@interface RTHttpClient()
//@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;  3.0之前版本
@property (nonatomic,strong) AFHTTPSessionManager  *manager;  //构建管理对象
@end

@implementation RTHttpClient

//   单例
+ (RTHttpClient *)defaultClient
{
    static RTHttpClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}



- (id)init{
    if (self = [super init]){
        //        self.manager = [AFHTTPSessionManager manager];
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        //请求参数序列化类型
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //响应结果序列化类型
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer]; //AFJSONResponseSerializer
        //        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        self.manager.operationQueue.maxConcurrentOperationCount = MAX_CONCURRENTOPERATION;
        self.manager.requestSerializer.timeoutInterval = TIME_OUT_INTERVAL;
        
    }
    return self;
}


- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters prepareExecute:(PrepareExecuteBlock)prepareExecute
                success:(void (^)(NSURLSessionDataTask *, id))success
                failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    
    //判断网络状况（有链接：执行请求；无链接:弹出提示）
    //    if ([self isConnectionAvailable]) {
    
    if (prepareExecute) {
        prepareExecute();
    }
    
    switch (method) {
        case RTHttpRequestGet:
        {
            [self.manager GET:url parameters:parameters progress:nil success:success failure:failure];
            
        }
            break;
        case RTHttpRequestPost:
        {
            [self.manager POST:url parameters:parameters progress:nil success:success failure:failure];
           
        }
            break;
        case RTHttpRequestDelete:
        {
            [self.manager DELETE:url parameters:parameters success:success failure:failure];
        }
            break;
        case RTHttpRequestPut:
        {
            [self.manager PUT:url parameters:parameters success:success failure:false];
        }
            break;
        default:
            break;
    }
    //    }else{
    //        //网络错误咯
    ////        [self showExceptionDialog];
    //        //发出网络异常通知广播
    ////        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil];
    //    }
    
}

// 检测当前网络状态
- (void)AFNetworkStatus{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}


#pragma mark - http error
/**
 *    NSURLErrorUnknown = -1,
 NSURLErrorCancelled = -999,
 NSURLErrorBadURL = -1000,
 NSURLErrorTimedOut = -1001, //超时,或服务器关闭(502 bad)
 NSURLErrorNotConnectedToInternet  = -1009 // 无网络
 NSURLErrorDomain Code=-1003  -1003  未能找到使用指定主机名的服务器
 */


@end
