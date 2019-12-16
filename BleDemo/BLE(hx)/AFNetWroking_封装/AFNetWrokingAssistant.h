//
//  AFNetWrokingAssistant.h
//  StorHub
//
//  Created by Pakpobox on 2018/2/24.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
@interface AFNetWrokingAssistant : NSObject
#define ShareDefaultNetAssistant [AFNetWrokingAssistant shareAssistant]

+(AFNetWrokingAssistant *)shareAssistant;
//常用网络请求方法
-(void)POSTWithCompleteURL:(NSString *)URLString
                parameters:(id)parameters
                  progress:(void(^)(id progress))progress
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
                  useHTTPS:(BOOL)use;
//常用Post网络请求方法
-(void)POSTWithCompleteURL:(NSString *)URLString
                parameters:(id)parameters
                  progress:(void(^)(id progress))progress
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

-(void)PostURL:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))Progress Success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;


///// 获取 statusCode
//-(void)PostURL:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))Progress statusCode:(void (^)(NSInteger statusCode))success Success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
-(void)PostURL_Code:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))Progress Success:(void (^)(NSInteger statusCode,id responseObject))Success failure:(void (^)(NSError *error))failure;

///// 获取 请求头加token   error 也返回 statusCode
//-(void)PostURL_Token:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))Progress Success:(void (^)(NSInteger statusCode,id responseObject))Success failure:(void (^)(NSError *error))failure;
-(void)PostURL_Token:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))Progress Success:(void (^)(NSInteger statusCode,id responseObject))Success failure:(void (^)(NSInteger statusCode,NSError *error))failure;

/////请求头加token
-(void)GETWithCompleteURL_token:(NSString *)URLString
                     parameters:(id)parameters
                       progress:(void(^)(id progress))progress
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSInteger statusCode,NSError *error))failure;
//常用Get网络请求方法
-(void)GETWithCompleteURL:(NSString *)URLString
               parameters:(id)parameters
                 progress:(void(^)(id progress))progress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  图片上传
 *
 *  @param imgArr 图片数组
 *  @param block  返回图片地址数组
 */
- (void)uploadImagesWihtImgArr:(NSArray *)imgArr
                           url:(NSString *)url
                    parameters:(id)parameters
                         block:(void (^)(id objc,BOOL success))block;

/**
 文件下载
 
 @param urlString 请求地址
 @param block 状态通知
 */
- (void)downFileWithUrl:(NSString *)urlString
                  block:(void (^)(id objc,BOOL success))block;

/**
 iOS SSL 单项验证

 @return setHttpsMange
 */
//+ (AFHTTPSessionManager *)setHttpsMange;

@end
