//
//  BluetoothSDK.h
//  BleDemo
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/////  2020.1.19日 只对接了一个获取 秘钥和mac地址的接口
@interface BluetoothBusinessSDK : NSObject

//+(void)shareBluetoothSDK;

/// 设置appkey
/// @param Key 后台请求的key
+(void)SetAppkey:(NSString*)Key;

-(void)getServerAppKey:(NSString *)siteSerialNumber;

/// 快递员登录
/// @param Name 用户的name
/// @param Word 用户的password
+(NSInteger)CourierLogin:(NSString*)Name Word:(NSString*)Word;

/// 验证运单号
/// @param expressNumber 运单号
/// @param siteSerialNumber 格口的信息
+(NSInteger)MerchantCheckCode:(NSString*)expressNumber siteSerialNumber:(NSString*)siteSerialNumber;

/// 打开格口
+(NSInteger)OpenCabinet;

/// 取件
/// @param Code 验证码
/// @param BoxInformation 箱子信息
+(NSInteger)PickupVerification:(NSString*)Code BoxInformation:(NSString*)BoxInformation;


@end

NS_ASSUME_NONNULL_END
