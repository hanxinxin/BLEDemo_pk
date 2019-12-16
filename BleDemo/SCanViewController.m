//
//  SCanViewController.m
//  BleDemo
//
//  Created by mac on 2019/11/13.
//  Copyright © 2019 mac. All rights reserved.
//

#import "SCanViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "HXBleManager.h"
#import "PublicLibrary.h"
#import "AES_SecurityUtil.h"
#import "searchingHeaderView.h"
#import "UITableView+SCIndexView.h"

@implementation countriesClass

@end


@interface SCanViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
已扫描到的设备的数组
 */
@property (nonatomic, strong) NSMutableArray * ListArray;
@property (nonatomic, strong) NSMutableArray * DUIBIList;

@property (nonatomic, strong) HXBleManager * manager;
@property (nonatomic, strong) NSMutableArray *countryArrayList;///国家的name
@property (nonatomic, strong) NSArray * arrZM;

@property (nonatomic, assign) BOOL translucent;
@end

@implementation SCanViewController
@synthesize manager,arrZM;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ListArray = [NSMutableArray arrayWithCapacity:0];
    self.DUIBIList = [NSMutableArray arrayWithCapacity:0];
    self.countryArrayList = [NSMutableArray arrayWithCapacity:0];
     self.translucent = YES;
    self.ListBleTableView.delegate=self;
    self.ListBleTableView.dataSource=self;
    self.ListBleTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    arrZM =[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"k",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    [self.ListBleTableView registerClass:searchingHeaderView.class forHeaderFooterViewReuseIdentifier:@"searchingHeaderView"];
    [self getArray_list];
    self.ListBleTableView.sc_indexViewDataSource = arrZM.copy;
//    self.ListBleTableView.sc_indexView
    self.manager = [HXBleManager sharedInstance];
    [self.manager setReturnArrayList:^(NSMutableArray * _Nonnull MuArray) {
        self->_ListArray = MuArray;
        [self->_ListBleTableView reloadData];
    }];
}
-(void)getArray_list
{
    
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    
    for (int c = 0; c<arrZM.count; c++) {
        
        NSMutableArray * MA= [NSMutableArray arrayWithCapacity:0];
        NSString * str = arrZM[c];
        for (NSString *countryCode in countryArray) {
            NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            
            NSString *str2 = [displayNameString substringWithRange:NSMakeRange(0,1)];//str2 = "is"
            if([str isEqualToString:str2])
            {
                
                countriesClass * mode = [[countriesClass alloc] init];
                mode.Gname = displayNameString;
                mode.GImage = displayNameString;
    //            NSArray * arr = [NSArray arrayWithObject:mode];
                [MA addObject:mode];
                   
            }
            
        }
         [self.countryArrayList addObject:MA];
    }
    countriesClass * mode = [[countriesClass alloc] init];
    mode.Gname = @"Singapore";
    mode.GImage =  @"Singapore";
    NSArray * arr = [NSArray arrayWithObject:mode];
    [self.countryArrayList insertObject:arr atIndex:0];
//    NSLog(@"打印数组==== %@",self.countryArrayList);
}
#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ListArray.count;
//    NSArray * arrItmes = self.countryArrayList[section];
//    return arrItmes.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.countryArrayList.count;
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.frame.size.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    CBPeripheral * peripheralList = self.ListArray[indexPath.section];
    NSDictionary *item = [self.ListArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
    NSNumber *RSSI = [item objectForKey:@"RSSI"];
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
//    cell.textLabel.text = peripheralList.name;
    cell.textLabel.text = peripheralName;
    //信号和服务
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    NSData *data  =[advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
       NSString *mac =[[self convertToNSStringWithNSData:data] uppercaseString];//
    cell.detailTextLabel.text = mac;
    cell.textLabel.textColor = [UIColor blueColor];
    return cell;
//     */
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    NSLog(@"section = %ld , row = %ld",indexPath.section,indexPath.row);
    if(indexPath.section==0)
    {
        NSArray * arr = self.countryArrayList[indexPath.section];;
        countriesClass *mode = arr[indexPath.row];
           cell.textLabel.text = mode.Gname;
//        cell.imageView.image = [UIImage imageNamed:mode.GImage];
    }else{
    NSArray * arr = self.countryArrayList[indexPath.section];;
    countriesClass *mode = arr[indexPath.row];
       cell.textLabel.text = mode.Gname;
//    cell.imageView.image = [UIImage imageNamed:mode.GImage];
    }
       return cell;
     */
}
//MARK: mac地址解析处理
- (NSString *)convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=0; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    return strTemp;
     
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)
    {
        return 0;
    }
    return searchingHeaderView.headerViewHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;//最小数，相当于0
    }
    else if(section == 1){
        return CGFLOAT_MIN;//最小数，相当于0
    }
    return 0;//机器不可识别，然后自动返回默认高度
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    //自定义间隔view，可以不写默认用系统的
//    UIView * view_c= [[UIView alloc] init];
//    view_c.frame=CGRectMake(0, 0, 0, 0);
//    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
//    return view_c;
    if(section==0)
    {
        searchingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"searchingHeaderView"];
        [headerView configWithTitle:@"Singapore"];
        return headerView;
    }
    searchingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"searchingHeaderView"];
    [headerView configWithTitle:arrZM[section-1]];
    return headerView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self reloadColorForHeaderView];
}

- (void)reloadColorForHeaderView {
    NSArray<NSIndexPath *> *indexPaths = self.ListBleTableView.indexPathsForVisibleRows;
    for (NSIndexPath *indexPath in indexPaths) {
        searchingHeaderView *headerView = (searchingHeaderView *)[self.ListBleTableView headerViewForSection:indexPath.section];
        [self configColorWithHeaderView:headerView];
    }
}
- (void)configColorWithHeaderView:(searchingHeaderView *)headerView {
    if (!headerView) {
        return;
    }
    
    CGFloat InsetTop = self.translucent ? UIApplication.sharedApplication.statusBarFrame.size.height + 44 : 0;
    double diff = fabs(headerView.frame.origin.y - self.ListBleTableView.contentOffset.y - InsetTop);
    CGFloat headerHeight = searchingHeaderView.headerViewHeight;
    double progress;
    if (diff >= headerHeight) {
        progress = 1;
    }
    else {
        progress = diff / headerHeight;
    }
    [headerView configWithProgress:progress];
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *item = [self.ListArray objectAtIndex:indexPath.row];
//        CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
//        NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
//        NSNumber *RSSI = [item objectForKey:@"RSSI"];
//        NSString *peripheralName;
//        if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
//            peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
//        }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
//            peripheralName = peripheral.name;
//        }else{
//            peripheralName = [peripheral.identifier UUIDString];
//        }
//    NSLog(@"peripheralName= %@   RSSI =%@ ",peripheralName,RSSI) ;
////    Nordic_UART
//    self.peripheral = peripheral;
//    // 连接外设
//    [self.centralManager connectPeripheral:peripheral options:nil];
    
    
    
    
    
    
    
    
    
    
    
//    NSDictionary *item = [self.ListArray objectAtIndex:indexPath.row];
//    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
//    [manager connectToPeripheral:peripheral];
//
//    NSString * ncryptStr  = [NSString stringWithFormat:@"a00016001500010400d0"];
//    NSString * ncryptStr2  = [NSString stringWithFormat:@"a00016001100010c00d4"];
////    Byte byte[16]={0xc0,0x07,0x12,0x63,0xa9,0x05,0x61,0x16,0x09,0x18,0x0a,0x51,0x4c,0xd7,0x49,0x00};
////        NSData *temphead = [[NSData alloc]initWithBytes:byte length:16];
////    NSString * key =  [self hexStringFromString:temphead];;
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
////     NSData * JMW = [jiamiStr AES128Encrypt:ncryptStr key:key];
////        NSString * JMW = [jiamiStr encryptUseDES:ncryptStr key:key];
//        char keyPtr[16+1]={0xc0,0x07,0x12,0x63,0xa9,0x05,0x61,0x16,0x09,0x18,0x0a,0x51,0x4c,0xd7,0x49,0x00};
////        NSLog(@"秘钥 ：%s",keyPtr);
//        NSString *str1 = [AES_SecurityUtil aes128EncryptWithContent:ncryptStr KeyStr:keyPtr gIvStr:keyPtr];
//        NSLog(@"加密前：%@",ncryptStr);
//        NSLog(@"加密后：%@",str1);
//
//        NSString *str2 = [AES_SecurityUtil aes128DencryptWithContent:str1 KeyStr:keyPtr gIvStr:keyPtr];
//        NSLog(@"解密后：%@",str2);
////     NSLog(@"JMW==== %@",JMW);
//        [self->manager sendDataToBLE:[self getData:str1]];
//    });
//
//    dispatch_time_t delayTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0/*延迟执行时间*/ * NSEC_PER_SEC));
//
//                dispatch_after(delayTime2, dispatch_get_main_queue(), ^{
////                 NSData * JMW2 = [jiamiStr AES128Encrypt:ncryptStr2 key:key];
////                    NSLog(@"data2222=====  %@",JMW2);
////                    [self->manager sendDataToBLE:JMW2];
//                    char keyPtr[16+1]={0xc0,0x07,0x12,0x63,0xa9,0x05,0x61,0x16,0x09,0x18,0x0a,0x51,0x4c,0xd7,0x49,0x00};
////                            NSLog(@"秘钥2 ：%s",keyPtr);
//                            NSString *str1 = [AES_SecurityUtil aes128EncryptWithContent:ncryptStr2 KeyStr:keyPtr gIvStr:keyPtr];
//                            NSLog(@"加密前2：%@",ncryptStr2);
//                            NSLog(@"加密后2：%@",str1);
//
//                    //        NSString *str2 = [AES_SecurityUtil aes128DencryptWithContent:str1 KeyStr:keyPtr gIvStr:keyPtr];
//                    //        NSLog(@"解密后：%@",str2);
//                    //     NSLog(@"JMW==== %@",JMW);
//                            [self->manager sendDataToBLE:[self getData:str1]];
//                });
//
    
}
- (NSString *)hexStringFromString:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
- (NSData *) getData: (NSString *) t {
    NSString * d = t;
    if (d == nil || d.length == 0) d = @"00";

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
