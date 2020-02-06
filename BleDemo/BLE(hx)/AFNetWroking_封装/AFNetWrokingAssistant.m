//
//  AFNetWrokingAssistant.m
//  StorHub
//
//  Created by Pakpobox on 2018/2/24.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import "AFNetWrokingAssistant.h"
#import "AFNetworking.h"
//#import "ReSetChallenge.h"

#define ACCEPTTYPENORMAL @[@"application/json",@"application/xml",@"text/json",@"text/javascript",@"text/html",@"text/plain"]
#define ACCEPTTYPEIMAGE @[@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json"]

@interface AFNetWrokingAssistant()
@property (strong,nonatomic)AFHTTPSessionManager *manager;
@end

@implementation AFNetWrokingAssistant

+(AFNetWrokingAssistant *)shareAssistant{
    static dispatch_once_t onceToken;
    static AFNetWrokingAssistant *assistant = nil;
    if (assistant == nil) {
        dispatch_once(&onceToken, ^{
            assistant = [[AFNetWrokingAssistant alloc]init];
        });
    }
    return assistant;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //        [_manager.requestSerializer setTimeoutInterval:50];
        // 设置超时时间
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 60.0f;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [_manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
        // 加上这行代码，https ssl 验证。
//        [_manager setSecurityPolicy:[self customSecurityPolicy]];     
       
    }
    return self;
}

//常用网络请求方法
-(void)POSTWithCompleteURL:(NSString *)URLString
                parameters:(id)parameters
                  progress:(void(^)(id progress))progress
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
                  useHTTPS:(BOOL)use{
    if (use) {
//        [_manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    [self POSTWithCompleteURL:URLString parameters:parameters progress:progress success:success failure:failure];
}

//常用网络请求方法
-(void)POSTWithCompleteURL:(NSString *)URLString
                parameters:(id)parameters
                  progress:(void(^)(id progress))progress
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure{
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
    [self.manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)PostURL:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))Progress Success:(void (^)(id responseObject))Success
       failure:(void (^)(NSError *error))failure
{
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
    [self.manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


///// 返回 statusCode 请求
-(void)PostURL_Code:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))Progress Success:(void (^)(NSInteger statusCode,id responseObject))Success failure:(void (^)(NSError *error))failure
{
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
    [self.manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"task===  %@",task);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
//        statusCode(responses.statusCode);
        NSLog(@"statusCode == %ld",    responses.statusCode );
        Success(responses.statusCode,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/// 请求头加token
-(void)PostURL_Token:(NSArray*)HeaderFieldArray UrlStr:(NSString *)URLString parameters:(id)parameters progress:(void(^)(id progress))Progress Success:(void (^)(NSInteger statusCode,id responseObject))Success failure:(void (^)(NSInteger statusCode,NSError *error))failure
{
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
//    TokenStr HeaderKeyStr:(NSString*)Headerkey
    for (int i=0; i<HeaderFieldArray.count; i++) {
        NSArray * arr = HeaderFieldArray[i];
        [self.manager.requestSerializer setValue: arr[0] forHTTPHeaderField:arr[1]];
    }
    
    [self.manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"task===  %@",task);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        //        statusCode(responses.statusCode);
//        NSLog(@"statusCode == %ld",    responses.statusCode );
        Success(responses.statusCode,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        //        statusCode(responses.statusCode);
//        NSLog(@"statusCode == %ld",    responses.statusCode );
        failure(responses.statusCode,error);
    }];
}

/// 请求头加token
-(void)GETWithCompleteURL_token:(NSArray*)HeaderFieldArray UrlStr:(NSString *)URLString
               parameters:(id)parameters
                 progress:(void(^)(id progress))progress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSInteger statusCode,NSError *error))failure{
    // 设置请求头
//    [self.manager.requestSerializer setValue: TokenStr forHTTPHeaderField:@"userToken"];
    for (int i=0; i<HeaderFieldArray.count; i++) {
        NSArray * arr = HeaderFieldArray[i];
        [self.manager.requestSerializer setValue: arr[0] forHTTPHeaderField:arr[1]];
    }
    //    _manager.securityPolicy=[self customSecurityPolicy];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
    
    [_manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"success");
        //        NSDictionary *responseObject1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        success(responseObject1);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        failure(responses.statusCode,error);
    }];
}


-(void)GETWithCompleteURL:(NSString *)URLString
               parameters:(id)parameters
                 progress:(void(^)(id progress))progress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    // 设置请求头
//    [_manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    
//    _manager.securityPolicy=[self customSecurityPolicy];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPENORMAL];
   
    [_manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"success");
//        NSDictionary *responseObject1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        success(responseObject1);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 *  图片上传
 *
 *  @param imgArr 图片数组
 *  @param block  返回图片地址数组
 */
- (void)uploadImagesWihtImgArr:(NSArray *)imgArr
                           url:(NSString *)url
                    parameters:(id)parameters
                         block:(void (^)(id objc,BOOL success))block{
    // 基于AFN3.0+ 封装的HTPPSession句柄
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:ACCEPTTYPEIMAGE];
    // 在parameters里存放照片以外的对象
    [_manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imgArr.count; i++) {
            UIImage *image = imgArr[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"ssss  == %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,NO);
    }];
}


/**
 文件下载
 
 @param urlString 请求地址
 @param block 状态通知
 */
- (void)downFileWithUrl:(NSString *)urlString
                  block:(void (^)(id objc,BOOL success))block{
    // 2.设置请求的URL地址
    NSURL *url = [NSURL URLWithString:urlString];
    // 3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 下载地址
        NSLog(@"默认下载地址%@",targetPath);
        // 设置下载路径,通过沙盒获取缓存地址,最后返回NSURL对象
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL fileURLWithPath:filePath]; // 返回的是文件存放在本地沙盒的地址
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 下载完成调用的方法
        NSLog(@"%@---%@", response, filePath);
        block(filePath,YES);
    }];
}
/*
//是否加入HTTPS证书
-(AFSecurityPolicy *)customSecurityPolicy
{
    NSString * namePath=@"";
    if (DIQU_Number==2200) {
        namePath=@"storhubuat.pakpobox.com";
    }else if (DIQU_Number==2300)
    {
        namePath=@"storhubapi.pakpobox.com";
    }
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:namePath ofType:@"cer"];//证书的路径
    NSLog(@"cerPath== %@",cerPath);
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}
*/


-(void)cancelTask{
    [self.manager.operationQueue cancelAllOperations];
}

@end
