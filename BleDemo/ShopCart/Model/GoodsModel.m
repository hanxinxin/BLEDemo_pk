//
//  HxShopCartViewController.h
//  BleDemo
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GoodsModel.h"
#import "MJExtension.h"

@implementation GoodsModel

// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"goodsID"             : @"id",
             @"goodsIcon"           : @"icon",
             @"goodsName"           : @"name",
             @"goodsOriginalPrice"  : @"originalPrice",
             @"goodsSalePrice"      : @"salePrice",
             @"goodsStock"          : @"stock",
             @"goodsDesc"           : @"desc",
             @"orderCount"          : @"orderCount"
             };
}

@end
