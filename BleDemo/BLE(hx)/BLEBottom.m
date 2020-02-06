//
//  BLEBottom.m
//  BleDemo
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 mac. All rights reserved.
//

#import "BLEBottom.h"
#import "AES_SecurityUtil.h"
#import "BinHexOctUtil.h"

char keyPtr[16]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
@interface BLEBottom ()<HXBleManagerDelegate>
@property (nonatomic, assign) BOOL sendJQBool;
@end

@implementation BLEBottom


+ (id)sharedInstance
{
    static BLEBottom *Manager = nil;
    @synchronized(self) {
      if (Manager == nil)
        Manager = [[self alloc] init];
        [Manager AllocBleManager];
    }
    
    return Manager;
}

-(void)AllocBleManager
{
            
            NSLog(@"CSKeystr == %@",CSKeystr);
    //        if([CSKeystr isEqual:[NSNull null]])
            if(CSKeystr==nil)
            {
    //            [[NSUserDefaults standardUserDefaults] setObject:@"C1071263A90561A50918" forKey:@"CSKeystr"];
    //            [[NSUserDefaults standardUserDefaults] setObject:@"C1071263A90561A5A1C1" forKey:@"CSKeystr"];
                [[NSUserDefaults standardUserDefaults] setObject:@"00040020810A00001507" forKey:@"CSKeystr"];
                
            }
    self.manager = [HXBleManager sharedInstance];
    self.manager.delegate=self;
    [self.manager setAddressName:@"F07F579765DB"];
    
}
-(void)setHXBleManager:(HXBleManager * )manager
{
            
            NSLog(@"CSKeystr == %@",CSKeystr);
    //        if([CSKeystr isEqual:[NSNull null]])
            if(CSKeystr==nil)
            {
    //            [[NSUserDefaults standardUserDefaults] setObject:@"C1071263A90561A50918" forKey:@"CSKeystr"];
    //            [[NSUserDefaults standardUserDefaults] setObject:@"C1071263A90561A5A1C1" forKey:@"CSKeystr"];
                [[NSUserDefaults standardUserDefaults] setObject:@"00040020810A00001507" forKey:@"CSKeystr"];
                
            }
    self.manager=manager;
    self.manager.delegate=self;
    self.sendJQBool=NO;
}
-(void)setsendJQBoolA:(BOOL)boolC
{
    self.sendJQBool=boolC;
}
+(char*)ReturnAppkey
{
    return keyPtr;
}



/// 第一次请求鉴权
/// @param Keystr Keystr
/// @param macAddress macAddress
-(void)FirstAuthentication:(NSString*)Keystr macAddress:(NSString*)macAddress
{
//    C1071263A90561A50918
   
    
    NSData * Key16 =[self ReturnDataKey:macAddress keyStr:Keystr];///加密的key
//    NSLog(@"Key16 == %@",Key16);
    NSData * senddata = [self DataRandomNumber:2];
//    NSLog(@"senddata == %@",senddata);
    NSMutableData *JmData=[[NSMutableData alloc]init];//加密的data
    [JmData appendData:[self getData:@"01"]];
    [JmData appendData:[self getData:@"04"]];
    [JmData appendData:senddata];
    NSUInteger len = [JmData length];
       Byte *byteData = (Byte*)malloc(len);
       memcpy(byteData, [JmData bytes], len);
    Byte zonghe= 0x00;
       for (int i = 0; i < len; i++) {
//           NSLog(@"%c",byteData[i]);
           zonghe+=byteData[i];
       }
    Byte *testByte = &zonghe;
    NSData * Checksum = [[NSData alloc] initWithBytes:testByte length:1];
    [JmData appendData:Checksum];
    NSLog(@"JmData1 == %@",JmData);
    
    for (int K = 0; K<Key16.length; K++) {
        keyPtr[K]=((Byte*)[Key16 bytes])[K];
    }
//    NSLog(@"keyPtr == %s",keyPtr);
//    char * keyPtr = (char*)[Key16 bytes];
    NSData *dataAAA = [AES_SecurityUtil aes128EncryptWithContentData:JmData KeyStr:keyPtr gIvStr:keyPtr];
    [self.manager sendDataToBLE:dataAAA];
}

-(NSData *)ReturnDataKey:(NSString*)macAddress keyStr:(NSString*)keyStr
{
    NSData * data = [self getData:keyStr];
    NSData * dataMac = [self getData:macAddress];
    NSMutableData *mutableData=[[NSMutableData alloc]init];;
    [mutableData appendData:data];
    [mutableData appendData:dataMac];
//    NSLog(@"mutableData == %@",mutableData);
    return mutableData;
}

/// 返回16进制随机数
/// @param N 决定返回的数量
-(NSData *)DataRandomNumber:(NSInteger)N
{
//    NSData * data = [[NSData alloc] init];
    NSMutableData *mutabData=[[NSMutableData alloc]init];
    [mutabData appendData:[self getData:@"A0"]];
    for (int i= 0; i<N; i++) {
        int x = arc4random() % 100;
        NSString * str=[self stringWithHexNumber:x];
        [mutabData appendData:[self getData:str]];
    }
    [mutabData appendData:[self getData:@"01"]];
    return mutabData;
}
- (NSString *)stringWithHexNumber:(NSUInteger)hexNumber{
    
    char hexChar[6];
    sprintf(hexChar, "%x", (int)hexNumber);
    
    NSString *hexString = [NSString stringWithCString:hexChar encoding:NSUTF8StringEncoding];
    
    return hexString;
}

-(NSData *)JYreturnData:(NSData*)ValueData
{
    //获取数据
    Byte XB = ((Byte*)([ValueData bytes]))[1];
        int CCX = (int)XB;
    NSData*sdReturn =[ValueData subdataWithRange:NSMakeRange(0,CCX+3)];//提取出所有用到数据
    NSLog(@"sd === %@",sdReturn);
    NSUInteger len = [sdReturn length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [sdReturn bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < (len-1); i++) {
        zonghe+=byteData[i];
    }
    Byte ZA = ((Byte*)([sdReturn bytes]))[8];
    
    if(ZA==zonghe)
    {
//        NSLog(@"校验成功");
        NSData* YQMData =[sdReturn subdataWithRange:NSMakeRange(2,CCX)];//提取出邀请码
        return YQMData;
    }else
    {
//        NSLog(@"校验成功");
        return nil;
    }
}


-(void)SecondStepVerification:(NSString*)Keystr macAddress:(NSString*)macAddress
{
    NSData * Key16 =[self ReturnDataKey:macAddress keyStr:Keystr];///加密的key
    NSLog(@"Key16 == %@",Key16);
    NSMutableData *JmData=[[NSMutableData alloc]init];//加密的data
    NSData * senddata = [self DataRandomNumber:4];
    [JmData appendData:[self getData:@"02"]];
    [JmData appendData:[self getData:@"06"]];
    [JmData appendData:senddata];
    NSUInteger len = [JmData length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [JmData bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < len; i++) {
    //           NSLog(@"%c",byteData[i]);
        zonghe+=byteData[i];
    }
        Byte *testByte = &zonghe;
        NSData * Checksum = [[NSData alloc] initWithBytes:testByte length:1];
        [JmData appendData:Checksum];
        NSLog(@"JmData2 == %@",JmData);
    for (int K = 0; K<Key16.length; K++) {
            keyPtr[K]=((Byte*)[Key16 bytes])[K];
        }
    //    NSLog(@"keyPtr == %s",keyPtr);
    //    char * keyPtr = (char*)[Key16 bytes];
    NSLog(@"keyPtr == %s",keyPtr);
        NSData *dataAAA = [AES_SecurityUtil aes128EncryptWithContentData:JmData KeyStr:keyPtr gIvStr:keyPtr];
        [self.manager sendDataToBLE:dataAAA];
    ///更换key
//    NSString * KeystrGH = @"C1071263A90561A50918";
    [self genghuanToken:CSKeystr Token6:[BinHexOctUtil convertDataToHexStr:senddata]];
}
-(void)genghuanToken:(NSString*)Keystr Token6:(NSString*)Token6
{
    NSData * Key16 =[self ReturnDataKey:Token6 keyStr:Keystr];///加密的key
    for (int K = 0; K<Key16.length; K++) {
        keyPtr[K]=((Byte*)[Key16 bytes])[K];
    }
}

-(void)TheThirdStepVerification:(NSString*)Keystr macAddress:(NSString*)macAddress YZMdata:(NSString*)YZMdata
{
    NSData * Key16 =[self ReturnDataKey:YZMdata keyStr:Keystr];///加密的key
    NSLog(@"Key16 == %@",Key16);
    NSMutableData *JmData=[[NSMutableData alloc]init];//加密的data
    NSData * senddata = [self getData:macAddress];
    [JmData appendData:[self getData:@"03"]];
    [JmData appendData:[self getData:@"06"]];
    [JmData appendData:senddata];
    NSUInteger len = [JmData length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [JmData bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < len; i++) {
    //           NSLog(@"%c",byteData[i]);
        zonghe+=byteData[i];
    }
        Byte *testByte = &zonghe;
        NSData * Checksum = [[NSData alloc] initWithBytes:testByte length:1];
        [JmData appendData:Checksum];
        NSLog(@"JmData3 == %@",JmData);
    for (int K = 0; K<Key16.length; K++) {
            keyPtr[K]=((Byte*)[Key16 bytes])[K];
        }
    //    NSLog(@"keyPtr == %s",keyPtr);
    //    char * keyPtr = (char*)[Key16 bytes];
        NSData *dataAAA = [AES_SecurityUtil aes128EncryptWithContentData:JmData KeyStr:keyPtr gIvStr:keyPtr];
        [self.manager sendDataToBLE:dataAAA];
    ///更换key
    NSString * macAddress3 = @"F07F579765DB";
//    NSString * Keystr3 = @"C1071263A90561A50918";
    [self genghuanToken:CSKeystr Token6:macAddress3];
}

/// 第三步校验完成得到 序列号
/// @param ValueData 解密的数据
-(NSData *)JYreturnSeq:(NSData*)ValueData
{
    //获取数据
    Byte XB = ((Byte*)([ValueData bytes]))[1];
        int CCX = (int)XB;
    NSData*sdReturn =[ValueData subdataWithRange:NSMakeRange(0,CCX+3)];//提取出所有用到数据
    NSLog(@"序列号 3 === %@",sdReturn);
    NSUInteger len = [sdReturn length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [sdReturn bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < (len-1); i++) {
        zonghe+=byteData[i];
    }
    Byte ZA = ((Byte*)([sdReturn bytes]))[4];
    
    if(ZA==zonghe)
    {
//        NSLog(@"校验成功");
        NSData* YQMData =[sdReturn subdataWithRange:NSMakeRange(2,CCX)];//提取出序列号
        return YQMData;
    }else
    {
//        NSLog(@"校验成功");
        return nil;
    }
}


///更换新的动态密钥
-(void)UpdateBleKey:(NSString*)Keystr macAddress:(NSString*)macAddress
{
    [self SeqIncreasing];
//    NSData * Key16 =[self ReturnDataKey:YZMdata keyStr:Keystr];///加密的key
//    NSLog(@"Key16 == %@",Key16);
    NSMutableData *JmData=[[NSMutableData alloc]init];//加密的data
    
    [JmData appendData:[self getData:@"11"]];
    [JmData appendData:[self getData:@"0c"]];
    //    2位序列号 +新动态密钥前10位
    int SA = [SeqStr intValue];
    NSData *dataSA = [BLEBottom int2Nsdata:SA];;
    [JmData appendData:dataSA];///序列号
    NSData * Newdata = [self.manager getData:Keystr];///新的key
    [JmData appendData:Newdata];
    NSUInteger len = [JmData length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [JmData bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < len; i++) {
    //           NSLog(@"%c",byteData[i]);
        zonghe+=byteData[i];
    }
        Byte *testByte = &zonghe;
        NSData * Checksum = [[NSData alloc] initWithBytes:testByte length:1];
        [JmData appendData:Checksum];
    NSData *dataAAA = [AES_SecurityUtil aes128EncryptWithContentData:JmData KeyStr:keyPtr gIvStr:keyPtr];
    [self.manager sendDataToBLE:dataAAA];
    
}
/// 序列号递增
-(void)SeqIncreasing
{
    // int 转 NSData
    int SA = [SeqStr intValue];
    SA++;
    NSString * iStr = [NSString stringWithFormat:@"%d",SA];
    [[NSUserDefaults standardUserDefaults] setObject:iStr forKey:@"SeqStr"];
    
}
/// 解密更换key返回的新的key
/// @param ValueData 解密的数据
-(NSData *)JYreturnNewKey:(NSData*)ValueData
{
    //获取数据
    Byte XB = ((Byte*)([ValueData bytes]))[1];
        int CCX = (int)XB;
    NSData*sdReturn =[ValueData subdataWithRange:NSMakeRange(0,CCX+3)];//提取出所有用到数据
    NSLog(@"返回新的秘钥  === %@",sdReturn);
    NSUInteger len = [sdReturn length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [sdReturn bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < (len-1); i++) {
        zonghe+=byteData[i];
    }
    Byte ZA = ((Byte*)([sdReturn bytes]))[(len-1)];
    
    if(ZA==zonghe)
    {
//        NSLog(@"校验成功");
        NSData* YQMData =[sdReturn subdataWithRange:NSMakeRange(2,CCX)];//提取出序列号
        return YQMData;
    }else
    {
//        NSLog(@"校验成功");
        return nil;
    }
}
/// 处理int类型转nsdata 类型多两个空字节
/// @param i int
+(NSData *)int2Nsdata:(int) i{
//    int j = ntohl(i); //高低位转换    不然1 的结果是 1 0 0 0
    NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
    NSData *RE =[data subdataWithRange:NSMakeRange(0, 2)];//截取一部分数据
    return RE;
    
}





/// 发送lock 指令
/// @param lockData 指令data
/// @param macAddress mac地址
-(void)SendLockData:(NSString*)lockData macAddress:(NSString*)macAddress
{
    [self SeqIncreasing];
//    NSData * Key16 =[self ReturnDataKey:YZMdata keyStr:Keystr];///加密的key
//    NSLog(@"Key16 == %@",Key16);
    NSMutableData *JmData=[[NSMutableData alloc]init];//加密的data
    [JmData appendData:[self getData:@"81"]];
    [JmData appendData:[self getData:@"07"]];
    //    2位序列号 +新动态密钥前10位
    int SA = [SeqStr intValue];
    NSData *dataSA = [BLEBottom int2Nsdata:SA];;
    [JmData appendData:dataSA];///序列号
    NSData * Newdata = [self getData:lockData];///Lock发送的数据
    [JmData appendData:Newdata];
    NSUInteger len = [JmData length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [JmData bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < len; i++) {
    //           NSLog(@"%c",byteData[i]);
        zonghe+=byteData[i];
    }
        Byte *testByte = &zonghe;
        NSData * Checksum = [[NSData alloc] initWithBytes:testByte length:1];
        [JmData appendData:Checksum];
    NSData *dataAAA = [AES_SecurityUtil aes128EncryptWithContentData:JmData KeyStr:keyPtr gIvStr:keyPtr];
    [self.manager sendDataToBLE:dataAAA];
    
}

/// 解密BLE回复锁控操作结果
/// @param ValueData 解密的数据
-(NSData *)JYreturnLock:(NSData*)ValueData
{
    //获取数据
    Byte XB = ((Byte*)([ValueData bytes]))[1];
        int CCX = (int)XB;
    NSData*sdReturn =[ValueData subdataWithRange:NSMakeRange(0,CCX+3)];//提取出所有用到数据
    NSLog(@"BLE回复锁控操作结果  === %@",sdReturn);
    NSUInteger len = [sdReturn length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [sdReturn bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < (len-1); i++) {
        zonghe+=byteData[i];
    }
    Byte ZA = ((Byte*)([sdReturn bytes]))[(len-1)];
    
    if(ZA==zonghe)
    {
//        NSLog(@"校验成功");
        NSData* YQMData =[sdReturn subdataWithRange:NSMakeRange(2,CCX)];//提取出序列号
        return YQMData;
    }else
    {
//        NSLog(@"校验成功");
        return nil;
    }
}


/// 发送洗衣 指令
/// @param LaundryData 指令data
/// @param macAddress mac地址
-(void)SendLaundryData:(NSString*)LaundryData macAddress:(NSString*)macAddress
{
    [self SeqIncreasing];
//    NSData * Key16 =[self ReturnDataKey:YZMdata keyStr:Keystr];///加密的key
//    NSLog(@"Key16 == %@",Key16);
    NSMutableData *JmData=[[NSMutableData alloc]init];//加密的data
    [JmData appendData:[self getData:@"82"]];
    [JmData appendData:[self getData:@"0c"]];
    //    2位序列号 +新动态密钥前10位
    int SA = [SeqStr intValue];
    NSData *dataSA = [BLEBottom int2Nsdata:SA];;
    [JmData appendData:dataSA];///序列号
    NSData * Newdata = [self getData:LaundryData];///Lock发送的数据
    [JmData appendData:Newdata];
    NSUInteger len = [JmData length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [JmData bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < len; i++) {
    //           NSLog(@"%c",byteData[i]);
        zonghe+=byteData[i];
    }
        Byte *testByte = &zonghe;
        NSData * Checksum = [[NSData alloc] initWithBytes:testByte length:1];
        [JmData appendData:Checksum];
    NSData *dataAAA = [AES_SecurityUtil aes128EncryptWithContentData:JmData KeyStr:keyPtr gIvStr:keyPtr];
    [self.manager sendDataToBLE:dataAAA];
    
}

/// 解密 Laundry操作结果
/// @param ValueData 解密的数据
-(NSData *)JYreturnLaundry:(NSData*)ValueData
{
    //获取数据
    Byte XB = ((Byte*)([ValueData bytes]))[1];
        int CCX = (int)XB;
    NSData*sdReturn =[ValueData subdataWithRange:NSMakeRange(0,CCX+3)];//提取出所有用到数据
    NSLog(@"Laundry操作结果  === %@",sdReturn);
    NSUInteger len = [sdReturn length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [sdReturn bytes], len);
    Byte zonghe= 0x00;
    for (int i = 0; i < (len-1); i++) {
        zonghe+=byteData[i];
    }
    Byte ZA = ((Byte*)([sdReturn bytes]))[(len-1)];
    
    if(ZA==zonghe)
    {
//        NSLog(@"校验成功");
        NSData* YQMData =[sdReturn subdataWithRange:NSMakeRange(2,CCX)];//提取出序列号
        return YQMData;
    }else
    {
//        NSLog(@"校验成功");
        return nil;
    }
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

#pragma mark --------  HXBleManagerDelegate  -------
-(void)ConnectionStatusRealTime:(BOOL)connectionBool
{
    if(connectionBool==YES)
    {
        NSLog(@"BLE连接成功");
//        NSString * macAddress = @"F07F579765DB";
//        NSLog(@"CSKeystr ====   %@",CSKeystr);
//            self.sendJQBool=YES;
//           [self FirstAuthentication:CSKeystr macAddress:macAddress];
    }
}


-(void)ConnectionSendJQ:(BOOL)connectionBool
{
    static int i=0;
    if(connectionBool==YES)
    {
        if(i<1){
        NSLog(@"收到服务开始鉴权");
        NSString * macAddress = @"F07F579765DB";
        NSLog(@"CSKeystr ====   %@",CSKeystr);
            self.sendJQBool=YES;
           [self FirstAuthentication:CSKeystr macAddress:macAddress];
            i++;
        }
    }
}

-(void)ReturnPeripheralDataDQ:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)Device
{
    NSLog(@"收到的信息 = %@",Device.value);
//    NSLog(@"ReturnAppkey == %s",[BLEBottom ReturnAppkey]);
        NSData * ValueData = [AES_SecurityUtil aes128DencryptWithContentData:Device.value KeyStr:keyPtr gIvStr:keyPtr];
        NSLog(@"解密 == %@",ValueData);
        //初始化
        if(self.sendJQBool==YES)
        {
            if(ValueData.length>0){
//            if(ValueData!=nil){
            Byte XB = ((Byte*)([ValueData bytes]))[0];
    //        int CCX = (int)XB;
            if(XB== 0x01)
            {
                NSData* YQMData =[self JYreturnData:ValueData];
                if(YQMData!=nil)
                {
                    NSLog(@"YQMData1= %@",YQMData);
                    ///第一步校验成功进行第二步校验
    //                NSString * Keystr = @"C1071263A90561A50918";
                    NSLog(@"string ===  %@",[BinHexOctUtil convertDataToHexStr:YQMData]);
                    [self SecondStepVerification:CSKeystr macAddress:[BinHexOctUtil convertDataToHexStr:YQMData]];
                }else
                {
                    NSLog(@"校验失败1");
                    self.sendJQBool=NO;
                }
            }else if(XB==0x02)
            {
                NSData* YQMData =[self JYreturnData:ValueData];
                if(YQMData!=nil)
                {
                    NSLog(@"YQMData2= %@",YQMData);
                    ///第二步校验成功进行第三步校验
                    NSString * macAddress = @"F07F579765DB";
    //                NSString * Keystr = @"C1071263A90561A50918";
                    [self TheThirdStepVerification:CSKeystr macAddress:macAddress YZMdata:[BinHexOctUtil convertDataToHexStr:YQMData]];
                }else
                {
                    NSLog(@"校验失败2");
                    self.sendJQBool=NO;
                }
            }else if(XB==0x03)
            {
                ///得到序列号
                NSData* YQMData =[self JYreturnSeq:ValueData];
                if(YQMData!=nil)
                {
                    NSLog(@"校验成功3，连接完成");
                    NSLog(@"YQMData3= %@",YQMData);
    //                int i =  *(int *)([YQMData bytes]);
                    // NSData转int
                    int b = 0;
                    [YQMData getBytes:&b length:sizeof(2)];
                    NSString * iStr = [NSString stringWithFormat:@"%d",b];
                    [[NSUserDefaults standardUserDefaults] setObject:iStr forKey:@"SeqStr"];
                    // int 转 NSData
                    int SA = [SeqStr intValue];
                    NSData *dataSA = [BLEBottom int2Nsdata:SA];
                    NSLog(@"转换完成 = %@",dataSA);
                    self.sendJQBool=NO;
                }else
                {
                    NSLog(@"校验失败3");
                    self.sendJQBool=NO;
                }
            }else if(XB==0x11) // 0x11 等于十进制 17
            {
    //            得到新的秘钥
                NSData* NewKey =[self JYreturnNewKey:ValueData];
                if(NewKey!=nil)
                {
                ///把新的秘钥替换储存
                    [[NSUserDefaults standardUserDefaults] setObject:[BinHexOctUtil convertDataToHexStr:NewKey] forKey:@"CSKeystr"];
                    self.sendJQBool=NO;
                }else
                {
                    NSLog(@"得到新的秘钥失败");
                    self.sendJQBool=NO;
                }
            }else if(XB==0x81)
            {
                        //解密开锁指令
                           NSData* LockInfo =[self JYreturnLock:ValueData];
                           if(LockInfo!=nil)
                           {
                               NSLog(@"LockInfo == %@",LockInfo);
                               self.sendJQBool=NO;
                           }else
                           {
                               NSLog(@"得到新的秘钥失败");
                               self.sendJQBool=NO;
                           }
            
            }else if(XB==0x82)
            {
                //解密洗衣指令
                NSData* LaundryInfo =[self JYreturnLaundry:ValueData];
                if(LaundryInfo!=nil)
                {
                    NSLog(@"LaundryInfo == %@",LaundryInfo);
                    self.sendJQBool=NO;
                }else
                {
                    NSLog(@"得到新的秘钥失败");
                    self.sendJQBool=NO;
                }
            }
            }else
            {
                NSString * strvalue = [BinHexOctUtil convertDataToHexStr:Device.value];
                if([strvalue isEqualToString:@"aa55aa55"])
                {
                    NSLog(@"设备返回错误码");
                }
            }
        }
}








// .h 的方法先屏蔽放到这里
/*
 
 /// 返回本地的加密key
 +(char*)ReturnAppkey;
 
 
/// 第一次请求鉴权
/// @param Keystr Keystr
/// @param macAddress macAddress
-(void)FirstAuthentication:(NSString*)Keystr macAddress:(NSString*)macAddress;

-(NSData *)ReturnDataKey:(NSString*)macAddress keyStr:(NSString*)keyStr;

/// 返回16进制随机数
/// @param N 决定返回的数量
-(NSData *)DataRandomNumber:(NSInteger)N;
- (NSString *)stringWithHexNumber:(NSUInteger)hexNumber;

-(NSData *)JYreturnData:(NSData*)ValueData;


/// 第二次鉴权
/// @param Keystr Keystr
/// @param macAddress macAddress
-(void)SecondStepVerification:(NSString*)Keystr macAddress:(NSString*)macAddress;
-(void)genghuanToken:(NSString*)Keystr Token6:(NSString*)Token6;

/// 第三次鉴权
/// @param Keystr Keystr
/// @param macAddress macAddress
/// @param YZMdata YZMdata
-(void)TheThirdStepVerification:(NSString*)Keystr macAddress:(NSString*)macAddress YZMdata:(NSString*)YZMdata;

/// 第三步校验完成得到 序列号
/// @param ValueData 解密的数据
-(NSData *)JYreturnSeq:(NSData*)ValueData;


///更换新的动态密钥
-(void)UpdateBleKey:(NSString*)Keystr macAddress:(NSString*)macAddress;
/// 序列号递增
-(void)SeqIncreasing;
/// 解密更换key返回的新的key
/// @param ValueData 解密的数据
-(NSData *)JYreturnNewKey:(NSData*)ValueData;
/// 处理int类型转nsdata 类型多两个空字节
/// @param i int
+(NSData *)int2Nsdata:(int) i;





/// 发送lock 指令
/// @param lockData 指令data
/// @param macAddress mac地址
-(void)SendLockData:(NSString*)lockData macAddress:(NSString*)macAddress;

/// 解密BLE回复锁控操作结果
/// @param ValueData 解密的数据
-(NSData *)JYreturnLock:(NSData*)ValueData;


/// 发送洗衣 指令
/// @param LaundryData 指令data
/// @param macAddress mac地址
-(void)SendLaundryData:(NSString*)LaundryData macAddress:(NSString*)macAddress;

/// 解密 Laundry操作结果
/// @param ValueData 解密的数据
-(NSData *)JYreturnLaundry:(NSData*)ValueData;



/// 16进制字符串转为 nsdata
/// @param str string
-(NSData *)getData:(NSString *)str;
*/

@end
