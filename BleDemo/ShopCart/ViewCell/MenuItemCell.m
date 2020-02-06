//
//  MenuItemCell.m
//  BleDemo
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MenuItemCell.h"
#import "GoodsModel.h"

@interface MenuItemCell ()
@end


@implementation MenuItemCell


- (void)setGoods:(GoodsModel *)goods {
    _goods = goods;
//    if (_goods.orderCount > 0) {
//        [self.minusButton setHidden:NO];
//        [self.goodsCountLabel setHidden:NO];
//    } else {
//        [self.minusButton setHidden:YES];
//        [self.goodsCountLabel setHidden:YES];
//    }
    self.SPPriceLabel.text = [NSString stringWithFormat:@"RM%.2f", goods.goodsSalePrice];
    self.SPNameLabel.text = [NSString stringWithFormat:@"%@", goods.goodsName];
    self.SPImgae.image = [UIImage imageNamed:goods.goodsIcon];
            
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)plusButtonClicked {
    _goods.orderCount++;    // 修改模型
    _goods.goodsStock--;
//    _goodsCountLabel.text = [NSString stringWithFormat:@"%i", _goods.orderCount];
//    _minusButton.hidden = NO;
//    _goodsCountLabel.hidden = NO;
//    if (_goods.goodsStock == 0) {
//        _plusButton.enabled = NO;
//        self.soldoutIconView.hidden = NO;
//    }
    
    // 通知代理（调用代理的方法）
    // respondsToSelector:能判断某个对象是否实现了某个方法
    if ([self.delegate respondsToSelector:@selector(menuItemCellDidClickPlusButton:)]) {
        [self.delegate menuItemCellDidClickPlusButton:self];
    }
}

- (void)minusButtonClicked {
    _goods.orderCount--;
    _goods.goodsStock++;
//    _goodsCountLabel.text = [NSString stringWithFormat:@"%i", _goods.orderCount];
//
//    if (_goods.orderCount == 0) {
//        _minusButton.hidden = YES;
//        _goodsCountLabel.hidden = YES;
//    }
//
//    if (_goods.goodsStock > 0) {
//        _plusButton.enabled = YES;
//        self.soldoutIconView.hidden = YES;
//    }
    
    // 通知代理（调用代理的方法）
    if ([self.delegate respondsToSelector:@selector(menuItemCellDidClickMinusButton:)]) {
        [self.delegate menuItemCellDidClickMinusButton:self];
    }
}



@end
