//
//  PakpoboxBLE.h
//  BleDemo
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 mac. All rights reserved.
//

#ifndef PakpoboxBLE_h
#define PakpoboxBLE_h
#import <Foundation/Foundation.h>
#import "HXBleManager.h"
#import "AFNetWrokingAssistant.h"


#define HeaderkeyOne @"X-SDK-ACCESS-KEY"
#define HeaderkeyOne1 @"pOBNEV7WGnc7AAQBPWdDPBdj1Dwwjpdy4WDrY78otTx4b8OWTWVsJHHejqhvKD3t"
#define HeaderkeyTwo @"X-SDK-LOCATION-ID"
#define HeaderkeyTwo1 @"BLETEST00001"
#define HeadArray @[@[HeaderkeyOne,HeaderkeyOne1],@[HeaderkeyTwo,HeaderkeyTwo1]]

#define Appkey [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Appkey"]]
//#define CSKeystr [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CSKeystr"]]
#define CSKeystr [[NSUserDefaults standardUserDefaults] objectForKey:@"CSKeystr"]
#define SeqStr [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"SeqStr"]]


///URL
#define ServerPakp @"http://192.168.0.119:83"

#define GetAppKeyUrl @"/api/locker/v1/ble/info/by-site-serial-number/" /// siteSerialNumber 获取 BLE 模块需要的密钥信息等

#define LoginPakp @"/api/user/v1/login/terminal" /// 用户登录

#define YZDanhao @"/api/orders/v1/merchantCheck/"  /// 快递员存，验证运单号

#define SQGekouBox @"/api/orders/v1/merchantStore/occupyBox"  ///申请占用格口

#define JYPickup @""  ///校验取件码

#define C_MerchantStoreExpress @"/api/orders/v1/merchantStoreExpress" ///同步存件信息

#define Q_MerchantTakeExpress @"/api/orders/v1/merchantTakeExpress" ///同步取件信息


#define PostOpenLockKey @"/api/locker/v1/ble/report/use-secret-key" ///提交开锁用的密钥信息

#define GetQuJianInfo @"/api/locker/v1/ble/orders/query"  ///取件时获取订单的信息

//{
//    "macAddress": "F0:7F:57:97:65:DB",
//    "secretKeyList": [
//        {
//            "secretKey": "C1071263A90561A50918C1071263A90561A50918F07F579765DB",
//            "creationTime": 1579078193180
//        }
//    ]
//}

#define BleReport @"/api/locker/v1/ble/report/use-secret-key"  ///提交开锁用的密钥信息


#endif /* PakpoboxBLE_h */
