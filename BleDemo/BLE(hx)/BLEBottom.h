//
//  BLEBottom.h
//  BleDemo
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PakpoboxBLE.h"
NS_ASSUME_NONNULL_BEGIN






@interface BLEBottom : NSObject


/// 设备连接成功后要赋值
@property (nonatomic, strong) HXBleManager * manager;

+ (id)sharedInstance;

-(void)setHXBleManager:(HXBleManager * )manager;
-(void)setsendJQBoolA:(BOOL)boolC;


///更换新的动态密钥
-(void)UpdateBleKey:(NSString*)Keystr macAddress:(NSString*)macAddress;
/// 发送lock 指令
/// @param lockData 指令data
/// @param macAddress mac地址
-(void)SendLockData:(NSString*)lockData macAddress:(NSString*)macAddress;

/// 发送洗衣 指令
/// @param LaundryData 指令data
/// @param macAddress mac地址
-(void)SendLaundryData:(NSString*)LaundryData macAddress:(NSString*)macAddress;

/// 解密 Laundry操作结果
/// @param ValueData 解密的数据
-(NSData *)JYreturnLaundry:(NSData*)ValueData;



@end

NS_ASSUME_NONNULL_END
