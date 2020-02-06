//
//  timelineAddressTableViewCell.h
//  BleDemo
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"
NS_ASSUME_NONNULL_BEGIN
extern NSString *const CCContentCellID;
@interface timelineAddressTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *pointView;
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
