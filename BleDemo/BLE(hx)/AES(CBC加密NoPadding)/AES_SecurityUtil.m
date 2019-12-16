//
//  AES_SecurityUtil.m
//  AES加解密(后台使用AES+CBC+NoPadding模式)
//
//  Created by 一介布衣 on 2017/5/5.
//  Copyright © 2017年 HUAMANLOU. All rights reserved.
//

#import "AES_SecurityUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "BinHexOctUtil.h"



/**
 说明
 * SecretKey：@"16位长度的字符串"   //自行修改
 * gIv： @"16位长度的字符串"        //自行修改
 */
#define SecretKey @"zkrj001234567890" //! 加解密的密钥
#define gIv @"zkrj001234567890"       //! 初始向量的值


@implementation AES_SecurityUtil
+(NSData *) getData: (NSString *) t {
    NSString * d = t;
    if (d == nil || d.length == 0) d = @"00";

    return [self convertHexStrToData:[NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]];
    
}

// 十六进制字符串转换成NSData
+(NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

//!MARK:- 加密
+ (NSString *)aes128EncryptWithContent:(NSString *)plaintext KeyStr:(char * )KeyString gIvStr:(char *)gIvString{
    
//    char keyPtr[kCCKeySizeAES128+1];
//    memset(keyPtr, 0, sizeof(keyPtr));
////    [SecretKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//    [KeyString getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//    char keyPtr[kCCKeySizeAES128+1]={0xc0,0x07,0x12,0x63,0xa9,0x05,0x61,0x16,0x09,0x18,0x0a,0x51,0x4c,0xd7,0x49,0x00};
//    char ivPtr[kCCKeySizeAES128+1]={0xc0,0x07,0x12,0x63,0xa9,0x05,0x61,0x16,0x09,0x18,0x0a,0x51,0x4c,0xd7,0x49,0x00};
    
//    char ivPtr[kCCBlockSizeAES128+1];
//    memset(ivPtr, 0, sizeof(ivPtr));
////    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
//    [gIvString getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
//    NSData* data = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [AES_SecurityUtil getData:plaintext];
    NSUInteger dataLength = [data length];
    
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    int newSize = 0;
    
    if(diff > 0)
    {
        newSize = (int)dataLength + diff;
    }
    
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,               //No padding
                                          KeyString,
                                          kCCKeySizeAES128,
                                          gIvString,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSLog(@"加密后的 data = %@",resultData);
        return [BinHexOctUtil convertDataToHexStr:resultData];
    }
    free(buffer);
    return nil;
}


//!MARK:- 解密
+ (NSString *)aes128DencryptWithContent:(NSString *)ciphertext KeyStr:(char * )KeyString gIvStr:(char *)gIvString{
    
//    NSData *data1 = [BinHexOctUtil convertHexStrToData:ciphertext];
//    ciphertext = [GTMBase64 stringByEncodingData:data1];
    
//    char keyPtr[kCCKeySizeAES128 + 1];
//    memset(keyPtr, 0, sizeof(keyPtr));
//    [SecretKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
////    [KeyString getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];


//    char ivPtr[kCCBlockSizeAES128 + 1];
//    memset(ivPtr, 0, sizeof(ivPtr));
//    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
////    [gIvString getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
//
    
//    NSData *data = [GTMBase64 decodeData:[ciphertext dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [AES_SecurityUtil convertHexStrToData:ciphertext];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,   //No padding
                                          KeyString,
                                          kCCBlockSizeAES128,
                                          gIvString,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
//        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        return [BinHexOctUtil convertDataToHexStr:resultData];
    }
    free(buffer);
    return nil;
}



@end
