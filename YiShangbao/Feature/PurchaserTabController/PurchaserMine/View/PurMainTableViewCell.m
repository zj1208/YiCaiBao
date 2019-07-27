//
//  PurMainTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurMainTableViewCell.h"

@implementation PurMainTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.viewbg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,194)];
    [self addSubview:self.viewbg];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:1.0 green:0.76 blue:0.29 alpha:1].CGColor,(id)[UIColor colorWithRed:1.0 green:0.55 blue:0.26 alpha:1.0].CGColor, nil];
    gradient.frame = self.viewbg.layer.bounds;
    [self.viewbg.layer insertSublayer:gradient atIndex:0];
    
    self.imageHead = [[UIImageView alloc] init];
    [self addSubview:self.imageHead];
    self.btn = [[UIButton alloc] init];
    [self addSubview:self.btn];
    self.imageLogo1 = [[UIImageView alloc] init];
     [self addSubview:self.imageLogo1];
    self.imageLogo2 = [[UIImageView alloc] init];
     [self addSubview:self.imageLogo2];
    self.imageLogo3 = [[UIImageView alloc] init];
    [self addSubview:self.imageLogo3];
    self.labelName = [[UILabel alloc] init];
    [self addSubview:self.labelName];
    self.imageicon = [[UIImageView alloc] init];
    [self addSubview:self.imageicon];
    self.labelIntr = [[UILabel alloc] init];
    [self addSubview:self.labelIntr];
    self.viewLine = [[UIView alloc] init];
    [self addSubview:self.viewLine];
    self.attentionBtn = [[UIButton alloc] init];
    [self addSubview:self.attentionBtn];
    self.collectBtn = [[UIButton alloc] init];
    [self addSubview:self.collectBtn];
    
    //样式
    self.imageHead.layer.masksToBounds = YES;
    self.imageHead.layer.cornerRadius = 29;
    self.imageHead.contentMode = UIViewContentModeScaleAspectFill;
    self.imageHead.image = [UIImage imageNamed:@"ic_empty_person"];
    self.imageHead.layer.borderWidth = 1.5;
    self.imageHead.layer.borderColor = [UIColor whiteColor].CGColor;
    
//    self.imageLogo1.image = [UIImage imageNamed:@"ic_name_normal"];
//    self.imageLogo2.image = [UIImage imageNamed:@"ic_invite_normal"];
    
    self.labelName.text = @"哈利波特";
    self.labelName.textColor = WYUISTYLE.colorBWhite;
    self.labelName.font = [UIFont systemFontOfSize:17];
    self.labelName.textAlignment = NSTextAlignmentCenter;
    
    self.labelIntr.text = @"完善个人资料，让供应商更信任你～";
    self.labelIntr.textColor = WYUISTYLE.colorBWhite;
    self.labelIntr.font = [UIFont systemFontOfSize:14];
    self.labelIntr.textAlignment = NSTextAlignmentCenter;
    self.labelIntr.numberOfLines = 1;
    
    self.viewLine.backgroundColor = [UIColor colorWithRed:0.88 green:0.89 blue:0.89 alpha:1];
    [self.attentionBtn setImage:[UIImage imageNamed:@"ic_shop"] forState:UIControlStateNormal];
    [self.attentionBtn setTitle:@"关注的商铺" forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [self.attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.attentionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.attentionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    
    [self.collectBtn setImage:[UIImage imageNamed:@"ic_goods"] forState:UIControlStateNormal];
    [self.collectBtn setTitle:@"收藏的产品" forState:UIControlStateNormal];
    [self.collectBtn setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [self.collectBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.collectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.collectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    //位置
    [self.imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@62);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@58);
        make.height.equalTo(@58);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageHead.mas_top);
        make.left.equalTo(self.imageHead.mas_left);
        make.right.equalTo(self.imageHead.mas_right);
        make.bottom.equalTo(self.labelName.mas_bottom);
    }];
    [self.imageLogo1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imageHead.mas_centerY).offset(15);
        make.centerX.equalTo(self.imageHead.mas_centerX).offset(23);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [self.imageLogo2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageLogo1.mas_top);
        make.left.equalTo(self.imageLogo1.mas_right).offset(7);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [self.imageLogo3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageLogo2.mas_top);
        make.left.equalTo(self.imageLogo2.mas_right).offset(7);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageHead.mas_bottom).offset(8);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.imageicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelIntr.mas_top);
        make.right.equalTo(self.labelIntr.mas_left).offset(-5);
//        make.width.equalTo(@);
//        make.height.equalTo(@);
    }];
    [self.labelIntr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelName.mas_bottom).offset(7);
//        make.left.equalTo(@40);
//        make.right.equalTo(self.mas_right).offset(-40);
    }];
    [self.viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.viewbg.mas_bottom).offset(8);
        make.width.equalTo(@0.5);
        make.height.equalTo(@48);
    }];
    
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewbg.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH/2));
        make.height.equalTo(@64);
    }];
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewbg.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH/2-0.5));
        make.height.equalTo(@64);
    }];
    return self;
}

@end
