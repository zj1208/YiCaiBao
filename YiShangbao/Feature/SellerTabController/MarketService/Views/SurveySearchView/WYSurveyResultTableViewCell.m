//
//  WYSurveyResultTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/28.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYSurveyResultTableViewCell.h"

@implementation WYSurveyResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        if(!self.title){
            self.title = [[UILabel alloc]init];
            [self.contentView addSubview:self.title];
            self.title.textColor = WYUISTYLE.colorMTblack;
            self.title.font = WYUISTYLE.fontWith30;
        }
        if(!self.labelTip){
            self.labelTip = [[UILabel alloc]init];
            [self.contentView addSubview:self.labelTip];
            self.labelTip.text = @"严重失信";
            self.labelTip.layer.masksToBounds =YES ;
            self.labelTip.layer.cornerRadius = 6;
            self.labelTip.backgroundColor = WYUISTYLE.colorMred;
            self.labelTip.textColor = WYUISTYLE.colorBWhite;
            self.labelTip.font = WYUISTYLE.fontWith24;
            self.labelTip.textAlignment = NSTextAlignmentCenter;
            self.labelTip.hidden = NO;
        }
        if(!self.icon){
            self.icon = [[UIImageView alloc] init];
            self.icon.image = [UIImage imageNamed:@"地点"];
            [self.contentView addSubview:self.icon];
        }
        if(!self.address){
            self.address = [[UILabel alloc]init];
            [self.contentView addSubview:self.address];
            self.address.textColor = WYUISTYLE.colorLTgrey;
            self.address.font = WYUISTYLE.fontWith28;
        }
        if(!self.arrow){
            self.arrow = [[UIImageView alloc]init];
            [self.contentView addSubview:self.arrow];
            self.arrow.image = [UIImage imageNamed:@"向右箭头"];
        }
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@12);
            make.right.equalTo(self.arrow.mas_left).offset(-82);
        }];
        [self.labelTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_top);
            make.left.equalTo(self.title.mas_right).offset(12);
            make.width.equalTo(@70);
            make.height.equalTo(@20);
        }];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_left);
            make.top.equalTo(self.title.mas_bottom).offset(14);
            make.width.equalTo(@12);
            make.height.equalTo(@12);
        }];
        [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(7);
            make.top.equalTo(self.icon.mas_top);
            make.right.equalTo(self.arrow.mas_left).offset(-12);
        }];
        [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@36);
            make.height.equalTo(@36);
        }];
    }
    return self;
}


-(void)setData:(id)data{
    DetectSearchModel *model = (DetectSearchModel *)data;
    self.title.text = model.companyname;
    if (model.companyaddress.length) {
        self.address.text = model.companyaddress;
    }else{
        self.address.text = @"未知";
    }
    if ([model.type isEqualToString:@"C"]) {
        self.labelTip.hidden = NO;
    }else{
        self.labelTip.hidden = YES;
    }
}
@end
