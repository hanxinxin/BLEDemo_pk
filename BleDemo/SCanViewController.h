//
//  SCanViewController.h
//  BleDemo
//
//  Created by mac on 2019/11/13.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

////公共类
@interface countriesClass : NSObject
@property (strong,nonatomic)NSString * Gname;
@property (strong,nonatomic)NSString * Gtitle;
@property (strong,nonatomic)NSString * GImage;
@end


@interface SCanViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *ListBleTableView;

@end

NS_ASSUME_NONNULL_END
