//
//  Network.h
//  AFNetworking封装
//
//  Created by zhangqian on 16/11/25.
//  Copyright © 2016年 Development. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^success)(id obj);
typedef void(^failed)(id obj);
typedef void(^complete)(id obj);


@interface Network : NSObject

#pragma mark 登录
+ (void)loginWithLoginName:(NSString*)loginName passWord:(NSString*)password success: (success) SuccessBlock fail:(failed)FailedBlock complete:(complete)CompleteBlock;


@end
