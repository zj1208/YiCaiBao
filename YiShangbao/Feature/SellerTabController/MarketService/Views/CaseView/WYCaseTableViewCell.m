//
//  WYCaseTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/20.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYCaseTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "SurveyModel.h"

@implementation WYCaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        if(!self.image_view){
            self.image_view = [[UIImageView alloc]init];
            [self.contentView addSubview:self.image_view];
        }
        self.image_view.contentMode = UIViewContentModeScaleAspectFill;
        self.image_view.clipsToBounds = YES;
        [self.image_view sd_setImageWithURL:[NSURL URLWithString:@"http://4493bz.1985t.com/uploads/allimg/150127/4-15012G52133.jpg"] placeholderImage:[UIImage imageNamed:@"市场公告"] options:SDWebImageAllowInvalidSSLCertificates];
        
        if(!self.lbl_title){
            self.lbl_title = [[UILabel alloc]init];
            [self.contentView addSubview:self.lbl_title];
            self.lbl_title.text = @"收藏品骗局年末高发：打政府旗号推销 专坑老人养老金";
            self.lbl_title.textColor = WYUISTYLE.colorMTblack;
            self.lbl_title.font = WYUISTYLE.fontWith30;
            self.lbl_title.numberOfLines = 2;
            self.lbl_title.textAlignment = NSTextAlignmentLeft;
        }
        if(!self.lbl_date){
            self.lbl_date = [[UILabel alloc]init];
            [self.contentView addSubview:self.lbl_date];
            self.lbl_date.text = @"2016-11-09";
            self.lbl_date.textColor = WYUISTYLE.colorSTgrey;
            self.lbl_date.font = WYUISTYLE.fontWith24;
        }
        
        [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@12);
            make.height.equalTo(@80);
            make.width.equalTo(@120);
        }];

        [self.lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image_view.mas_right).offset(12);
            make.top.equalTo(@12);
            make.right.equalTo(self.mas_right).offset(-12);
            make.height.equalTo(@(48));
        }];
        [self.lbl_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image_view.mas_right).offset(12);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        }];
    }
    return self;
}


-(void)setData:(id)data{
    SurveyModel *model = (SurveyModel *)data;
    [self.image_view sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.lbl_title.text = model.title;
    self.lbl_date.text = model.createTime;
}

@end
