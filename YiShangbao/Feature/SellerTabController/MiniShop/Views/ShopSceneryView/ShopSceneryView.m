//
//  ShopSceneryView.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopSceneryView.h"
#define k5widthScale 0.8533



@implementation SceneryCellView

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.bg = [[UIImageView alloc] init];
    [self addSubview:self.bg];
    self.bg.image = [UIImage imageNamed:@"拍照白底"];
    self.bg.contentMode = UIViewContentModeScaleToFill;
    
    self.photo = [[UIImageView alloc] init];
    [self addSubview:self.photo];
    self.photo.image = [UIImage imageNamed:@"拍照"];
    
    self.lbl_text = [[UILabel alloc] init];
    [self addSubview:self.lbl_text];
    self.lbl_text.font = WYUISTYLE.fontWith28;
    self.lbl_text.textColor = WYUISTYLE.colorMred;
    
    self.pic = [[UIImageView alloc] init];
    [self addSubview:self.pic];
    self.pic.clipsToBounds = YES;
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    self.pic.layer.masksToBounds = YES;
    self.pic.layer.cornerRadius =8.0;
    
    self.btn = [[UIButton alloc] init];
    [self addSubview:self.btn];
    
    if ([WYUTILITY.getMainScreen isEqualToString:@"5"]) {
        [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height);
        }];
        
        [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bg.mas_centerX);
            make.top.equalTo(self.bg.mas_top).offset(20);
            make.width.equalTo(@(50*k5widthScale));
            make.height.equalTo(@(50*k5widthScale));
        }];
        
        [self.lbl_text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photo.mas_bottom).offset(14);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bg.mas_top);
            make.left.equalTo(self.bg.mas_left);
            make.width.equalTo(self.bg.mas_width);
            make.height.equalTo(self.bg.mas_height);
        }];
        
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bg.mas_top);
            make.left.equalTo(self.bg.mas_left);
            make.width.equalTo(self.bg.mas_width);
            make.height.equalTo(self.bg.mas_height);
        }];
    }else{
        [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height);
        }];
        
        [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bg.mas_centerX);
            make.top.equalTo(self.bg.mas_top).offset(30);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];
        
        [self.lbl_text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.photo.mas_bottom).offset(14);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bg.mas_top);
            make.left.equalTo(self.bg.mas_left);
            make.width.equalTo(self.bg.mas_width);
            make.height.equalTo(self.bg.mas_height);
        }];
        
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bg.mas_top);
            make.left.equalTo(self.bg.mas_left);
            make.width.equalTo(self.bg.mas_width);
            make.height.equalTo(self.bg.mas_height);
        }];
    }
    return self;
}

@end


@implementation ShopSceneryView

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.cellTop = [[SceneryCellView alloc] init];
    [self addSubview:self.cellTop];
    self.cellTop.lbl_text.text = @"上传商铺门头(必传)";
    
    self.btn_top = [[UIButton alloc] init];
    [self addSubview:self.btn_top];
    [self.btn_top setImage:[UIImage imageNamed:@"删除照片"] forState:UIControlStateNormal];
    self.btn_top.hidden = YES;
    
    self.cellLeftup = [[SceneryCellView alloc] init];
    [self addSubview:self.cellLeftup];
    self.cellLeftup.lbl_text.text = @"上传商铺实景";
    
    self.btn_Leftup = [[UIButton alloc] init];
    [self addSubview:self.btn_Leftup];
    [self.btn_Leftup setImage:[UIImage imageNamed:@"删除照片"] forState:UIControlStateNormal];
    self.btn_Leftup.hidden = YES;
    
    self.cellLeftDown = [[SceneryCellView alloc] init];
    [self addSubview:self.cellLeftDown];
    self.cellLeftDown.lbl_text.text = @"上传商铺实景";
    
    self.btn_LeftDown = [[UIButton alloc] init];
    [self addSubview:self.btn_LeftDown];
    [self.btn_LeftDown setImage:[UIImage imageNamed:@"删除照片"] forState:UIControlStateNormal];
    self.btn_LeftDown.hidden = YES;
    
    self.cellRightup = [[SceneryCellView alloc] init];
    [self addSubview:self.cellRightup];
    self.cellRightup.lbl_text.text = @"上传商铺实景";
    
    self.btn_Rightup = [[UIButton alloc] init];
    [self addSubview:self.btn_Rightup];
    [self.btn_Rightup setImage:[UIImage imageNamed:@"删除照片"] forState:UIControlStateNormal];
    self.btn_Rightup.hidden = YES;
    
    self.cellRightDown = [[SceneryCellView alloc] init];
    [self addSubview:self.cellRightDown];
    self.cellRightDown.lbl_text.text = @"上传商铺实景";
    
    
    self.btn_RightDown = [[UIButton alloc] init];
    [self addSubview:self.btn_RightDown];
    [self.btn_RightDown setImage:[UIImage imageNamed:@"删除照片"] forState:UIControlStateNormal];
    self.btn_RightDown.hidden = YES;
    
    
    if ([WYUTILITY.getMainScreen isEqualToString:@"5"]) {
        [self.cellTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@76);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(180*k5widthScale));
            make.height.equalTo(@(180*k5widthScale));
        }];
        [self.cellTop.photo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellTop.bg.mas_top).offset(35);
        }];
        [self.btn_top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellTop.mas_top);
            make.centerX.equalTo(self.cellTop.mas_right);
            make.width.equalTo(@(44*k5widthScale));
            make.height.equalTo(@(44*k5widthScale));
        }];
        [self.cellLeftup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellTop.mas_bottom).offset(26);
            make.left.equalTo(self.mas_left).offset(24);
            make.width.equalTo(@(140*k5widthScale));
            make.height.equalTo(@(140*k5widthScale));
        }];
        [self.btn_Leftup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellLeftup.mas_top);
            make.centerX.equalTo(self.cellLeftup.mas_right);
            make.width.equalTo(@(44*k5widthScale));
            make.height.equalTo(@(44*k5widthScale));
        }];
        [self.cellLeftDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellLeftup.mas_bottom).offset(28);
            make.left.equalTo(self.cellLeftup.mas_left);
            make.width.equalTo(@(140*k5widthScale));
            make.height.equalTo(@(140*k5widthScale));
        }];
        [self.btn_LeftDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellLeftDown.mas_top);
            make.centerX.equalTo(self.cellLeftDown.mas_right);
            make.width.equalTo(@(44*k5widthScale));
            make.height.equalTo(@(44*k5widthScale));
        }];
        [self.cellRightup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellTop.mas_bottom).offset(28);
            make.right.equalTo(self.mas_right).offset(-24);
            make.width.equalTo(@(140*k5widthScale));
            make.height.equalTo(@(140*k5widthScale));
        }];
        [self.btn_Rightup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellRightup.mas_top);
            make.centerX.equalTo(self.cellRightup.mas_right);
            make.width.equalTo(@(44*k5widthScale));
            make.height.equalTo(@(44*k5widthScale));
        }];
        [self.cellRightDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellRightup.mas_bottom).offset(28);
            make.left.equalTo(self.cellRightup.mas_left);
            make.width.equalTo(@(140*k5widthScale));
            make.height.equalTo(@(140*k5widthScale));
        }];
        [self.btn_RightDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellRightDown.mas_top);
            make.centerX.equalTo(self.cellRightDown.mas_right);
            make.width.equalTo(@(44*k5widthScale));
            make.height.equalTo(@(44*k5widthScale));
        }];
    }else{
        [self.cellTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(HEIGHT_NAVBAR+15));
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@180);
            make.height.equalTo(@180);
        }];
        [self.cellTop.photo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellTop.bg.mas_top).offset(40);
        }];
        [self.btn_top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellTop.mas_top);
            make.centerX.equalTo(self.cellTop.mas_right);
            make.width.equalTo(@44);
            make.height.equalTo(@44);
        }];
        [self.cellLeftup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellTop.mas_bottom).offset(26);
            make.left.equalTo(self.mas_left).offset(24);
            make.width.equalTo(@140);
            make.height.equalTo(@140);
        }];
        [self.btn_Leftup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellLeftup.mas_top);
            make.centerX.equalTo(self.cellLeftup.mas_right);
            make.width.equalTo(@44);
            make.height.equalTo(@44);
        }];
        [self.cellLeftDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellLeftup.mas_bottom).offset(28);
            make.left.equalTo(self.cellLeftup.mas_left);
            make.width.equalTo(@140);
            make.height.equalTo(@140);
        }];
        [self.btn_LeftDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellLeftDown.mas_top);
            make.centerX.equalTo(self.cellLeftDown.mas_right);
            make.width.equalTo(@44);
            make.height.equalTo(@44);
        }];
        [self.cellRightup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellTop.mas_bottom).offset(28);
            make.right.equalTo(self.mas_right).offset(-24);
            make.width.equalTo(@140);
            make.height.equalTo(@140);
        }];
        [self.btn_Rightup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellRightup.mas_top);
            make.centerX.equalTo(self.cellRightup.mas_right);
            make.width.equalTo(@44);
            make.height.equalTo(@44);
        }];
        [self.cellRightDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellRightup.mas_bottom).offset(28);
            make.left.equalTo(self.cellRightup.mas_left);
            make.width.equalTo(@140);
            make.height.equalTo(@140);
        }];
        [self.btn_RightDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.cellRightDown.mas_top);
            make.centerX.equalTo(self.cellRightDown.mas_right);
            make.width.equalTo(@44);
            make.height.equalTo(@44);
        }];
    }
    return self;
}

@end
