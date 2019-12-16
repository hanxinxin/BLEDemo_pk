//
//  searchingHeaderView.h
//  BleDemo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface searchingHeaderView : UITableViewHeaderFooterView
+ (CGFloat)headerViewHeight;
//+ (NSString *)reuseID;

- (void)configWithTitle:(NSString *)title;
- (void)configWithProgress:(double)progress;
@end

NS_ASSUME_NONNULL_END
