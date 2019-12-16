//
//  PublicLibrary.m
//  Cleanpro
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PublicLibrary.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

static const char encodingTable[] ="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

#define LocalStr_None @""//空字符串

// key跟后台协商一个即可，保持一致
static NSString *const PSW_AES_KEY = @"这里填写客户端跟后台商量的key";
// 这里的偏移量也需要跟后台一致，一般跟key一样就行
static NSString *const AES_IV_PARAMETER = @"";
/**
 加密储存的函数
 */
@implementation jiamiStr


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





+(NSString *)base64Data_encrypt:(NSString *)key
{
    
    // 获取需要加密文件的二进制数据
    NSData *data =  [key dataUsingEncoding: NSASCIIStringEncoding];
    
    // 或 base64EncodedStringWithOptions
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    // 将加密后的文件存储到桌面
    //    [base64Data writeToFile:@"/Users/wangpengfei/Desktop/IDNumber" atomically:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:base64Data forKey:@"YonghuID"];
    return nil;
}

+(NSString *)base64Data_decrypt
{
    // 获得加密后的二进制数据
    //     NSData *base64Data = [NSData dataWithContentsOfFile:@"/Users/wangpengfei/Desktop/IDNumber"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 读取账户
    NSData *base64Data = [userDefaults objectForKey:@"YonghuID"];
    
    // 解密 base64 数据
    NSData *baseData = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
    NSString* aStr = [[NSString alloc] initWithData:baseData encoding:NSASCIIStringEncoding];
    return aStr;
    
}


/**
 字典转Json字符串
 
 @param infoDict 字典
 @return 字符串
 */
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

/**
  JSON字符串转化为字典

 @param jsonString 字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


//AES加密

+(NSString*)AesEncrypt:(NSString*)str{
    Byte byte[] ={0x00,0x01,0x12,0x13,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f};
    NSData *temphead = [[NSData alloc]initWithBytes:byte length:16];
    NSString * key =  [[NSString alloc] initWithData:temphead  encoding:NSUTF8StringEncoding];
//    NSString*key=@"s8fPakpoE1j676v6";//密钥
    
    NSData*data=[str dataUsingEncoding:NSUTF8StringEncoding];//待加密字符转为NSData型
    
    char keyPtr[kCCKeySizeAES128+1];
    
    memset(keyPtr,0,sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr)encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void*buffer =malloc(bufferSize);
    
    size_t numBytesCrypted =0;
    
    CCCryptorStatus cryptStatus =CCCrypt(
                                        kCCEncrypt, //  加密    kCCDecrypt解密
                                         kCCAlgorithmAES128, //填充方式
                                         kCCOptionPKCS7Padding|kCCOptionECBMode, //工作模式
                                         keyPtr,//AES的密钥长度有128字节、192字节、256字节几种，这里举出可能存在的最大长度
                                         kCCBlockSizeAES128,//密文长度+补位长度
                                         nil,//偏移量，由于是对称加密，用不到
                                         [data bytes],//字节大小
                                         dataLength, //字节长度
                                         buffer,
                                         bufferSize,
                                         &numBytesCrypted);
    
    if(cryptStatus ==kCCSuccess) {
        
        NSData*resultData=[NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
        NSString*result =[self base64EncodedStringFrom:resultData];
        
        return result;
        
    }
    
    free(buffer);
    
    return str;
    
}

//解密操作：

+(NSString*)AesDecrypt:(NSString*)str{
    
    NSString*key=@"s8fPakpoE1j676v6";//密钥
    
    NSData*data=[self dataWithBase64EncodedString:str];// base4解码
    
    char keyPtr[kCCKeySizeAES128+1];
    
    memset(keyPtr,0,sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr)encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength +kCCBlockSizeAES128;
    
    void*buffer =malloc(bufferSize);
    
    size_t numBytesCrypted =0;
    
    CCCryptorStatus cryptStatus =CCCrypt(kCCDecrypt,kCCAlgorithmAES128,kCCOptionPKCS7Padding|kCCOptionECBMode,keyPtr,kCCBlockSizeAES128,nil,[data bytes],dataLength,buffer,bufferSize,&numBytesCrypted);
    
    if(cryptStatus ==kCCSuccess) {
        NSData*resultData=[NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString*result =[[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
        return result;
    }
    free(buffer);
    return str;
    
}




+ (NSString*)base64StringFromText:(NSString*)text

{
    
    if(text && ![text isEqualToString:LocalStr_None]) {
        
        NSData*data = [text dataUsingEncoding:NSUTF8StringEncoding];
        
        return[self base64EncodedStringFrom:data];
        
    }
    
    else{
        
        return LocalStr_None;
        
    }
    
}

+ (NSString*)textFromBase64String:(NSString*)base64

{
    
    if(base64 && ![base64 isEqualToString:LocalStr_None]) {
        
        NSData*data = [self dataWithBase64EncodedString:base64];
        
        return[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    
    else{
        
        return LocalStr_None;
        
    }
    
}

+ (NSData*)dataWithBase64EncodedString:(NSString*)string

{
    
    if(string ==nil)
        
        [NSException raise:NSInvalidArgumentException format:nil];
    
    if([string length] ==0)
        
        return[NSData data];
    
    static char*decodingTable =NULL;
    
    if(decodingTable ==NULL)
        
    {
        
        decodingTable =malloc(256);
        
        if(decodingTable ==NULL)
            
            return nil;
        
        memset(decodingTable,CHAR_MAX,256);
        
        NSUInteger i;
        
        for(i =0; i <64; i++)
            
            decodingTable[(short)encodingTable[i]] = i;
        
    }
    
    const char*characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    
    if(characters ==NULL)//Not an ASCII string!
        
        return nil;
    
    char*bytes =malloc((([string length] +3) /4) *3);
    
    if(bytes ==NULL)
        
        return nil;
    
    NSUInteger length =0;
    
    NSUInteger i =0;
    
    while(YES)
        
    {
        
        char buffer[4];
        
        short bufferLength;
        
        for(bufferLength =0;bufferLength<4;i++)
            
        {
            
            if(characters[i] =='\0')
                
                break;
            
            if(isspace(characters[i]) || characters[i] =='=')
                
                continue;
            
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            
            if(buffer[bufferLength++] ==CHAR_MAX)//Illegal character!
                
            {
                
                free(bytes);
                
                return nil;
                
            }
            
        }
        
        if(bufferLength ==0)
            
            break;
        
        if(bufferLength ==1)//At least two characters are needed to produce one byte!
            
        {
            
            free(bytes);
            
            return nil;
            
        }
        
        //Decode the characters in the buffer to bytes.
        
        bytes[length++] = (buffer[0] <<2) | (buffer[1] >>4);
        
        if(bufferLength >2)
            
            bytes[length++] = (buffer[1] <<4) | (buffer[2] >>2);
        
        if(bufferLength >3)
            
            bytes[length++] = (buffer[2] <<6) | buffer[3];
        
    }
    
    bytes =realloc(bytes, length);
    
    return[NSData dataWithBytesNoCopy:bytes length:length];
    
}

+ (NSString*)base64EncodedStringFrom:(NSData*)data

{
    
    if([data length] ==0)
        
        return @"";
    
    char*characters =malloc((([data length] +2) /3) *4);
    
    if(characters ==NULL)
        
        return nil;
    
    NSUInteger length =0;
    
    NSUInteger i =0;
    
    while(i < [data length])
        
    {
        
        char buffer[3] = {0,0,0};
        
        short bufferLength =0;
        
        while(bufferLength <3&& i < [data length])
            
            buffer[bufferLength++] = ((char*)[data bytes])[i++];
        
        //Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        
        characters[length++] =encodingTable[(buffer[0] &0xFC) >>2];
        
        characters[length++] =encodingTable[((buffer[0] &0x03) <<4) | ((buffer[1] &0xF0) >>4)];
        
        if(bufferLength >1)
            
            characters[length++] =encodingTable[((buffer[1] &0x0F) <<2) | ((buffer[2] &0xC0) >>6)];
        
        else characters[length++] ='=';
        
        if(bufferLength >2)
            
            characters[length++] =encodingTable[buffer[2] &0x3F];
        
        else characters[length++] ='=';
        
    }
//    -(id)initWithBytesNoCopy:(void *)bytes length:(NSUInteger)length freeWhenDone:(BOOL)flag
    return [[NSString alloc]initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
    
}


+(NSData *)AES128Encrypt:(NSString *)plainText key:(NSString *)key {
    char keyPtr[kCCKeySizeAES128+1];
//    memset(keyPtr, 0, sizeof(keyPtr));
    bzero(keyPtr, sizeof(keyPtr));//清零
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
//    memset(ivPtr, 0, sizeof(ivPtr));
    bzero(ivPtr, sizeof(ivPtr));//清零
    [key getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    NSData* data;
//    data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    data = [jiamiStr getData:plainText];
    
    NSUInteger dataLength = [data length];
    if(!(dataLength==16))
    {
        if(dataLength<16)
        {
            NSMutableData * dataArr = [[NSMutableData alloc] init];
            [dataArr appendData:data];
            for (int i=0; i<(16-dataLength); i++) {
                Byte byte[]={0x00};
                NSData * dataBW = [[NSData alloc]initWithBytes:byte length:sizeof(byte)];
                [dataArr appendData:dataBW];
                data = dataArr;
            }
        }
        
        
    }
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    NSInteger newSize = 0;
    
    if(diff > 0)
    {
        newSize = dataLength + diff;
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
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
//        return [resultData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        return resultData;
    }
    free(buffer);
    return nil;
}


+(NSData *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [key getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    NSData *data = [[NSData alloc] initWithBase64EncodedData:[encryptText dataUsingEncoding:NSUTF8StringEncoding] options:0];
//    NSData *data  = [jiamiStr getData:encryptText];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString *hexString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\0"];
        NSString *trimmedString = [hexString stringByTrimmingCharactersInSet:set];
//        return trimmedString;
        return resultData;
    }
    free(buffer);
    return nil;
}


//  加密方法
//  plainText 加密明文
//  key 加密密钥
+ (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key
{
      NSMutableString *ciphertext = [NSMutableString new];//用于拼接加密后的字符串
      NSData * encryptData =[plainText dataUsingEncoding:NSUTF8StringEncoding];//明文转二进制
      const char *encryptBytes = (const char *)[encryptData bytes];//转字符
      size_t encryptDataLength = [encryptData length];//获取字符长度
      NSData * keyData =[key dataUsingEncoding:NSUTF8StringEncoding];//密钥转二进制
      const char *keyBytes = (const char *)[keyData bytes];//密钥转字符
      //size_t keyDataLength = [keyData length];//获取密钥长度(默认kCCKeySizeDES 8位，你也可以传入自己获取的长度，前提你的key只能写前八位)
      NSString * iv =[NSString stringWithFormat:@"%@",key];//获取8位随机数向量
      NSData * ivData =[iv dataUsingEncoding:NSUTF8StringEncoding];//向量转二进制
      const char *ivBytes = (const char *)[ivData bytes];//向量转字符
      unsigned char buffer[1024 *15];//加密缓存大小 自己写的15k大小 1k 1024b 容纳512个汉子
      memset(buffer, 0, sizeof(char));//给缓存区开辟内存空间
      size_t numBytesEncrypted = 0;//用来表示长度
      CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,//加密，加密类型DES
                                      kCCOptionPKCS7Padding,//在JAVA中使用这种方式加密："DES/CBC/PKCS5Padding" 对应的OC的是 kCCOptionPKCS7Padding.
                                      keyBytes, kCCKeySizeDES,//密钥字符数据，密钥字符长度
                                      ivBytes,//向量字符数据
                                      encryptBytes, encryptDataLength,//明文字符数据，明文字符长度
                                      buffer, 1024 *15,//缓存buffer，缓存buffer长度
                                      &numBytesEncrypted);//获取加密后的字符长度
      if (cryptStatus == kCCSuccess)//加密成功
      {
            NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];//获取加密后的二进制数据
            NSString * one =[self convertDataToHexStr:[iv dataUsingEncoding:NSUTF8StringEncoding]];//向量二进制数据转16进制字符串
            NSString * two = [self convertDataToHexStr:data];//加密后的二进制转16进制字符串
            [ciphertext appendString:one];//拼接向量(根据后台需求 可能固定的向量就不用拼接)
            [ciphertext appendString:two];//拼接加密后的数据
            [ciphertext uppercaseString];//转大写   以上都是根据服务端需求来写,有些可能不是转16进制，可能是base64，可以用GTMBase库，github上搜一下就行。
      }
      return [ciphertext copy];//返回最后字符串 传给后台
}

//解密 就是加密的一个逆推过程 仔细看一下就明白了 就不一一注释
//cioherText 密文
//key 密钥
+ (NSString *)decryptUseDES:(NSString*)cipherText key:(NSString*)key
{
    NSString * ivHex;
    NSString * cipherString =[cipherText copy];
    [cipherString lowercaseString];
    NSString * sub =[self convertDataToHexStr:[@"12345678" dataUsingEncoding:NSUTF8StringEncoding]];//获取向量长度，不一定12345678八位即可，只用来计算长度当然可以直接写个16
    if ([cipherString length]>=[sub length])//截取出密码密文 和 向量密文
    {
        cipherText =[cipherString substringFromIndex:[sub length]];//密码16进制字符串
        ivHex =[cipherString substringToIndex:[sub length]];//向量16进制字符串
    }
    NSData* cipherData = [self convertHexStrToData:cipherText];
    const char *cipherBytes = (const char *)[cipherData bytes];
    size_t ciphertDataLength = [cipherData length];
    NSData * keyData =[key dataUsingEncoding:NSUTF8StringEncoding];
    const char *keyBytes = (const char *)[keyData bytes];
    // size_t keyDataLength = [keyData length];
    NSData * ivData =[self convertHexStrToData:ivHex];
    const char *ivBytes = (const char *)[ivData bytes];
    unsigned char buffer[1024 * 15];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,kCCOptionPKCS7Padding,
                                          keyBytes,kCCKeySizeDES,
                                          ivBytes,
                                          cipherBytes,ciphertDataLength,
                                          buffer,1024 * 15,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess)
    {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertDataToHexStr:(NSData *)data
{
     NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];

    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}
////将十六进制的字符串转换成NSString则可使用如下方式:
//+ (NSData *)convertHexStrToData:(NSString *)str
//{
//    if (!str || [str length] == 0)
//    {
//        return nil;
//    }
//    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
//    NSRange range;
//    if ([str length] % 2 == 0)
//    {
//        range = NSMakeRange(0, 2);
//    } else {
//        range = NSMakeRange(0, 1);
//    }
//    for (NSInteger i = range.location; i < [str length]; i += 2) {
//        unsigned int anInt;
//        NSString *hexCharStr = [str substringWithRange:range];
//        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
//        [scanner scanHexInt:&anInt];
//        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
//        range.location += range.length;
//        range.length = 2;
//    }
//    return hexData;
//}


@end

@implementation PublicLibrary

+(NSString *)timeString:(NSString*)timeStampString
{
    // timeStampString 是服务器返回的13位时间戳
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    
//    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}







@end
