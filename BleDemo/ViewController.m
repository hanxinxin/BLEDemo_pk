//
//  ViewController.m
//  BleDemo
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "HXBleManager.h"
#define M_BLE_NAME @"Gnwee"
#define M_BLE_MAC  @"A4C138050DC2"

//Service UUID:6e400001-b5a3-f393-e0a9-e50e24dcca9e
@interface ViewController  ()<CBCentralManagerDelegate, CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>

/**
 手机设备
 */
//@property (nonatomic, strong) CBCentralManager *centralManager;

/**
 外设设备
 */
@property (nonatomic, strong) CBPeripheral *peripheral;

/**
 特征值
 */
//@property (nonatomic, strong) CBCharacteristic *characteristic;

/**
 服务
 */
@property (nonatomic, strong) CBService *service;

/**
 描述
 */
//@property (nonatomic, strong) CBDescriptor *descriptor;


@property (nonatomic, strong) HXBleManager * manager;
/**
已扫描到的设备的数组
 */
@property (nonatomic, strong) NSMutableArray * ListArray;
@property (nonatomic, strong) NSMutableArray * DUIBIList;

@end

@implementation ViewController


//MARK: 1.初始化设备
- (void)viewDidLoad {
    [super viewDidLoad];
    self.ListArray = [NSMutableArray arrayWithCapacity:0];
    self.DUIBIList = [NSMutableArray arrayWithCapacity:0];
    self.ListBleTableView.delegate=self;
    self.ListBleTableView.dataSource=self;
    self.ListBleTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    // 初始化设备
//    self.centralManager =[[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.manager = [HXBleManager sharedInstance];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.manager scanPeripherals:NO];
        
    });
    
    [self.manager setReturnArrayList:^(NSMutableArray * _Nonnull MuArray) {
        self->_ListArray = MuArray;
        [self->_ListBleTableView reloadData];
    }];
}

//MARK: 2. 退出页面后，停止扫描 断开连接
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    // 停止扫描
//    [self.centralManager stopScan];
//    // 断开连接
//    if(self.centralManager!=nil&&self.peripheral.state==CBPeripheralStateConnected){
//        [self.centralManager cancelPeripheralConnection:self.peripheral];
//    }
    [self.manager closeConnected];
    [self.ListArray removeAllObjects];
    [self.DUIBIList removeAllObjects];
}





#pragma mark - ==========================TOOL===========================

//MARK: mac地址解析处理
- (NSString *)convertToNSStringWithNSData:(NSData *)data {
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    const unsigned char *szBuffer = [data bytes];
    for (NSInteger i=0; i < [data length]; ++i) {
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
    }
    return strTemp;
}





#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.ListArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
//    NSLog(@"self.topView.bottom = %f , self.topView.height = %f",self.topView.bottom,self.topView.height);
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.frame.size.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    CBPeripheral * peripheralList = self.ListArray[indexPath.section];
    NSDictionary *item = [self.ListArray objectAtIndex:indexPath.section];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
    cell.textLabel.textColor = [UIColor blueColor];
    //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    cell.layer.cornerRadius=4;
    return cell;
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
    return 8.f;
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
    //自定义间隔view，可以不写默认用系统的
    UIView * view_c= [[UIView alloc] init];
    view_c.frame=CGRectMake(0, 0, 0, 0);
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    return view_c;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
