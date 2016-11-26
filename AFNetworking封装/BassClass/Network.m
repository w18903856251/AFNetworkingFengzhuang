//
//  Network.m
//  AFNetworking封装
//
//  Created by zhangqian on 16/11/25.
//  Copyright © 2016年 Development. All rights reserved.
//

#import "Network.h"
#import "RTHttpClient.h"

@implementation Network

+ (NSMutableDictionary *)initDic{
    NSMutableDictionary *para = [[NSMutableDictionary alloc]init];
    return para;
}



+ (void)loginWithLoginName:(NSString*)loginName passWord:(NSString*)password success:(void(^)(id obj))SuccessBlock fail:(void (^)(id obj))FailedBlock complete:(void (^)(id obj))CompleteBlock{
    
    NSMutableDictionary *para = [self initDic];
    [para setObject:loginName forKey:@"loginName"];
    [para setObject:password  forKey:@"password"];
    [para setObject:@"iphone" forKey:@"phoneType"];
    [para setObject:@"6c43b9e88b7d1e664e5677c1c2e6155e556bae0f6bc618d122bf9cb76e3e0daa" forKey:@"deviceToken"];
    [[RTHttpClient defaultClient]requestWithPath:@"http://www.2schome.net/mobile/carman/login.json" method:RTHttpRequestPost parameters:para prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"请求成功");
        //NSString  *message = responseObject[@"message"];
//        if ([BaseHandle isHttpRequestSuccess:message]) {
//            
//            
//            //            [App_Hud showSuccessMessage:@"登录成功"];
//            //            LoginEntity   *entity = [[LoginEntity alloc] initWithDictionary:responseObject error:nil];
//            //            [APPDELEGATE setTestUserInfo:entity.user_id];
//            //            [DataManager saveUserPushToken:entity.deviceToken];
//            //            debugLog(@"phoneMsg = %@ token = %@",entity.phoneMsg,entity.id);
//            //            // debugLog(@"+++++++++%@",responseObject);
//            //            [DataManager updateUserData:entity];
//            SuccessBlock(responseObject);
//        }else {
//            FailedBlock(message);
//        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code!=-999) {
            CompleteBlock(error);
        }
    }];
}


@end
