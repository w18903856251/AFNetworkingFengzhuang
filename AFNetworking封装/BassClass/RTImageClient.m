//
//  RTImageClient.m
//  AFNetworking封装
//
//  Created by zhangqian on 16/11/26.
//  Copyright © 2016年 Development. All rights reserved.
//

#import "RTImageClient.h"
#import <AFNetworking.h>

#define TIME_OUT_INTERVAL   60.f
//#endif

#define MAX_CONCURRENTOPERATION 4
#define MIN_UPLOAD_RESOLUTION   1024.f
#define MAX_UPLOAD_SIZE         50*1024     //50kb

@interface RTImageClient()
//@property(nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) AFHTTPSessionManager  *manager;
@end


@implementation RTImageClient

+ (RTImageClient *)defaultClient
{
    static RTImageClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]){
        self.manager = [AFHTTPSessionManager manager];
        //  self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:PICURL]];
        //请求参数序列化类型
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //响应结果序列化类型
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer]; //AFJSONResponseSerializer
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        self.manager.operationQueue.maxConcurrentOperationCount = MAX_CONCURRENTOPERATION;
        self.manager.requestSerializer.timeoutInterval = TIME_OUT_INTERVAL;
        
    }
    
    return self;
}


#pragma -
#pragma mark - 图片上传
- (void)uploadWithPath:(NSString *)path paremeters:(NSArray *)parameters
               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              progress:(void (^)(float rate))Progress
               failure:(void (^)(NSURLSessionDataTask *task, NSError *error ,NSArray *parameters))failure
{
    
    
    [self.manager POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString  *fileName = [NSString stringWithFormat:@"%@.jpg",[self generateRandomKeyLength:16]];
        //         debugLog(@"name:%@",fileName);
        [formData appendPartWithFileData:parameters[0]  name:@"Filedata"fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        Progress((float )uploadProgress.completedUnitCount/uploadProgress.totalUnitCount*100);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error,parameters);
    }];
    parameters = nil;
    //    NSURLSessionDataTask *operation = [_manager POST:path
    //                                          parameters:nil
    //                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //
    //                               NSString  *fileName = [NSString stringWithFormat:@"%@.jpg",[self generateRandomKeyLength:16]];
    //                               //         debugLog(@"name:%@",fileName);
    //                               [formData appendPartWithFileData:parameters[0]  name:@"Filedata"fileName:fileName mimeType:@"image/jpeg"];
    //
    //                           } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //                               //成功后回调
    //
    //
    //                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //                               //失败后回调
    //                           }];
    //
    //    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    //        //进度
    //        self.progressBlock(totalBytesWritten*1.0/totalBytesExpectedToWrite);
    //    }];
    
    
    
    
}
#pragma -
#pragma mark - 多图片上传
//- (void)uploadMultiWithPath:(NSString *)path paremeters:(NSArray *)parameters
//                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
//{
//    NSString  *urlString = [NSString stringWithFormat:@"%@%@",self.manager.baseURL,path];
//
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//        for (int i = 0; i<parameters.count; i++) {
//            NSString  *path = [[NSBundle mainBundle] pathForResource:parameters[i] ofType:@"jpg"];
//            NSData   *image = [[NSData alloc] initWithContentsOfFile:path];
//
//            [formData appendPartWithFileData:image name:[NSString stringWithFormat:@"参数%d",i+1] fileName:@"test.jpg" mimeType:@"image/jpg"];
//        }
//    } error:nil];
//
//    NSURLSessionDataTask *opration = [[NSURLSessionDataTask alloc] initWithRequest:request];
//    opration.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [opration setCompletionBlockWithSuccess:^(NSURLSessionDataTask *operation, id responseObject) {
////        debugLog(@"上传成功:%@",responseObject);
//    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
////        debugLog(@"上传失败:%@",error.description);
//    }];
//    [opration start];
//}

#pragma mark - 图片处理
- (NSData *)compressImg:(UIImage *)img
{
    @autoreleasepool {
        //Resize the image
        float width ;
        float height ;
        //    debugLog(@"初始宽高:%f  %F",img.size.width,img.size.height);
        if (img.size.height >MIN_UPLOAD_RESOLUTION || img.size.width >MIN_UPLOAD_RESOLUTION){
            
            if (img.size.width > img.size.height ) {
                width = MIN_UPLOAD_RESOLUTION;
                height = (img.size.height*MIN_UPLOAD_RESOLUTION)/img.size.width;
            }else {
                height = MIN_UPLOAD_RESOLUTION;
                width = (img.size.width*MIN_UPLOAD_RESOLUTION)/img.size.height;
            }
            
            img = [self scaleDown:img withSize:CGSizeMake(width,height)];
        }
        
        //Compress the image
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.1f;
        
        NSData *imageData = UIImageJPEGRepresentation(img, compression);
        
        while ([imageData length] > MAX_UPLOAD_SIZE && compression > maxCompression)
        {
            compression -= 0.10;
            //        debugLog(@"当前压缩比 compression:%f",compression);
            imageData = UIImageJPEGRepresentation(img, compression);
            //        NSLog(@"Compress : %d",imageData.length);
        }
        return imageData;
        //        [self saveImage:imageData];
    }
}

-(UIImage*)scaleDown:(UIImage*)img withSize:(CGSize)size{
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [img drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)saveImage:(NSData *)imgData
{
    if (imgData == nil) return;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *random_name = [self generateRandomKeyLength:16];
    random_name = [NSString stringWithFormat:@"%@.jpg",random_name];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:random_name];
    [imgData writeToFile:path atomically:YES];
}

- (NSString *)generateRandomKeyLength:(NSInteger)length
{
    if (length<=0) {
        return nil;
    }
    NSString *sourceString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-*/_=";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand((unsigned int)time(0));
    for (NSInteger i = 0; i < length; i++){
        NSInteger index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

#pragma mark - 取消上传 操作
- (void)cancelUploadRequest
{
    [self.manager.operationQueue cancelAllOperations];
}


@end
