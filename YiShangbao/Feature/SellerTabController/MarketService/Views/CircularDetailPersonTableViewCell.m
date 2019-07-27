//
//  CircularDetailPersonTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CircularDetailPersonTableViewCell.h"
#import "SurveyModel.h"
@implementation Info_showView
- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBWhite;
    
    self.title = [[UILabel alloc] init];
    [self addSubview:self.title];
    self.content = [[UILabel alloc] init];
    [self addSubview:self.content];
    self.content.textAlignment = NSTextAlignmentLeft;
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    
    //样式
    self.title.textColor = WYUISTYLE.colorLTgrey;
    self.title.font = WYUISTYLE.fontWith28;
    self.content.textColor = WYUISTYLE.colorMTblack;
    self.content.font = WYUISTYLE.fontWith30;
    self.line.backgroundColor = WYUISTYLE.colorLinegrey;
    
    //位置
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.left.equalTo(self.title.mas_right).offset(12);
        //        make.height.equalTo(@18);
        //        make.width.equalTo(self.mas_width).offset(-24);
        
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    return self;
}
@end

@implementation CircularDetailPersonTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBWhite;
    self.personImage = [[UIImageView alloc] init];
    [self addSubview:self.personImage];
    self.personName = [[Info_showView alloc] init];
    [self addSubview:self.personName];
    self.personName.title.text = @"姓 名";
    self.personNation = [[Info_showView alloc] init];
    [self addSubview:self.personNation];
    self.personNation.title.text = @"国 籍";
    self.personDuty = [[Info_showView alloc] init];
    [self addSubview:self.personDuty];
    self.personDuty.title.text = @"职 务";
    self.personIDNumber = [[Info_showView alloc] init];
    [self addSubview:self.personIDNumber];
    self.personIDNumber.title.text = @"证 件";
    self.personIDNumber.line.hidden = YES;


    [self.personImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(self.mas_top).offset(12);
        make.width.equalTo(@120);
        make.height.equalTo(@150);
    }];
    [self.personName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.personImage.mas_right).offset(12);
        make.top.equalTo(self.mas_top).offset(12);
        make.right.equalTo(self.mas_right).offset(-6);
        make.height.equalTo(@44);
    }];
    [self.personNation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.personName.mas_left);
        make.top.equalTo(self.personName.mas_bottom);
        make.width.equalTo(@(243));
        make.height.equalTo(@44);
    }];
    [self.personDuty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.personNation.mas_left);
        make.top.equalTo(self.personNation.mas_bottom);
        make.width.equalTo(@(243));
        make.height.equalTo(@44);
    }];
    [self.personIDNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.personDuty.mas_left);
        make.top.equalTo(self.personDuty.mas_bottom);
        make.width.equalTo(@(243));
        make.height.equalTo(@44);
    }];
    return self;
}
-(void)setData:(id)data{
    CircularDetailModel *model = (CircularDetailModel *)data;
    PersonModel *pModel = [[PersonModel alloc] init];
    if (model.person.count) {
        pModel = model.person[0];
    }
        if (pModel.name.length) {
            self.personName.content.text = pModel.name;
        }else{
            self.personName.content.text = @"暂无";
        }
        if (pModel.country.length) {
            self.personNation.content.text = pModel.country;
        }else{
            self.personNation.content.text = @"暂无";
        }
        if (pModel.position.length) {
            self.personDuty.content.text =pModel.position;
        }else{
            self.personDuty.content.text = @"暂无";
        }
        if (pModel.passport.length) {
            self.personIDNumber.content.text = pModel.passport;
        }else{
            self.personIDNumber.content.text = @"暂无";
        }
        [self.personImage sd_setImageWithURL:[NSURL URLWithString:pModel.picpath] placeholderImage:[UIImage imageNamed:@"经侦默认头像"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];
}
@end
