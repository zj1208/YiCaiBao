//
//  WYSellerMineStatusTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/10/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSellerMineStatusTableViewCell.h"
NSString * const WYSellerMineStatusTableViewCellID = @"WYSellerMineStatusTableViewCellID";

@interface WYSellerMineStatusTableViewCell()

@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *statusNameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *changeStatusImageView;

@end

@implementation WYSellerMineStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.statusImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.statusImageView];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
//        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self);
    }];
    
    self.statusNameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.statusNameLabel];
    [self.statusNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(93);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    self.statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(93);
        make.top.equalTo(self.statusNameLabel.mas_bottom).offset(4);
    }];
    
    self.changeStatusImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.changeStatusImageView];
    [self.changeStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.statusImageView setImage:[UIImage imageNamed:@"pic_imgongyingshang"]];
    self.statusNameLabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    self.statusNameLabel.font = [UIFont systemFontOfSize:13];
    self.statusNameLabel.text = @"当前为";
    
    self.statusLabel.textColor = [UIColor colorWithHex:0x232323];
    self.statusLabel.font = [UIFont systemFontOfSize:15];
    self.statusLabel.text = @"供应商身份";
    
    [self.changeStatusImageView setImage:[UIImage imageNamed:@"btn_caigoushang"]];
    
    return self;
}
@end
