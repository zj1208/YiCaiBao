//
//  ShopAddressView.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopAddressView.h"

@implementation ShopAddressView

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBWhite;
    
    self.scroll_bg = [[UIScrollView alloc] init];
    [self addSubview:self.scroll_bg];
    self.scroll_bg.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.chooseMarket = [[CommonListChooseCell alloc] init];
    [self.scroll_bg addSubview:self.chooseMarket];
    
    
    self.scroll_bg.contentSize = CGSizeMake(SCREEN_WIDTH, 520);
    [self.scroll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [self.chooseMarket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@88);
    }];
    
    return self;
}


-(void)setData:(ShopAddrModel *)data{
    if ([data.submarketValue isEqualToString:@"其它"]) {
        self.chooseMarket.yiwuDetailcell.hidden = YES;
        self.chooseMarket.cell_chooseDistrict.hidden = NO;
        self.chooseMarket.detailAdr.hidden = NO;
        self.chooseMarket.cell_chooseMarket.subTitle.text = data.submarketValue;
        self.chooseMarket.cell_chooseMarket.subTitle.textColor = WYUISTYLE.colorMTblack;
        if (data.gr1VO.length && data.gr2VO.length && data.gr3VO.length) {
            self.chooseMarket.cell_chooseDistrict.subTitle.text = [NSString stringWithFormat:@"%@->%@->%@",data.gr1VO,data.gr2VO,data.gr3VO];
            self.chooseMarket.cell_chooseDistrict.subTitle.textColor = WYUISTYLE.colorMTblack;
        }else if (data.gr1VO.length && data.gr2VO.length){
            self.chooseMarket.cell_chooseDistrict.subTitle.text = [NSString stringWithFormat:@"%@->%@",data.gr1VO,data.gr2VO];
            self.chooseMarket.cell_chooseDistrict.subTitle.textColor = WYUISTYLE.colorMTblack;
        }else if(data.gr1VO.length){
            self.chooseMarket.cell_chooseDistrict.subTitle.text = [NSString stringWithFormat:@"%@",data.gr1VO];
            self.chooseMarket.cell_chooseDistrict.subTitle.textColor = WYUISTYLE.colorMTblack;
        }else{
            self.chooseMarket.cell_chooseDistrict.subTitle.text = @"请选择城市";
             self.chooseMarket.cell_chooseDistrict.subTitle.textColor = WYUISTYLE.colorSTgrey;
        }
        self.chooseMarket.detailAdr.text = data.gr4;
        
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
        self.chooseMarket.cell_chooseMarket.subTitle.text = data.submarketValue;
        self.chooseMarket.cell_chooseMarket.subTitle.textColor = WYUISTYLE.colorMTblack;
        self.chooseMarket.yiwuDetailcell.txtfield_men.text = data.gr1;
        self.chooseMarket.yiwuDetailcell.txtfield_lou.text = data.gr2;
        self.chooseMarket.yiwuDetailcell.txtfield_jie.text = data.gr3;
        self.chooseMarket.yiwuDetailcell.txtfield_number.text = data.gr4;
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
