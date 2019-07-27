//
//  UserListTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UserListTableViewCell.h"

@implementation UserListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = WYUISTYLE.colorBWhite;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        if(!self.image_icon){
            self.image_icon = [[UIImageView alloc]init];
            [self.contentView addSubview:self.image_icon];
        }
        if(!self.lbl_text){
            self.lbl_text = [[UILabel alloc]init];
            [self.contentView addSubview:self.lbl_text];
            self.lbl_text.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.0];
            self.lbl_text.font = WYUISTYLE.fontWith28;
            self.lbl_text.textAlignment = NSTextAlignmentLeft;
        }
        if(!self.lbl_sub){
            self.lbl_sub = [[UILabel alloc]init];
            [self.contentView addSubview:self.lbl_sub];
            self.lbl_sub.font = WYUISTYLE.fontWith28;
            self.lbl_sub.textAlignment = NSTextAlignmentCenter;
            self.lbl_sub.hidden = YES;
            self.lbl_sub.textColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1.0];
        }
        if(!self.image_arrow){
            self.image_arrow = [[UIImageView alloc]init];
            [self.contentView addSubview:self.image_arrow];
            self.image_arrow.image = [UIImage imageNamed:@"pic-jiantou"];
            self.image_arrow.hidden = NO;
        }
        
        [self.image_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@20);
        }];
        [self.lbl_text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image_icon.mas_right).offset(12);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self.image_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@9);
            make.height.equalTo(@17);
        }];
        
        [self.lbl_sub mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.image_arrow.mas_left).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@24);
        }];
        
    }
    return self;
}


@end
