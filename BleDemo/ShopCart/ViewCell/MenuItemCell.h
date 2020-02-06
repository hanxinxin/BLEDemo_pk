//
//  MenuItemCell.h
//  BleDemo
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GoodsModel, MenuItemCell;

@protocol MenuItemCellDelegate <NSObject>

@optional
- (void)menuItemCellDidClickPlusButton:(MenuItemCell *)itemCell;
- (void)menuItemCellDidClickMinusButton:(MenuItemCell *)itemCell;

@end
@interface MenuItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *SPImgae;
@property (strong, nonatomic) IBOutlet UILabel *SPNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *SPPriceLabel;



/** 商品模型 */
@property (strong, nonatomic) GoodsModel *goods;

/** 代理对象 */
@property (nonatomic, weak) id<MenuItemCellDelegate> delegate;



//加减商品操作
-(void)plusButtonClicked;
-(void)minusButtonClicked;
@end

NS_ASSUME_NONNULL_END
