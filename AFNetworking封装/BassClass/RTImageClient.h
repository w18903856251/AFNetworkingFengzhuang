//
//  RTImageClient.h
//  AFNetworking封装
//
//  Created by zhangqian on 16/11/26.
//  Copyright © 2016年 Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTImageClient : NSObject

+ (RTImageClient *)defaultClient;

- (id)init;
#pragma mark - 图片上传
- (void)uploadWithPath:(NSString *)path paremeters:(NSArray *)parameters
               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              progress:(void (^)(float rate))Progress
               failure:(void (^)(NSURLSessionDataTask *task, NSError *error,NSArray *parameters))failure;

#pragma -
#pragma mark - 多图片上传
- (void)uploadMultiWithPath:(NSString *)path paremeters:(NSArray *)parameters
                    success:(void (^)(NSURLSessionDataTask *task, id))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

#pragma -
#pragma mark - 取消上传 操作
- (void)cancelUploadRequest;
#pragma mark - 图片处理

-(NSData *)compressImg:(id)img;
@end
