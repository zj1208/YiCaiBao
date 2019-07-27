//
//  WYSettingTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/10/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSettingTableViewCell.h"
NSString *const WYSettingTableViewCellID = @"WYSettingTableViewCellID";

@interface WYSettingTableViewCell()

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation WYSettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    self.arrowImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    self.contentLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-15);
    }];
    
    self.nameLabel.font = [UIFont systemFontOfSize:15.0];
    self.nameLabel.textColor = [UIColor colorWithHex:0x757575];
    self.contentLabel.font = [UIFont systemFontOfSize:15.0];
    self.contentLabel.textColor = [UIColor colorWithHex:0x757575];
    
    self.arrowImageView.image = [UIImage imageNamed:@"pic-jiantou"];
    
    return self;
}

- (void)updataName:(NSString *)name showArrow:(BOOL)show{
    [self updataName:name content:@"" showArrow:show];
}

- (void)updataName:(NSString *)name content:(NSString *)content showArrow:(BOOL)show{
    self.nameLabel.text = name;
    self.contentLabel.text = content;
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(10 - show * 15);
    }];
    self.arrowImageView.hidden = !show;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
