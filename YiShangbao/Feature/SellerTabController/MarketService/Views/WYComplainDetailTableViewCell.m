//
//  WYComplainDetailTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/26.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYComplainDetailTableViewCell.h"

@implementation WYComplainDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        if(!self.icon){
            self.icon = [[UIImageView alloc] init];
            self.icon.image = [UIImage imageNamed:@"通报按钮"];
            [self.contentView addSubview:self.icon];
        }
        if(!self.date){
            self.date = [[UILabel alloc]init];
            [self.contentView addSubview:self.date];
            self.date.textColor = WYUISTYLE.colorLTgrey;
            self.date.font = WYUISTYLE.fontWith24;
        }
        if(!self.content){
            self.content = [[UILabel alloc]init];
            [self.contentView addSubview:self.content];
            self.content.text = @"第一次做 公司有没有注册。";
            self.content.textColor = WYUISTYLE.colorMTblack;
            self.content.font = WYUISTYLE.fontWith28;
            self.content.numberOfLines = 0;
        }
        
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@12);
            make.width.equalTo(@20);
        }];
        [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_top);
            make.left.equalTo(self.icon.mas_right).offset(12);
            
        }];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.date.mas_left);
            make.top.equalTo(self.icon.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right).offset(-12);
        }];
    }
    return self;
}

- (float)getAutoCellHeight {
    [self layoutIfNeeded];
    /**
     *    self.最底部的控件.frame.origin.y      为自适应cell中的最后一个控件的Y坐标
     *    self.最底部的空间.frame.size.height   为自适应cell中的最后一个控件的高
     *    marginHeight    为自适应cell中的最后一个控件的距离cell底部的间隙
     */
    return  self.content.frame.origin.y + self.content.frame.size.height + 10;
    
}

@end
