//
//  WYSearchViewCollectionViewCell.m
//  YiShangbao
//
//  Created by light on 2018/3/1.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYSearchViewCollectionViewCell.h"

@implementation WYSearchViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self creatUI];
    
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.layer.cornerRadius = 14.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
    
    
    _titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
    
    self.titleLabel.textColor = [UIColor colorWithHex:0x535353];
    self.titleLabel.font = [UIFont systemFontOfSize:13.0];
}

@end
