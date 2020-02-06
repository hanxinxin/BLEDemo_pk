//
//  HxShopCartViewController.h
//  BleDemo
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HxShopCartViewController : UIViewController
@property (strong, nonatomic) UITableView *leftTableView;
@property (strong, nonatomic) UITableView *rightTableView;



/** 订单数据 */
@property (nonatomic, strong) NSMutableArray *orderArray;

/** 订单所选总数量 */
@property (nonatomic, assign) NSInteger totalOrderCount;

/** 订单总价 */
@property (assign, nonatomic) double totalPrice;


@end

NS_ASSUME_NONNULL_END
