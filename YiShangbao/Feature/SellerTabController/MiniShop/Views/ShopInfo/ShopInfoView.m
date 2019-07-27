//
//  ShopInfoView.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopInfoView.h"

#import "ShopModel.h"

@implementation ShopInfoView


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
    self.shopHeadImage.headImage.hidden = NO;
    self.shopHeadImage.headImage.image = [UIImage imageNamed:@"ic_empty_person"];
    
//    self.shopName = [[CommonListNoArrowCell alloc] init];
    self.shopName = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.shopName];
    self.shopName.title.text = @"商铺名称";
    self.shopName.arrow.hidden = YES;
    
    self.shopIntro = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.shopIntro];
    self.shopIntro.title.text = @"商铺简介";
    
    self.shopAddress = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.shopAddress];
    self.shopAddress.title.text = @"商铺地址";
    
    //商铺实景
    self.shopShiJing = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.shopShiJing];
    self.shopShiJing.title.text = @"商铺实景";
    
    
//    self.chooseMarket = [[CommonListChooseCell alloc] init];
//    [self.scroll_bg addSubview:self.chooseMarket];
    
    self.manageInfo = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.manageInfo];
    self.manageInfo.title.text = @"经营信息";
    self.manageInfo.subTitle.text = @"设置主营类目、主营产品等信息";
    
//    self.shopContactman = [[CommonListNoArrowCell alloc] init];
    self.shopContactInfo = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.shopContactInfo];
    self.shopContactInfo.title.text = @"联系方式";
    
//    self.contact = [[CommonListCell alloc] init];
//    [self.scroll_bg addSubview:self.contact];
//    self.contact.title.text = @"联系方式";
    
    self.bankAccount = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.bankAccount];
    self.bankAccount.title.text = @"银行账号";
    
    self.tradeSetting = [[CommonListCell alloc] init];
    [self.scroll_bg addSubview:self.tradeSetting];
    self.tradeSetting.title.text = @"交易设置";
    self.tradeSetting.subTitle.text = @"您暂未打开交易设置";
    
//    self.btn_confirm = [[UIButton alloc] init];
//    [self.scroll_bg addSubview:self.btn_confirm];
//    [self.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
//    [self.btn_confirm setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
//    [self.btn_confirm setTitle:@"保 存" forState:UIControlStateNormal];
//    [self.btn_confirm.titleLabel setFont:WYUISTYLE.fontWith36];
//    [self.btn_confirm.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    self.btn_confirm.titleEdgeInsets = UIEdgeInsetsMake(-6, 0, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    //    self.btn_confirm.userInteractionEnabled = NO;
    
    self.scroll_bg.contentSize = CGSizeMake(SCREEN_WIDTH, 520);
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
    
    [self.shopIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.shopName.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.shopAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.shopIntro.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    //
    [self.shopShiJing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.shopAddress.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.manageInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.shopShiJing.mas_bottom).offset(12);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    [self.shopContactInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.manageInfo.mas_bottom).offset(12);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
//    [self.contact mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@0);
//        make.top.equalTo(self.shopContactman.mas_bottom);
//        make.width.equalTo(@(SCREEN_WIDTH));
//        make.height.equalTo(@44);
//    }];
    
    [self.bankAccount mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.shopContactInfo.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
//    [self.btn_confirm mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bankAccount.mas_bottom).offset(50);
//        make.centerX.equalTo(self.mas_centerX);
//    }];
    
    [self.tradeSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.bankAccount.mas_bottom).offset(12);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    return self;
}


-(void)initCell:(ShopListModel *)data{
    self.shopHeadImage.headImage.hidden = NO;
    [self.shopHeadImage.headImage sd_setImageWithURL:[NSURL URLWithString:data.iconUrl] placeholderImage:[UIImage imageNamed:@"ic_empty_person"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    self.shopName.subTitle.text = data.name;
    self.shopName.subTitle.textColor = WYUISTYLE.colorMTblack;
    if (data.outline.length) {
        self.shopIntro.subTitle.text = data.outline;
        self.shopIntro.subTitle.textColor = WYUISTYLE.colorMTblack;
    }else{
        self.shopIntro.subTitle.text = @"请输入商铺简介";
    }
    if ([data.submarketValue isEqualToString:@"其它"]) {
         self.shopAddress.subTitle.text = [NSString stringWithFormat:@"%@%@%@%@",data.provinceVO,data.cityVO,data.areaVO,data.address];
        self.shopAddress.subTitle.textColor = WYUISTYLE.colorMTblack;
    }else{
        NSString *menStr = @"";
        NSString *jieStr = @"";
        if (data.door.length) {
             menStr = [NSString stringWithFormat:@"%@门",data.door];
        }
        if (data.street.length) {
            jieStr = [NSString stringWithFormat:@"%@街",data.street];
        }
         self.shopAddress.subTitle.text = [NSString stringWithFormat:@"%@%@%@楼%@%@",data.submarketValue,menStr,data.floor,jieStr,data.boothNos];
        self.shopAddress.subTitle.textColor = WYUISTYLE.colorMTblack;
    }
    
    if (data.canTrade.integerValue > 0) {
        self.tradeSetting.subTitle.text = @"已打开在线交易";
    }else {
        self.tradeSetting.subTitle.text = @"您暂未打开在线交易";
    }
}
@end
