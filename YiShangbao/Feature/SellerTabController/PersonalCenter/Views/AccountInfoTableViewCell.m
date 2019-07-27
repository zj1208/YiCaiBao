//
//  AccountInfoTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AccountInfoTableViewCell.h"

@implementation AccountInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = WYUISTYLE.colorBWhite;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        if(!self.lbl_title){
            self.lbl_title = [[UILabel alloc]init];
            [self.contentView addSubview:self.lbl_title];
            self.lbl_title.text = @"头像";
            self.lbl_title.textColor = WYUISTYLE.colorMTblack;
            self.lbl_title.font = WYUISTYLE.fontWith28;
            self.lbl_title.textAlignment = NSTextAlignmentLeft;
        }
        if(!self.lbl_sub){
            self.lbl_sub = [[UILabel alloc]init];
            [self.contentView addSubview:self.lbl_sub];
            self.lbl_sub.text = @"昵称昵称";
            self.lbl_sub.textColor = WYUISTYLE.colorMTblack;
            self.lbl_sub.font = WYUISTYLE.fontWith30;
            self.lbl_sub.textAlignment = NSTextAlignmentRight;
        }
        if(!self.image_arrow){
            self.image_arrow = [[UIImageView alloc]init];
            [self.contentView addSubview:self.image_arrow];
            self.image_arrow.image = [UIImage imageNamed:@"向右箭头"];
            self.image_arrow.hidden = NO;
        }
        if(!self.userImage){
            self.userImage = [[UIImageView alloc]init];
            [self.contentView addSubview:self.userImage];
            self.userImage.contentMode = UIViewContentModeScaleAspectFill;
            self.userImage.image = [UIImage imageNamed:@"ic_empty_person"];
            self.userImage.layer.masksToBounds = YES;
            self.userImage.layer.cornerRadius = 15;
        }
        
        [self.lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self.image_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@36);
            make.height.equalTo(@36);
        }];
        [self.lbl_sub mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.image_arrow.mas_left);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.image_arrow.mas_left);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@30);
            make.width.equalTo(@30);
        }];

    }
    return self;
}

@end
