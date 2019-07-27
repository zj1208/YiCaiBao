//
//  FastOpenShopView.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "FastOpenShopView.h"

@implementation FastOpenShopView


- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBWhite;
    
    self.scroll_bg = [[UIScrollView alloc] init];
    [self addSubview:self.scroll_bg];
    self.scroll_bg.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.shopHeadImage = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.shopHeadImage];
    self.shopHeadImage.title.text = @"商铺头像";
    
    self.shopName = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.shopName];
    self.shopName.title.text = @"商铺名称";
    
    self.mainCategory = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.mainCategory];
    self.mainCategory.title.text = @"主营类目";
    
    self.mainProducts = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.mainProducts];
    self.mainProducts.title.text = @"主营产品";
    
    self.businessPattern = [[CommonRadioButtonCell alloc] init];
    [self.scroll_bg addSubview:self.businessPattern];
    self.businessPattern.title.text = @"主要贸易类型";
    
    self.chooseMarket = [[CommonListChooseCell alloc] init];
    [self.scroll_bg addSubview:self.chooseMarket];
    
    self.name = [[CommonListNoArrowCell alloc] init];
    [self.scroll_bg addSubview:self.name];
    self.name.title.text = @"商铺联系人";
    
    self.phone = [[CommonListNoArrowCell alloc] init];
    [self.scroll_bg addSubview:self.phone];
    self.phone.title.text = @"手机";
    
    self.btn_confirm = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_confirm];
    [self.btn_confirm setTitle:@"立即保存" forState:UIControlStateNormal];
    [self.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
    self.btn_confirm.backgroundColor = WYUISTYLE.colorMred;
    [self.btn_confirm.titleLabel setFont:WYUISTYLE.fontWith36];
    self.btn_confirm.layer.cornerRadius = 18.f;
    [self.btn_confirm.titleLabel setTextAlignment:NSTextAlignmentCenter];

    
    self.scroll_bg.contentSize = CGSizeMake(SCREEN_WIDTH, 580);
    [self.scroll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [self.shopHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.shopHeadImage.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.mainCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.shopName.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.mainProducts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.mainCategory.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.businessPattern mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.mainProducts.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.chooseMarket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.businessPattern.mas_bottom).offset(12);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.chooseMarket.mas_bottom).offset(12);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.name.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.btn_confirm mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phone.mas_bottom).offset(50);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@260);
        make.height.equalTo(@36);
    }];
    
    return self;
}


-(void)initCell{
    self.shopHeadImage.subTitle.text = @"请选择头像";
    self.shopName.subTitle.text = @"请填写您的商铺名称";
    self.mainCategory.subTitle.text = @"最多选择6个";
    self.mainProducts.subTitle.text = @"请填写您的主营产品";
    self.chooseMarket.cell_chooseMarket.subTitle.text = @"请选择您的地址";
    self.name.input.placeholder = @"请输入姓名";
    self.phone.input.placeholder = @"请输入手机号";
    self.phone.line.hidden = YES;
    self.chooseMarket.yiwuDetailcell.hidden = YES;
}

-(void)setUIChooseMarket{
    marketModel *model = (marketModel *)_marketStr;
    if ([model.name isEqualToString:@"其它"]) {
        self.chooseMarket.yiwuDetailcell.hidden = YES;
        self.chooseMarket.cell_chooseDistrict.hidden = NO;
        self.chooseMarket.detailAdr.hidden = NO;
        [self.chooseMarket mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@132);
        }];
        [self.chooseMarket.cell_chooseDistrict mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
        }];
        [self.chooseMarket.detailAdr mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
        }];
        [self.chooseMarket.yiwuDetailcell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        self.chooseMarket.yiwuDetailcell.hidden = NO;
        self.chooseMarket.cell_chooseDistrict.hidden = YES;
        self.chooseMarket.detailAdr.hidden = YES;
        [self.chooseMarket mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@132);
        }];
        [self.chooseMarket.cell_chooseDistrict mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.chooseMarket.detailAdr mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.chooseMarket.yiwuDetailcell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@88);
        }];
    }
}
@end
