//
//  timelineAddressViewController.m
//  BleDemo
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "timelineAddressViewController.h"
#import "timelineAddressTableViewCell.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define tableID @"timelineAddressTableViewCell"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface timelineAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation timelineAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableviewA.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    self.tableviewA.delegate=self;
    self.tableviewA.dataSource=self;
    self.tableviewA.contentInset = UIEdgeInsetsMake(-0.1, 0, 0, 0);
    self.tableviewA.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableviewA.backgroundColor = [UIColor redColor];
//    [self.tableviewA registerClass:[timelineAddressTableViewCell class] forCellReuseIdentifier:CCContentCellID];
    [self.tableviewA registerNib:[UINib nibWithNibName:@"timelineAddressTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:CCContentCellID cacheByIndexPath:indexPath configuration:^(id cell) {[self configureCell:cell atIndexPath:indexPath];}];
//    return 45;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    timelineAddressTableViewCell *cell = [timelineAddressTableViewCell cellWithTableView:tableView];
    timelineAddressTableViewCell *cell = (timelineAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
       if (cell == nil) {
           cell= (timelineAddressTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"timelineAddressTableViewCell" owner:self options:nil]  lastObject];
       }
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.pointView.mas_bottom);
            make.bottom.equalTo(cell);
            make.width.mas_offset(0.5);
            make.centerX.equalTo(cell.pointView);
        }];
    }else if(indexPath.row == 2)
    {
        [cell.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.bottom.equalTo(cell.pointView.mas_bottom);
            make.width.mas_offset(0.5);
            make.centerX.equalTo(cell.pointView);
           
        }];
    }else {
        [cell.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell);
            make.bottom.equalTo(cell);
            make.width.mas_offset(0.5);
            make.centerX.equalTo(cell.pointView);
        }];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(timelineAddressTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //使用Masonry进行布局的话，这里要设置为NO
    cell.fd_enforceFrameLayout = NO;
}
////行高
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 40;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 44;
//}
////设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
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
