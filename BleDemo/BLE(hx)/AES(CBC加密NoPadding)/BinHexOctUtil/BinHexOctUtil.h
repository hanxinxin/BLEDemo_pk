//
//  BinHexOctUtil.h
//  AES加解密(后台使用AES+CBC+NoPadding模式)
//
//  Created by 一介布衣 on 2017/5/5.
//  Copyright © 2017年 HUAMANLOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinHexOctUtil : NSObject

//! 二进制转换为十六进制
+ (NSString *)getHexByBinary:(NSString *)binary;

//!  十六进制转换为二进制
+ (NSString *)getBinaryByHex:(NSString *)hex;

//! 十进制转换为二进制
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;

//! 十进制转换为十六进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

//! 二进制转化为十进制
+ (NSInteger)getDecimalByBinary:(NSString *)binary;

//! 十六进制字符串转化为data
+ (NSData *)convertHexStrToData:(NSString *)str;

//! data转换为十六进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;



@end
