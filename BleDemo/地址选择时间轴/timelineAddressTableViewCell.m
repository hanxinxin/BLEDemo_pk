//
//  timelineAddressTableViewCell.m
//  BleDemo
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "timelineAddressTableViewCell.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#define colorWithRGBA(rgbValue, alphaValue) \
[UIColor colorWithRed:((float)((0x##rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((0x##rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(0x##rgbValue & 0xFF)) / 255.0 alpha:alphaValue]
#define colorWithRGB(rgbValue)  colorWithRGBA(rgbValue, 1.0)

NSString *const CCContentCellID = @"timelineAddressTableViewCell";
@implementation timelineAddressTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    timelineAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CCContentCellID];
    if (!cell) {
        cell = [[timelineAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CCContentCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildUI];
        [self setupLayout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self buildUI];
    [self setupLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)buildUI {
    _pointView = [[UIView alloc] init];
    _pointView.backgroundColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1];;
    _pointView.layer.cornerRadius = 3.5;
    _pointView.layer.masksToBounds = YES;
    [self.contentView addSubview:_pointView];

    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1];
    [self.contentView addSubview:_lineView];
    
    _cellTitle = [[UILabel alloc] init];
    _cellTitle.textColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1];
    _cellTitle.font = [UIFont boldSystemFontOfSize:16.0f];
    _cellTitle.numberOfLines = 0;
    [self.contentView addSubview:_cellTitle];
}
- (void)setupLayout {
    [_pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.width.height.mas_offset(7);
    }];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.mas_offset(0.5);
        make.centerX.equalTo(self->_pointView);
        make.centerY.equalTo(self->_cellTitle);
    }];
    //时间
    [_cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_pointView.mas_right).offset(23);
        make.width.mas_offset(100);
        make.height.mas_offset(15);
        make.centerY.equalTo(self->_pointView);
    }];
}
@end
