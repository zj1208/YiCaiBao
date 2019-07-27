//
//  ContactView.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ContactView.h"

@implementation ContactView


- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.scorll_bg = [[UIScrollView alloc] init];
    [self addSubview:self.scorll_bg];
    self.scorll_bg.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.cell_name = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_name];
    self.cell_name.title.text = @"*商铺联系人";
    self.cell_name.input.placeholder = @"请输入";
    
    self.cell_phone = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_phone];
    self.cell_phone.title.text = @"*手机";
    self.cell_phone.input.placeholder = @"请输入";
    self.cell_phone.input.keyboardType = UIKeyboardTypeNumberPad;
    
    self.cell_tel = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_tel];
    self.cell_tel.title.text = @"座机";
    self.cell_tel.input.placeholder = @"请输入";
    
    self.cell_fax = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_fax];
    self.cell_fax.title.text = @"传真";
    self.cell_fax.input.placeholder = @"请输入";
    
    self.cell_email = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_email];
    self.cell_email.title.text = @"E-mail";
    self.cell_email.input.placeholder = @"请输入";
    
    self.cell_qq = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_qq];
    self.cell_qq.title.text = @"QQ";
    self.cell_qq.input.placeholder = @"请输入";
    self.cell_qq.input.keyboardType = UIKeyboardTypeNumberPad;
    
    self.cell_wechat = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_wechat];
    self.cell_wechat.title.text = @"微信号";
    self.cell_wechat.input.placeholder = @"请输入";
    
    self.lbl_tip = [[UILabel alloc] init];
    [self.scorll_bg addSubview:self.lbl_tip];
    self.lbl_tip.font = WYUISTYLE.fontWith24;
    self.lbl_tip.textColor = WYUISTYLE.colorMred;
    self.lbl_tip.text = @"设置联系信息，方便采购商联系您，*号为必填。";
    //位置
    self.scorll_bg.contentSize = CGSizeMake(SCREEN_WIDTH, 520);
    [self.scorll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [self.cell_name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.cell_phone mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cell_name.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.cell_tel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.cell_phone.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.cell_fax mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.cell_tel.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.cell_email mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.cell_fax.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.cell_qq mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.cell_email.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.cell_wechat mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.cell_qq.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.lbl_tip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(self.cell_wechat.mas_bottom).offset(6);
    }];
    
    return self;
}

-(void)setData:(ShopContactModel *)data{
    self.cell_name.input.text = data.sellerName;
    self.cell_phone.input.text = data.sellerPhone;
    self.cell_tel.input.text = data.tel;
    self.cell_fax.input.text = data.fax;
    self.cell_email.input.text = data.email;
    self.cell_qq.input.text = data.qq;
    self.cell_wechat.input.text = data.wechat;
}
@end
