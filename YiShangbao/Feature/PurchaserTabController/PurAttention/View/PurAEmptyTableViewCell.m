//
//  PurAEmptyTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/6/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurAEmptyTableViewCell.h"

NSString *const PurAEmptyTableViewCellID = @"PurAEmptyTableViewCellID";

@interface PurAEmptyTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation PurAEmptyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.iconImageView setImage:[UIImage imageNamed:@"加载失败"]];
    self.tipLabel.text = @"关注商铺可以第一时间收到他们的\n上新、热销、库存动态哦～";
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(NSString *)model{
    self.nameLabel.text = model;
}

@end
