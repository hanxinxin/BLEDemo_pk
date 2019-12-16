//
//  PublicLibrary.h
//  Cleanpro
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 加密储存的函数
 */
@interface jiamiStr :NSObject
+(NSString *)base64Data_encrypt:(NSString *)key;
+(NSString *)base64Data_decrypt;
//+ (AFSecurityPolicy*)customSecurityPolicy;

//AES加密和解密

+(NSString*)AesEncrypt:(NSString*)str;

+(NSString*)AesDecrypt:(NSString*)str;

/// CBC，NoPadding，ivP = key
+(NSData *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
+(NSData *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;

+(NSData *) getData: (NSString *) t;
// 十六进制字符串转换成NSData
+(NSData *)convertHexStrToData:(NSString *)str;


//  加密方法
//  plainText 加密明文
//  key 加密密钥
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;
//解密 就是加密的一个逆推过程 仔细看一下就明白了 就不一一注释
//cioherText 密文
//key 密钥
+ (NSString *)decryptUseDES:(NSString*)cipherText key:(NSString*)key;
/**
 字典转Json字符串
 
 @param infoDict 字典
 @return 字符串
 */
+ (NSString*)convertToJSONData:(id)infoDict;
/**
 JSON字符串转化为字典
 
 @param jsonString 字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

////公共类
@interface PublicLibrary : NSObject

+(NSString *)timeString:(NSString*)timeStampString;

@end

