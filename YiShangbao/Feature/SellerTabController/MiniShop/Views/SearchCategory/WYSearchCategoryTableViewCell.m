//
//  WYSearchCategoryTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/10/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSearchCategoryTableViewCell.h"
NSString *const WYSearchCategoryTableViewCellID = @"WYSearchCategoryTableViewCellID";

@interface WYSearchCategoryTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WYSearchCategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textColor = [UIColor colorWithHex:0x868686];
    
    return self;
}

- (void)updateData:(NSString *)name{
    self.titleLabel.text = name;
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
