//
//  WYReleaseBusinessTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/10/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYReleaseBusinessTableViewCell.h"
#import "WYTradeModel.h"

NSString * const WYReleaseBusinessTableViewCellID = @"WYReleaseBusinessTableViewCellID";

@interface WYReleaseBusinessTableViewCell()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation WYReleaseBusinessTableViewCell

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
    
    self.dateLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(16);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(16);
    }];
    
    self.arrowImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@9.5);
    }];
    
    self.statusLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-5);
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right);
        make.width.equalTo(@60);
    }];
    
    self.dateLabel.font = [UIFont systemFontOfSize:14.0];
    self.dateLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.statusLabel.font = [UIFont systemFontOfSize:15.0];
    self.statusLabel.textColor = [UIColor colorWithHex:0X2F2F2F];
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    
    self.dateLabel.text = @"发布日期：";
    self.titleLabel.text = @"求购产品：";
    self.arrowImageView.image = [UIImage imageNamed:@"pic-jiantou"];
    
    return self;
}

- (void)updateData:(ReleaseBusniessModel *)model{
    self.dateLabel.text = [NSString stringWithFormat:@"发布日期：%@",model.createTime];
    self.titleLabel.text = [NSString stringWithFormat:@"求购产品：%@",model.productName];
    self.statusLabel.text = model.valid ? @"求购中" : @"已结束" ;
}

@end
