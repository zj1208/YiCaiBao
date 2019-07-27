//
//  SurveyTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SurveyTableViewCell.h"

@implementation SurveyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.image_searchLogo = [[UIImageView alloc] init];
    [self addSubview:self.image_searchLogo];
    
    self.searchBarBg = [[UIView alloc] init];
    [self addSubview:self.searchBarBg];
    self.searchImg = [[UIImageView alloc] init];
    [self.searchBarBg addSubview:self.searchImg];
    self.searchText = [[UILabel alloc] init];
    [self.searchBarBg addSubview:self.searchText];
    self.searchBtn = [[UIButton alloc] init];
    [self addSubview:self.searchBtn];
    
    //样式
    self.image_searchLogo.image = [UIImage imageNamed:@"pic_tittle"];
    
    self.searchBarBg.backgroundColor = [UIColor colorWithRed:241.f/255.f green:250.f/255.f blue:253.f/255.f alpha:1];
    self.searchBarBg.layer.borderColor = [WYUISTYLE colorWithHexString:@"8DD0FF"].CGColor;
    self.searchBarBg.layer.borderWidth = 0.5;
    self.searchBarBg.layer.cornerRadius = 19.f;
    self.searchText.text = @"点此查询义乌外贸公司信誉";
    self.searchText.textColor =  [WYUISTYLE colorWithHexString:@"45A4E9"];
    self.searchText.font = WYUISTYLE.fontWith28;

    self.searchImg.image = [UIImage imageNamed:@"ic_search_blue"];
    
    
    //位置
    
    [self.image_searchLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(self.mas_top).offset(30);
    }];
    
    [self.searchBarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.image_searchLogo.mas_bottom).offset(22.5f);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@38);
    }];
    [self.searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBarBg.mas_centerY);
        make.right.equalTo(self.searchText.mas_left).offset(-13);
        make.height.equalTo(@14);
        make.width.equalTo(@14);
    }];
    
    [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchBarBg.mas_centerY);
        make.centerX.equalTo(self.searchBarBg.mas_centerX);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.image_searchLogo.mas_bottom).offset(20);
        make.width.equalTo(self.searchBarBg.mas_width);
        make.height.equalTo(@32);
    }];

    return self;
}

@end
