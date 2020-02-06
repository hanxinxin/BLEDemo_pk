//
//  AES_SecurityUtil.h
//  AES加解密(后台使用AES+CBC+NoPadding模式)
//
//  Created by 一介布衣 on 2017/5/5.
//  Copyright © 2017年 HUAMANLOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES_SecurityUtil : NSObject


/**
 加密

 @param plaintext 明文
 @return 返回密文是十六进制的字符串
 */
//+ (NSString *)aes128EncryptWithContent:(NSString *)plaintext;
//+ (NSString *)aes128EncryptWithContent:(NSString *)plaintext KeyStr:(NSString *)KeyString gIvStr:(NSString *)gIvString;
+ (NSString *)aes128EncryptWithContent:(NSString *)plaintext KeyStr:(char * )KeyString gIvStr:(char *)gIvString;




//!MARK:- 加密 返回data  传入16进制字符串
+ (NSData *)aes128EncryptWithContentDataStr:(NSString *)plaintext KeyStr:(char * )KeyString gIvStr:(char *)gIvString;

//!MARK:- 加密 返回data 传入NSdata
+ (NSData *)aes128EncryptWithContentData:(NSData *)data KeyStr:(char * )KeyString gIvStr:(char *)gIvString;

/**
 解密

 @param ciphertext 密文
 @return 返回明文的十六进制的字符串
 */
//+ (NSString *)aes128DencryptWithContent:(NSString *)ciphertext;
+ (NSString *)aes128DencryptWithContent:(NSString *)ciphertext KeyStr:(char * )KeyString gIvStr:(char *)gIvString;


///传入的是NSData 类型
+ (NSData *)aes128DencryptWithContentData:(NSData *)data KeyStr:(char * )KeyString gIvStr:(char *)gIvString;



+(NSData *) getData: (NSString *) t ;
// 十六进制字符串转换成NSData
+(NSData *)convertHexStrToData:(NSString *)str;

@end
