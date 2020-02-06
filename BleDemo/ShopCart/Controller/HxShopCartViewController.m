//
//  HxShopCartViewController.m
//  BleDemo
//
//  Created by mac on 2019/12/31.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HxShopCartViewController.h"
#import "GoodsModel.h"
#import "GoodsCategory.h"
#import "MJExtension.h"
#import "MenuItemCell.h"
#import "ShopCartView.h"
#import "ThrowLineTool.h"
#import "DetailListCell.h"

#define ZXColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


@interface HxShopCartViewController ()<UITableViewDelegate,UITableViewDataSource,MenuItemCellDelegate,ThrowLineToolDelegate, DetailListCellDelegate,UISearchBarDelegate>
{
    NSInteger isSelectLeft;
}
@property (nonatomic, strong) NSArray       *dataArray;
@property (nonatomic, strong) NSArray       *ProductListArray;
@property (nonatomic, assign) BOOL          isRelate;
@property (nonatomic, strong) UIImageView   *redView;   //抛物线红点
@property (nonatomic, strong) ShopCartView  *shopCartView;
@property (nonatomic, assign) NSInteger     totalOrders;    //总数量

@property (nonatomic, strong) UISearchBar * searchBar;
@end

@implementation HxShopCartViewController
static NSString * const cellID = @"MenuItemCell";
static NSString * const ListCellID = @"DetailListCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUIBarButtonItem];
        isSelectLeft=0;
        [self leftTableView];
        [self rightTableView];
        [self shopCartView];
        [self loadData];
        [ThrowLineTool sharedTool].delegate = self;
        self->_isRelate = YES;
    
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
//
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];;
//
//            [self.leftTableView reloadData];
//        });
    
}
-(void)addUIBarButtonItem
{
    UIButton * btn1 = [[UIButton alloc] init];
//    [btn1 setTitle:FGGetStringWithKeyFromTable(@"Details", @"Language") forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"shoppingCart"] forState:(UIControlStateNormal)];
    [btn1 setTitleColor:[UIColor colorWithRed:255/255.0 green:207/255.0 blue:6/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(hiddenTitleView) forControlEvents:UIControlEventTouchUpInside];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
     UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn1];
//        UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacer1.width = -20; self.navigationItem.rightBarButtonItems = @[negativeSpacer1,self.navigationItem.leftBarButtonItem];
        self.navigationItem.rightBarButtonItem = rightBtn;
    [self addUISearchBarView];
}
-(void)addUISearchBarView
{
    
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(0, 0, self.view.frame.size.width - 100, 44);
//    self.navigationItem.titleView = button;
    _searchBar = [[UISearchBar alloc] initWithFrame:button.frame];
    _searchBar.delegate = self;
    if (@available(iOS 11.0, *)) {
        //  https://www.jianshu.com/p/352f101d6df1
        // 下面的 100  可以根据情况添加
        _searchBar.frame = CGRectMake(self.view.frame.size.width-100, 0, 0, button.frame.size.height);
    }
//    self.navigationItem.titleView.hidden=YES;
    _searchBar.hidden=YES;
    [button addSubview:_searchBar];
    self.navigationItem.titleView=button;

    
}

-(void)hiddenTitleView
{
        if(_searchBar.hidden==YES)
        {
            _searchBar.hidden=NO;
            [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
                //执行的动画
                self->_searchBar.frame =CGRectMake(0, 0, self.view.frame.size.width-100, 44);

            }completion:^(BOOL finished){
            }];
        }else
        {
            [UIView animateWithDuration:0.6/*动画持续时间*/animations:^{
                //执行的动画
                self->_searchBar.frame =CGRectMake(self.view.frame.size.width-100, 0, 0, 44);
            }completion:^(BOOL finished){
                //动画执行完毕后的操作
                self->_searchBar.hidden=YES;
            }];
        }
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) { make.left.right.equalTo(self.titView); make.top.equalTo(self.titView).offset(-2); make.bottom.equalTo(self.titView).offset(-2); }];
    
}



#pragma mark - 获取商品数据
- (void)loadData {
    if (!_dataArray) {
        _dataArray = [NSArray new];
        // 解析本地JSON文件获取数据，生产环境中从网络获取JSON
        NSString *path = [[NSBundle mainBundle] pathForResource:@"goods" ofType:@"json"];
        NSError *error = nil;
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingAllowFragments
                                                         error:&error];
        _dataArray = [GoodsCategory mj_objectArrayWithKeyValuesArray:arr];
        GoodsCategory *goodsCategory = _dataArray[0];
        _ProductListArray=goodsCategory.goodsArray;
        if (error) {
            NSLog(@"address.json - fail: %@", error.description);
        }
    }
}
- (NSMutableArray *)orderArray {
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}
- (UITableView *)leftTableView {
    if (nil == _leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.25, self.view.frame.size.height - 50)];
//        _leftTableView.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.25, self.view.frame.size.height - 50);
        _leftTableView.backgroundColor = ZXColor(240, 240, 240);
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_leftTableView];
    }
    return _leftTableView;
    
}

- (UITableView *)rightTableView {
    if (nil == _rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.25, 0, self.view.frame.size.width * 0.75, self.view.frame.size.height - 50)];
//        _rightTableView.frame =CGRectMake(self.view.frame.size.width * 0.25, 0, self.view.frame.size.width * 0.75, self.view.frame.size.height - 50);
        _rightTableView.backgroundColor = [UIColor whiteColor];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
//        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuItemCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        [self.view addSubview:_rightTableView];
    }
    return _rightTableView;
}



- (ShopCartView *)shopCartView {
    if (!_shopCartView) {
        _shopCartView = [[ShopCartView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, CGRectGetWidth(self.view.bounds), 50) inView:self.view];
        [self.view addSubview:_shopCartView];
        //_shopCartView.orderArray = [NSMutableArray new];
        _shopCartView.detailListView.listTableView.delegate = self;
        _shopCartView.detailListView.listTableView.dataSource = self;
        [_shopCartView.detailListView.listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailListCell class]) bundle:nil] forCellReuseIdentifier:ListCellID];
    }
    return _shopCartView;
}

- (UIImageView *)redView {
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _redView.image = [UIImage imageNamed:@"adddetail"];
        _redView.layer.cornerRadius = 10;
    }
    return _redView;
}

#pragma mark dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _leftTableView) {
        return 1;
    } else if (tableView == _rightTableView) {
//        return [_dataArray count];
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //该项目的demo就是数组里面装着很多字典，字典里面又有数组
    //NSDictionary *item = [_dataArray objectAtIndex:section];
//    GoodsCategory *goodsCategory = _dataArray[section];
    if (tableView == _leftTableView) {
        return _dataArray.count;
    } else if (tableView == _rightTableView) {
        //return [[item objectForKey:@"goodsArray"] count];
        
        return _ProductListArray.count;
    } else {
        return _orderArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _leftTableView) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
//            cell.backgroundColor = ZXColor(240, 240, 240);
            
//            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//            selectedBackgroundView.backgroundColor = ZXColor(26, 149, 229);
//            cell.selectedBackgroundView = selectedBackgroundView;
            if(isSelectLeft==indexPath.row)
            {
                [cell.textLabel setTextColor:[UIColor whiteColor]];
                cell.backgroundColor = ZXColor(26, 149, 229);
            }else
            {
                [cell.textLabel setTextColor:ZXColor(142, 142, 142)];
                cell.backgroundColor = [UIColor whiteColor];
            }
            // 左侧示意条
//            UIView *liner = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 6, 40)];
//            liner.backgroundColor = [UIColor orangeColor];
//            [selectedBackgroundView addSubview:liner];
        }
        
        GoodsCategory *goodsCategory = _dataArray[indexPath.row];
        cell.textLabel.text = goodsCategory.goodsCategoryName;
        
        return cell;
    } else if (tableView == _rightTableView) {
        
        MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.delegate = self;
        
//        GoodsCategory *goodsCategory = _dataArray[indexPath.section];
//        GoodsModel *goods = goodsCategory.goodsArray[indexPath.row];
        /// 自己修改的
        GoodsModel *goods = _ProductListArray[indexPath.row];
        cell.goods = goods;
        if(_orderArray.count>0)
        {
        GoodsModel *goodsIS = [_orderArray objectAtIndex:0];
        if([goodsIS.goodsName isEqualToString:goods.goodsName])
        {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{

            cell.SPPriceLabel.backgroundColor = [UIColor blueColor];
            cell.SPPriceLabel.layer.masksToBounds = YES;
            cell.SPPriceLabel.layer.cornerRadius=15;
        });
        }else{
            cell.SPPriceLabel.backgroundColor = [UIColor clearColor];
            cell.SPPriceLabel.layer.masksToBounds = YES;
            cell.SPPriceLabel.layer.cornerRadius=15;
        }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (tableView == _shopCartView.detailListView.listTableView) {
        DetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
        cell.delegate = self;
        GoodsModel *goods = [_orderArray objectAtIndex:indexPath.row];
        cell.goods = goods;
        return cell;
    } else {
        return nil;
    }
}

#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        return 50;
    } else if (tableView == _rightTableView) {
        return 100;
    } else {
        return 50;
    }
}

//返回每一个组头的高度，如果想达到有那种效果则一定要做这个操作
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        return 0;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        return 0.01;
    } else {
        return 0;
    }
}

//返回组头部的那块View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _rightTableView) {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
        view.backgroundColor = ZXColor(240, 240, 240);
        [view setAlpha:0.7];
        UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
        //NSDictionary *item = [_dataArray objectAtIndex:section];
        GoodsCategory *goodsCategory = [_dataArray objectAtIndex:section];
        NSString *title = goodsCategory.goodsCategoryDesc;
        [label setText:[NSString stringWithFormat:@"  %@",title]];
        [view addSubview:label];
        return view;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //左边tableView
    if (tableView == _leftTableView) {
        _isRelate = NO;
        [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
//        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        isSelectLeft=indexPath.row;
        for (int i=0; i<_dataArray.count; i++) {
            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:i inSection:0];;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPathA];
            if(i==indexPath.row)
            {
                [cell.textLabel setTextColor:[UIColor whiteColor]];
                cell.backgroundColor = ZXColor(26, 149, 229);
            }else
            {
                [cell.textLabel setTextColor:ZXColor(142, 142, 142)];
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        //点击了左边的cell，让右边的tableView跟着滚动
//        [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        /// 更新数据
        GoodsCategory *goodsCategory = _dataArray[indexPath.row];
        _ProductListArray=goodsCategory.goodsArray;
        [_leftTableView reloadData];
        [_rightTableView reloadData];
        
    } else if (tableView == _rightTableView) {
        [_rightTableView deselectRowAtIndexPath:indexPath animated:NO];
        
//        NSLog(@"点击这里可以跳到详情页面");
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        MenuItemCell *cell = (MenuItemCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell plusButtonClicked];
        ////最新修改的  在添加完物品后，刷新列表
        [_rightTableView reloadData];
    } else {
        [_shopCartView.detailListView.listTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == _rightTableView) {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if (_isRelate) {
        NSInteger topCellSection = [[[tableView indexPathsForVisibleRows] firstObject] section];
        if (tableView == _rightTableView) {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:topCellSection inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _isRelate = YES;
}

#pragma mark - MenuItemCellDelegate
- (void)menuItemCellDidClickMinusButton:(MenuItemCell *)itemCell {
    // 计算总价
    _totalPrice = _totalPrice - itemCell.goods.goodsSalePrice;
    
    // 设置总价
    [_shopCartView setTotalPrice:_totalPrice];
    
    --self.totalOrders;
    _shopCartView.badgeValue = self.totalOrders;
    
    
    // 将商品从购物车中移除
    if (itemCell.goods.orderCount == 0) {
        [self.orderArray removeObject:itemCell.goods];
    }
    [_shopCartView.detailListView.listTableView reloadData];
    _shopCartView.detailListView.objects = _orderArray;
    _shopCartView.orderArray = _orderArray;
}

- (void)menuItemCellDidClickPlusButton:(MenuItemCell *)itemCell {
    /* 暂时先只能选择一件商品*/
    self.totalOrders=0;
    _totalPrice=0;
    [self.orderArray removeAllObjects];
    /* 暂时先只能选择一件商品*/
    // 计算总价
    _totalPrice = _totalPrice + itemCell.goods.goodsSalePrice;
    // 设置总价
    [_shopCartView setTotalPrice:_totalPrice];

    //通过坐标转换得到抛物线的起点和终点
    CGRect parentRectA = [itemCell convertRect:itemCell.SPImgae.frame toView:self.view];
    CGRect parentRectB = [_shopCartView convertRect:_shopCartView.shopCartBtn.frame toView:self.view];
    [self.view addSubview:self.redView];
    [[ThrowLineTool sharedTool] throwObject:self.redView from:parentRectA.origin to:parentRectB.origin];
    ++self.totalOrders;
    _shopCartView.badgeValue = self.totalOrders;
    
    // 如果这个商品已经在购物车中，就不用再添加
    if ([self.orderArray containsObject:itemCell.goods]) {
        [_shopCartView.detailListView.listTableView reloadData];
    } else {
        // 添加需要购买的商品
        [self.orderArray addObject:itemCell.goods];
        [_shopCartView.detailListView.listTableView reloadData];
    }
    _shopCartView.detailListView.objects = _orderArray;
    _shopCartView.orderArray = _orderArray;
    
}

#pragma mark - ThrowLineToolDelegate
- (void)animationDidFinish {
    
    [self.redView removeFromSuperview];
    [UIView animateWithDuration:0.1 animations:^{
        self->_shopCartView.shopCartBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self->_shopCartView.shopCartBtn.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];

    }];
}

#pragma mark - DetailListCellDelegate
- (void)orderDetailCellPlusButtonClicked:(DetailListCell *)cell {
    NSLog(@"订单 + 按钮点击: %@ %@ %i", cell.goods.goodsID, cell.goods.goodsName, cell.goods.goodsStock);
    // 计算总价
    _totalPrice = _totalPrice + cell.goods.goodsSalePrice;
    // 设置总价
    [_shopCartView setTotalPrice:_totalPrice];
    ++self.totalOrders;
    _shopCartView.badgeValue = self.totalOrders;
    
    _shopCartView.detailListView.objects = _orderArray;
    _shopCartView.orderArray = _orderArray;
    [_shopCartView updateFrame:_shopCartView.detailListView];
    [_shopCartView.detailListView.listTableView reloadData];
    [_rightTableView reloadData];
}

- (void)orderDetailCellMinusButtonClicked:(DetailListCell *)cell {
    NSLog(@"订单 - 按钮点击: %@ %@ %i", cell.goods.goodsID, cell.goods.goodsName, cell.goods.goodsStock);
    // 计算总价
    _totalPrice = _totalPrice - cell.goods.goodsSalePrice;
    // 设置总价
    [_shopCartView setTotalPrice:_totalPrice];
    --self.totalOrders;
    _shopCartView.badgeValue = self.totalOrders;
    
    // 将商品从购物车中移除
    if (cell.goods.orderCount == 0) {
        [self.orderArray removeObject:cell.goods];
    }
    _shopCartView.detailListView.objects = _orderArray;
    _shopCartView.orderArray = _orderArray;
    [_shopCartView updateFrame:_shopCartView.detailListView];
    [_shopCartView.detailListView.listTableView reloadData];
    [_rightTableView reloadData];
}

@end
