//
//  HXBleManager.h
//  BleDemo
//
//  Created by mac on 2019/11/13.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define Service_UUID @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define Characteristics1 @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define Characteristics2 @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
NS_ASSUME_NONNULL_BEGIN
@protocol HXBleManagerDelegate <NSObject>
@optional



///MARK:  实时返回连接状态
/// @param connectionBool connectionBool
-(void)ConnectionStatusRealTime:(BOOL)connectionBool;


///MARK:  返回连接设备发送的数据
/// @param peripheral 连接的设备
/// @param Device 设备携带的数据
-(void)ReturnPeripheralData:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)Device;


/// MARK:  返回发送数据成功是否
/// @param State 状态 
/// @param error 错误信息
-(void)ReturnSendDataState:(BOOL)State error:(NSError *)error;



@end





@interface HXBleManager : NSObject


+ (id)sharedInstance;
-(void)setAddressName:(NSString*)macDZ;
-(void)setMacName:(NSString*)macName;
//扫描Peripherals
- (void)scanPeripherals;
//扫描Peripherals  传入是否返回列表
- (void)scanPeripherals:(BOOL)Scanbool;
//连接Peripherals
- (void)connectToPeripheral:(CBPeripheral *)peripheral;
//断开设备连接
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;
//停止扫描
- (void)cancelScan;
//断开连接
-(void)closeConnected;
//获取当前连接的peripherals
- (NSArray *)findConnectedPeripherals;

//获取当前连接的peripheral
- (CBPeripheral *)findConnectedPeripheral:(NSString *)peripheralName;
//返回连接状态
-(BOOL)returnConnect;
////发送数据
-(void)sendDataToBLE:(NSData *)data;
/**
 sometimes ever，sometimes never.  相聚有时，后会无期
 
 this is center with peripheral's story
 **/
/*
//sometimes ever：添加断开重连接的设备
-  (void)sometimes_ever:(CBPeripheral *)peripheral ;
//sometimes never：删除需要重连接的设备
-  (void)sometimes_never:(CBPeripheral *)peripheral ;
*/
/**
 找到Peripherals的block |  when find peripheral
 */
- (void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block;
@property (nonatomic, copy) void (^returnArrayList)(NSMutableArray *MuArray);
@end

NS_ASSUME_NONNULL_END
