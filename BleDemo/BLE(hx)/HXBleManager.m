//
//  HXBleManager.m
//  BleDemo
//
//  Created by mac on 2019/11/13.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HXBleManager.h"
#import "PakpoboxBLE.h"


#define ScanUUID @[[CBUUID UUIDWithString:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"]]
@interface HXBleManager()<CBCentralManagerDelegate, CBPeripheralDelegate>
/**
 手机设备
 */
@property (nonatomic, strong) CBCentralManager *centralManager;

/**
 外设设备
 */
@property (nonatomic, strong) CBPeripheral *peripheral;

/**
 特征值
 */
@property (nonatomic, strong) CBCharacteristic *characteristic;

/**
 服务
 */
@property (nonatomic, strong) CBService *service;

/**
 描述
 */
@property (nonatomic, strong) CBDescriptor *descriptor;

/**
已扫描到的设备的数组
 */
@property (nonatomic, strong) NSMutableArray * ListArray;//储存返回显示的数组
@property (nonatomic, strong) NSMutableArray * DUIBIList;//对比数组
/**
 蓝牙设备连接状态
 */
@property (nonatomic,assign) BOOL ConnectBoll; //连接状态

@property (nonatomic, strong) NSString * macDZ;///地址
@property (nonatomic, strong) NSString * macName;///名字



@property (nonatomic,assign) BOOL ScanBool; //连接状态
@end

@implementation HXBleManager
+ (id)sharedInstance {
  static HXBleManager *Manager = nil;
  @synchronized(self) {
    if (Manager == nil)
      Manager = [[self alloc] init];
  }
  return Manager;
}
-(instancetype)init
{
    self = [super init];
    if (self) {

        self.ConnectBoll = NO;
        self.ScanBool = YES;
    // 初始化设备
    self.centralManager =[[CBCentralManager alloc]initWithDelegate:self queue:nil];
        
//        [self.centralManager stopScan];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self cancelScan];
            
        });
    }
    return self;
}
-(NSMutableArray*)ListArray
{
    if(!_ListArray)
    {
        _ListArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _ListArray;
}
-(NSMutableArray*)DUIBIList
{
    if(!_DUIBIList)
    {
        _DUIBIList = [NSMutableArray arrayWithCapacity:0];
    }
    return _DUIBIList;
}

-(void)setAddressName:(NSString*)macDZ
{
    self.macDZ = macDZ;
}
-(void)setMacName:(NSString*)macName
{
    self.macName = macName;
}
//扫描Peripherals
- (void)scanPeripherals
{
    self.ConnectBoll = NO;
    [self.centralManager scanForPeripheralsWithServices:ScanUUID options:nil];
    if ([self.delegate respondsToSelector:@selector(ConnectionStatusRealTime:)]) {
        [self.delegate ConnectionStatusRealTime:self.ConnectBoll]; // 回调代理
    }
}
//扫描Peripherals
- (void)scanPeripherals:(BOOL)Scanbool
{
    self.ConnectBoll = NO;
    self.ScanBool = Scanbool;
    if(Scanbool==YES)
    {
        [self.centralManager scanForPeripheralsWithServices:ScanUUID options:nil];
    }else
    {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
    if ([self.delegate respondsToSelector:@selector(ConnectionStatusRealTime:)]) {
        [self.delegate ConnectionStatusRealTime:self.ConnectBoll]; // 回调代理
    }
    
}
//连接Peripherals
- (void)connectToPeripheral:(CBPeripheral *)peripheral
{
    [self.centralManager connectPeripheral:peripheral options:nil];
    self.peripheral = peripheral;
    
    NSNotification *notification =[NSNotification notificationWithName:@"bearerDidConnectHX" object: nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSLog(@"正在连接...");
}
//断开设备连接
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral
{
    [self cancelScan];
    [self.centralManager cancelPeripheralConnection:peripheral];
    self.ConnectBoll = NO;
    if ([self.delegate respondsToSelector:@selector(ConnectionStatusRealTime:)]) {
        [self.delegate ConnectionStatusRealTime:self.ConnectBoll]; // 回调代理
    }
}

-(void)closeConnected
{
    [self cancelScan];
    if(self.peripheral!=nil)
    {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
    }
    
//    [self cancelScan];
    self.macDZ = nil;
    self.ConnectBoll = NO;
    if ([self.delegate respondsToSelector:@selector(ConnectionStatusRealTime:)]) {
        [self.delegate ConnectionStatusRealTime:self.ConnectBoll]; // 回调代理
    }
}

//停止扫描
- (void)cancelScan
{
    [self.centralManager stopScan];
}
/// 清除设备 刷新扫描
- (void)CleanScanPeripherals
{
    [self.centralManager stopScan];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.DUIBIList removeAllObjects];
        [self.ListArray removeAllObjects];
        [self scanPeripherals:NO];
    });
}

//获取当前连接的peripherals
- (NSArray *)findConnectedPeripherals
{
    return self.ListArray;
}

//获取当前连接的peripheral
- (CBPeripheral *)findConnectedPeripheral:(NSString *)peripheralName
{
        for (CBPeripheral *p in self.ListArray) {
            if ([p.name isEqualToString:peripheralName]) {
                return p;
            }
        }
        return nil;
}
////sometimes ever：添加断开重连接的设备
//-  (void)sometimes_ever:(CBPeripheral *)peripheral {
//    if (![reConnectPeripherals containsObject:peripheral]) {
//        [reConnectPeripherals addObject:peripheral];
//    }
//}
////sometimes never：删除需要重连接的设备
//-  (void)sometimes_never:(CBPeripheral *)peripheral {
//    [reConnectPeripherals removeObject:peripheral];
//}
-(void)sendDataPeripherals:(NSData*)data
{
    if(self.ConnectBoll==YES)
    {
        [self.peripheral writeValue:data forDescriptor:self.descriptor];
    }
}


-(BOOL)returnConnect
{
    return self.ConnectBoll;
}

//MARK: 3.初始化设备会调用此方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    //第一次打开或者每次蓝牙状态改变都会调用这个函数

    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn: {
            NSLog(@"CBCentralManagerStatePoweredOn");
            NSLog(@"蓝牙设备开着");
            //TODO: 搜索外设
            // services:通过某些服务筛选外设 传nil=搜索附近所有设备
            [self.centralManager scanForPeripheralsWithServices:ScanUUID options:nil];
        }
            break;
        default:
            break;
    }
}

//MARK: 4.发现设备回调

/**
 发现设备后调用

 @param central 手机设备
 @param peripheral 外设
 @param advertisementData 外设携带数据
 @param RSSI 信号强度
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if(self.ScanBool == YES)
    {
    
//    kCBAdvDataManufacturerData
    //TODO: 使用mac地址判断
//    NSData *data  =[advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
//    NSData *data  =[advertisementData objectForKey:@"kCBAdvDataLeBluetoothDeviceAddress"];
    NSData *data  =[advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    
    NSString * uuid = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
    NSLog(@"\n Nsdata：%@",data);
    NSLog(@"uuid= %@",uuid);
    NSNotification *notification =[NSNotification notificationWithName:@"bearerNSLog" object:nil userInfo:advertisementData];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    NSString *mac =[[self convertToNSStringWithNSData:data] uppercaseString];// uppercaseString转大写字母
    if(data)
    {
//    NSString *mac =[[self MACNSStringWithNSData:data] uppercaseString];
      NSString *mac =[[self convertToNSStringWithNSData:data] uppercaseString];  
//    NSString * MAC = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"MAC == =%@     peripheral.name==%@",MAC,peripheral.name);
//    NSLog(@"identifier=======   %@     name ==== %@",peripheral.identifier,peripheral.name);
//    if([peripheral.name isEqualToString:@"Nordic_UART"])
         NSLog(@"MAC == =%@   self.macDZ = %@",mac,self.macDZ);
        if((self.macDZ!=nil) && (data!=nil))
        {
                NSLog(@"MAC == =%@   self.macDZ = %@",mac,self.macDZ);
            if([mac isEqualToString:self.macDZ])
            {
                [self connectToPeripheral:peripheral];
                
            }
        }
    }
    }else{

    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        if(peripheral.name!=nil)
        {

            if (![self.DUIBIList containsObject:peripheral]) {
                NSLog(@"\n设备名称：%@",peripheral.name);
                [self.DUIBIList addObject:peripheral];
                 [self.ListArray addObject:item];
//                 NSLog(@"mac DIZHI == %@",mac);
            }
        }
//    [self setBlockOnDiscoverToPeripherals];
    if (self.returnArrayList) {
        self.returnArrayList(self.ListArray);
    }
    }
     
    
}



//MARK: 5.1 外设连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"设备连接成功:%@", peripheral.name);
    
    self.ConnectBoll = YES;
    // 设置代理
    [self.peripheral setDelegate:self];
    //MARK: 6.1 外设发现服务,传nil代表不过滤
    [self.peripheral discoverServices:nil];
    // 停止扫描
    [self.centralManager stopScan];
//    NSNotification *notification =[NSNotification notificationWithName:@"AddConnectState" object:nil userInfo:@{@"data":@"110"}];
    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"bearerDidOpenHX" object: nil]];
        if ([self.delegate respondsToSelector:@selector(ConnectionStatusRealTime:)]) {
            [self.delegate ConnectionStatusRealTime:self.ConnectBoll]; // 回调代理
        }
}

//MARK: 5.2 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"设备连接失败:%@", peripheral.name);
    
    if(self.ConnectBoll==YES && self.peripheral!=nil)
    {
        // 重新从搜索外设开始
        [self.centralManager scanForPeripheralsWithServices:ScanUUID options:nil];
        // 连接外设
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    self.ConnectBoll = NO;
    NSNotification *notification =[NSNotification notificationWithName:@"bearerCloseHX" object: nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(ConnectionStatusRealTime:)]) {
        [self.delegate ConnectionStatusRealTime:self.ConnectBoll]; // 回调代理
    }
}

//MARK: 5.3 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"设备丢失连接:%@", peripheral.name);
    
    if(self.ConnectBoll==YES && self.peripheral!=nil)
    {
        // 重新从搜索外设开始
        [self.centralManager scanForPeripheralsWithServices:ScanUUID options:nil];
        // 连接外设
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    self.ConnectBoll = NO;
    NSNotification *notification =[NSNotification notificationWithName:@"bearerCloseHX" object: nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([self.delegate respondsToSelector:@selector(ConnectionStatusRealTime:)]) {
        [self.delegate ConnectionStatusRealTime:self.ConnectBoll]; // 回调代理
    }
}

//MARK: 6.2 发现外设服务回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    // 是否获取失败
    if (error) {
        NSLog(@"设备获取服务失败:%@", peripheral.name);
        return;
    }
    for (CBService *service in peripheral.services) {
        self.service = service;
//        NSLog(@"设备的服务(%@),UUID(%@),count(%lu)",service,service.UUID,(unsigned long)peripheral.services.count);
        //MARK: 7.1 外设发现特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//MARK: 7.2 从服务中发现外设特征的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    for (CBCharacteristic *cha in service.characteristics) {
//        NSLog(@"\n设备的服务(%@)\n服务对应的特征值(%@)\nUUID(%@)\ncount(%lu)",service,cha,cha.UUID,(unsigned long)service.characteristics.count);
        //MARK: 8.1 获取特征对应的描述 会回调didUpdateValueForDescriptor
        [peripheral discoverDescriptorsForCharacteristic:cha];
        //MAKR: 9.1获取特征的值 会回调didUpdateValueForCharacteristic
        [peripheral readValueForCharacteristic:cha];
        // 这里需要和硬件工程师协商好，数据写在哪个UUID里
        if([cha.UUID isEqual:[CBUUID UUIDWithString:Characteristics1]]){
            self.characteristic = cha;
        } else {
            // 打开外设的通知，否则无法接受数据
            // 这里也是根据项目，和硬件工程师协商好，是否需要打开通知，和打开哪个UUID的通知。
            [peripheral setNotifyValue:YES forCharacteristic:cha];
        }
        if ([self.delegate respondsToSelector:@selector(ConnectionSendJQ:)]) {
            [self.delegate ConnectionSendJQ:self.ConnectBoll]; // 回调代理
        }
    }
}

//MARK: 8.2 更新描述值回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    NSLog(@"描述(%@)",descriptor.description);
}

#pragma mark ------ 蓝牙数据返回 ------
//MARK: 9.2 更新特征值回调，可以理解为获取蓝牙发回的数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSString *value = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
//    NSLog(@"设备的特征值(%@),获取的数据(%@)",characteristic,value);
    if(self.peripheral == peripheral)
    {
        NSLog(@"获取到已连接设备发送的信息 = %@",characteristic.value);
        if ([self.delegate respondsToSelector:@selector(ReturnPeripheralDataDQ:Characteristic:)]) {
            [self.delegate ReturnPeripheralDataDQ:peripheral Characteristic:characteristic]; // 回调代理
        }
    }else
    {
        if ([self.delegate respondsToSelector:@selector(ReturnPeripheralData:Characteristic:)]) {
            [self.delegate ReturnPeripheralData:peripheral Characteristic:characteristic]; // 回调代理
        }
    }
//////    这里可以在这里获取描述
////    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE2"]]) {
////        NSData *data =characteristic.value;
////        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
////    }
//    if ([self.delegate respondsToSelector:@selector(ReturnPeripheralData:Characteristic:)]) {
//        [self.delegate ReturnPeripheralData:peripheral Characteristic:characteristic]; // 回调代理
//    }
//
////    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
////    [peripheral readValueForCharacteristic:characteristic];
}

-(void)JmValue:(NSData*)data
{
    
}

//MARK: 通知状态改变回调
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if(error){
        NSLog(@"改变通知状态");
    }
}

//MAKR: 发现外设的特征的描述数组
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    // 在此处读取描述即可
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        self.descriptor = descriptor;
//        NSLog(@"发现外设的特征descriptor(%@)",descriptor);
        [peripheral readValueForDescriptor:descriptor];
    }
}


//MARK: 发送数据
-(void)sendDataToBLE:(NSData *)data{
    if(nil != self.characteristic){
        // data: 数据data
        // characteristic: 发送给哪个特征
        // type:     CBCharacteristicWriteWithResponse,  CBCharacteristicWriteWithoutResponse,
        // 这里要跟硬件确认好，写入的特征是否有允许写入，允许用withResponse 不允许只能强行写入，用withoutResponse
        // 或者根据 10.2 回调的error查看一下是否允许写入，下面说
        // 我这里是不允许写入的，所以用了 WithoutResponse
        [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
    }
}

//MARK: 分段写入
- (void)writeData:(NSData *)data
{
    // 判断能写入字节的最大长度
    int maxValue;
    if (@available(iOS 9.0, *)) {
        // type:这里和上面一样，
        maxValue =(int)[self.peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse];
    } else {
        // 默认是20字节
        maxValue =20;
    }
    NSLog(@"%i",maxValue);
    for (int i = 0; i < [data length]; i += maxValue) {
        // 预加 最大包长度，如果依然小于总数据长度，可以取最大包数据大小
        if ((i + maxValue) < [data length]) {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, maxValue];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            [self sendDataToBLE:subData];
            // 根据接收模块的处理能力做相应延时
            usleep(10 * 1000);
        }
        else {
            NSString *rangeStr = [NSString stringWithFormat:@"%i,%i", i, (int)([data length] - i)];
            NSData *subData = [data subdataWithRange:NSRangeFromString(rangeStr)];
            [self sendDataToBLE:subData];
            usleep(10 * 1000);
        }
    }
}

//MARK: 10.2 发送数据成功回调
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"写入数据失败:(%@)\n error:%@",characteristic,error.userInfo);
        // 这里用withResponse如果报错："Writing is not permitted."说明设备不允许写入，这个时候要用 WithoutResponse
        // 使用 WithoutResponse的时候，不走这个代理。
        
        if ([self.delegate respondsToSelector:@selector(ReturnSendDataState:error:)]) {
            [self.delegate ReturnSendDataState:NO error:error]; // 回调代理
        }
        return;
    }
    NSLog(@"写入数据成功:%@",characteristic);
    if ([self.delegate respondsToSelector:@selector(ReturnSendDataState:error:)]) {
        [self.delegate ReturnSendDataState:YES error:error]; // 回调代理
    }
    [peripheral readValueForCharacteristic:characteristic];
}


#pragma mark - ==========================TOOL===========================

//MARK: mac地址解析处理
- (NSString *)convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=2; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    return strTemp;
}
//MARK: mac地址处理String 去掉最后两位
- (NSString *)MACNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=([data length]-2); i>=0 ; i--) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
//        NSLog(@"strTemp = %@",strTemp);
    }
    return strTemp;
}



-(NSData *)getData:(NSString *)str{
    NSString * d = str;
    if (d == nil || d.length == 0) d = @"00";
    
//    NSLog(@"数据 ： = %@",[NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]);
//    return decodeHex([NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]);
    return [self convertHexStrToData:[NSString stringWithFormat:@"%@%@", d, d.length % 2 == 0 ? @"" : @"0"]];
    
}
// 十六进制字符串转换成NSData
- (NSData *)convertHexStrToData:(NSString *)str {
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

@end
