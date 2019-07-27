//
//  CommonListCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CommonListCell.h"


//eg:  【商铺名称   义商宝】
@implementation CommonListNoArrowCell
- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBWhite;
    self.title = [[UILabel alloc] init];
    [self addSubview:self.title];
    self.title.font = WYUISTYLE.fontWith28;
    self.title.textColor = WYUISTYLE.colorLTgrey;
    
    self.input = [[UITextField alloc] init];
    [self addSubview:self.input];
    self.input.placeholder = @"请输入商铺名称";
//    [self.input setValue:WYUISTYLE.colorBTgrey forKey:@"_placeholderLabel.textColor"];
//    [self.input setValue:WYUISTYLE.fontWith28 forKeyPath:@"_placeholderLabel.font"];
    self.input.font = WYUISTYLE.fontWith28;
    self.input.leftViewMode = UITextFieldViewModeAlways;
    self.input.textAlignment = NSTextAlignmentRight;
    self.input.textColor = WYUISTYLE.colorMTblack;
    
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    self.line.backgroundColor = WYUISTYLE.colorLinegrey;
    
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(self.mas_centerY);
    }];

    [self.input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(SCREEN_WIDTH-100));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH-12));
        make.height.equalTo(@0.5);
    }];
    return self;
}


@end

//eg: 【商铺头像  img or 我叫MT  >】
@implementation CommonListCell
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = WYUISTYLE.colorBWhite;
    self.title = [[UILabel alloc] init];
    [self addSubview:self.title];
    self.title.font = WYUISTYLE.fontWith28;
    self.title.textColor = WYUISTYLE.colorLTgrey;
    
    self.subTitle = [[UILabel alloc] init];
    [self addSubview:self.subTitle];
    self.subTitle.font = WYUISTYLE.fontWith28;
    self.subTitle.textColor = WYUISTYLE.colorBTgrey;
    self.subTitle.textAlignment = NSTextAlignmentRight;
    
    self.headImage = [[UIImageView alloc] init];
    [self addSubview:self.headImage];
    self.headImage.image = [UIImage imageNamed:@"defaultUse.jpg"];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 15;
    self.headImage.hidden = YES;
    
    self.arrow = [[UIImageView alloc] init];
    [self addSubview:self.arrow];
    self.arrow.image = [UIImage imageNamed:@"rightArrow"];
    
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    self.line.backgroundColor = WYUISTYLE.colorLinegrey;
    
    self.btn_cell = [[UIButton alloc] init];
    [self addSubview:self.btn_cell];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.width.equalTo(@80);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@8);
        make.height.equalTo(@14);
    }];
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow.mas_left).offset(-12);
        make.left.equalTo(self.title.mas_right).offset(12);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow.mas_left).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH-12));
        make.height.equalTo(@0.5);
    }];
    [self.btn_cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    
    return self;
}
@end

@implementation CommonRadioButtonCell

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = WYUISTYLE.colorBWhite;
    self.title = [[UILabel alloc] init];
    [self addSubview:self.title];
    self.title.font = WYUISTYLE.fontWith28;
    self.title.textColor = WYUISTYLE.colorLTgrey;
    
    self.button1 = [[UIButton alloc] init];
    [self addSubview:self.button1];
    self.button2 = [[UIButton alloc] init];
    [self addSubview:self.button2];
    
    [self.button1 setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    [self.button1 setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.button1.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    [self.button1 setTitle:@"内销" forState:UIControlStateNormal];
    self.button1.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.button1 setTitleColor:WYUISTYLE.colorBTgrey forState:UIControlStateNormal];
    [self.button1 setTitleColor:WYUISTYLE.colorMred forState:UIControlStateSelected];
    self.button1.titleLabel.font = WYUISTYLE.fontWith28;
    [self.button1 setSelected:NO];
    
    [self.button2 setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    [self.button2 setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.button2.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    [self.button2 setTitle:@"外贸" forState:UIControlStateNormal];
    self.button2.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [self.button2 setTitleColor:WYUISTYLE.colorBTgrey forState:UIControlStateNormal];
    [self.button2 setTitleColor:WYUISTYLE.colorMred forState:UIControlStateSelected];
    self.button2.titleLabel.font = WYUISTYLE.fontWith28;
    [self.button2 setSelected:NO];
    
//    CGRect buttonFrame = CGRectMake(0, 16, 122, 44);
//    self.RadioButton = [[MyRadioButtonGroup alloc]initWithFrame:CGRectMake(160, 10, SCREEN_WIDTH-160, 44)];
//    [self addSubview:self.RadioButton];
//    [self.RadioButton setAutoFitButtonSize:YES];//设置自动适应
//    [self.RadioButton setDirection:Horizontal];//设置方向会水平
//    MyRadioButton* rb1 = [[MyRadioButton alloc]initWithTitle:@"内销" andIndex:0 withFrame:buttonFrame autoSubSize:NO];
//
//    //button自动使用
//    MyRadioButton* rb2 = [[MyRadioButton alloc]initWithTitle:@"外贸" andIndex:1 withFrame:buttonFrame autoSubSize:NO];
//    [self.RadioButton addRadioButton:rb1];
//    [self.RadioButton addRadioButton:rb2];
    

//    [self.RadioButton setDefaultSeletedWithIndex:0];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(@120);
//        make.height.equalTo(@60);
    }];
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.button2.mas_left).offset(-40);
//        make.width.equalTo(@120);
//        make.height.equalTo(@60);
    }];
    
//    [self.RadioButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.title.mas_right).offset(5);
//        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(@(SCREEN_WIDTH-self.title.frame.size.width-60));
//        make.height.equalTo(@44);
//    }];
    return self;
}

@end


@implementation yiwuDetailCell

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = WYUISTYLE.colorBWhite;

    self.add_bg = [[UIView alloc] init];
    [self addSubview:self.add_bg];
    
    self.txtfield_men = [[UITextField alloc] init];
    [self.add_bg addSubview:self.txtfield_men];
//    [self.txtfield_men setValue:WYUISTYLE.colorBTgrey forKey:@"_placeholderLabel.textColor"];
//    [self.txtfield_men setValue:WYUISTYLE.fontWith28 forKeyPath:@"_placeholderLabel.font"];
    self.txtfield_men.font = WYUISTYLE.fontWith28;
    self.txtfield_men.textColor = WYUISTYLE.colorMTblack;
    self.txtfield_men.textAlignment = NSTextAlignmentCenter;
//    self.txtfield_men.keyboardType = UIKeyboardTypeNumberPad;
    
    self.lblmen = [[UILabel alloc] init];
    [self.add_bg addSubview:self.lblmen];
    self.lblmen.text = @"门";
    
    self.edge1 = [[UIView alloc] init];
    [self.add_bg addSubview:self.edge1];
    
    self.txtfield_lou = [[UITextField alloc] init];
    [self.add_bg addSubview:self.txtfield_lou];
//    [self.txtfield_lou setValue:WYUISTYLE.colorBTgrey forKey:@"_placeholderLabel.textColor"];
//    [self.txtfield_lou setValue:WYUISTYLE.fontWith28 forKeyPath:@"_placeholderLabel.font"];
    self.txtfield_lou.font = WYUISTYLE.fontWith28;
    self.txtfield_lou.textColor = WYUISTYLE.colorMTblack;
    self.txtfield_lou.textAlignment = NSTextAlignmentCenter;
    self.txtfield_lou.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.lbllou = [[UILabel alloc] init];
    [self.add_bg addSubview:self.lbllou];
    self.lbllou.text = @"楼";
    
    self.edge2 = [[UIView alloc] init];
    [self.add_bg addSubview:self.edge2];
    
    self.txtfield_jie = [[UITextField alloc] init];
    [self.add_bg addSubview:self.txtfield_jie];
//    [self.txtfield_jie setValue:WYUISTYLE.colorBTgrey forKey:@"_placeholderLabel.textColor"];
//    [self.txtfield_jie setValue:WYUISTYLE.fontWith28 forKeyPath:@"_placeholderLabel.font"];
    self.txtfield_jie.font = WYUISTYLE.fontWith28;
    self.txtfield_jie.textColor = WYUISTYLE.colorMTblack;
    self.txtfield_jie.textAlignment = NSTextAlignmentCenter;
//    self.txtfield_jie.keyboardType = UIKeyboardTypeNumberPad;
    
    self.lbljie = [[UILabel alloc] init];
    [self.add_bg addSubview:self.lbljie];
    self.lbljie.text = @"街";
    
    self.num_bg = [[UIView alloc] init];
    [self addSubview:self.num_bg];
    
    self.lblnumber = [[UILabel alloc] init];
    [self.num_bg addSubview:self.lblnumber];
    self.lblnumber.text = @"商位号";
    
    self.txtfield_number = [[UITextField alloc] init];
    [self.num_bg addSubview:self.txtfield_number];
//    [self.txtfield_number setValue:WYUISTYLE.colorBTgrey forKey:@"_placeholderLabel.textColor"];
//    [self.txtfield_number setValue:WYUISTYLE.fontWith28 forKeyPath:@"_placeholderLabel.font"];
    self.txtfield_number.font = WYUISTYLE.fontWith28;
    self.txtfield_number.textColor = WYUISTYLE.colorMTblack;
    self.txtfield_number.placeholder = @"多个商位号用逗号隔开";
    self.txtfield_number.textAlignment = NSTextAlignmentCenter;
//    self.txtfield_number.keyboardType = UIKeyboardTypeNumberPad;
    
    
    self.txtfield_men.layer.cornerRadius = self.txtfield_lou.layer.cornerRadius = self.txtfield_jie.layer.cornerRadius = self.txtfield_number.layer.cornerRadius = 5;
    self.txtfield_men.layer.borderWidth = self.txtfield_lou.layer.borderWidth = self.txtfield_jie.layer.borderWidth = self.txtfield_number.layer.borderWidth = 0.5;
    self.txtfield_men.layer.borderColor = self.txtfield_lou.layer.borderColor = self.txtfield_jie.layer.borderColor = self.txtfield_number.layer.borderColor = WYUISTYLE.colorLinegrey.CGColor;
    self.lblmen.font = self.lbllou.font = self.lbljie.font = self.lblnumber.font = WYUISTYLE.fontWith28;
    self.lblmen.textColor = self.lbllou.textColor = self.lbljie.textColor = self.lblnumber.textColor =  WYUISTYLE.colorLTgrey;
    
    self.line2 = [[UIView alloc] init];
    [self addSubview:self.line2];
    self.line2.backgroundColor = WYUISTYLE.colorLinegrey;
    
    [self.add_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    [self.txtfield_men mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.add_bg.mas_centerY);
        make.left.equalTo(@14);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    [self.lblmen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.add_bg.mas_centerY);
        make.right.equalTo(self.edge1.mas_left).offset(-10);
        make.width.equalTo(@15);
        //        make.height.equalTo(@43);
    }];
    [self.edge1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.add_bg.mas_centerY);
        make.left.equalTo(@(SCREEN_WIDTH*0.333));
        make.width.equalTo(@0.5);
        make.height.equalTo(@1);
    }];
    [self.txtfield_lou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.add_bg.mas_centerY);
        make.left.equalTo(self.edge1.mas_right).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    [self.lbllou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.add_bg.mas_centerY);
        make.right.equalTo(self.edge2.mas_left).offset(-10);
        make.width.equalTo(@15);
    }];
    [self.edge2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.add_bg.mas_centerY);
        make.left.equalTo(@(SCREEN_WIDTH*0.666));
        make.width.equalTo(@0.5);
        make.height.equalTo(@1);
    }];
    [self.txtfield_jie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.add_bg.mas_centerY);
        make.left.equalTo(self.edge2.mas_right).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    [self.lbljie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.add_bg.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.equalTo(@15);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.add_bg.mas_bottom);
        make.left.equalTo(@14);
        make.width.equalTo(@(SCREEN_WIDTH-14));
        make.height.equalTo(@0.5);
    }];
    
    [self.num_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.add_bg.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.lblnumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.num_bg.mas_centerY);
        make.left.equalTo(self.num_bg.mas_left).offset(10);
        make.width.equalTo(@45);
    }];
    
    [self.txtfield_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.num_bg.mas_centerY);
        make.left.equalTo(self.lblnumber.mas_right).offset(10);
        make.right.equalTo(self.num_bg.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];

    return self;
}

@end






@implementation CommonListChooseCell
- (id)init {
    self = [super init];
    if (!self) return nil;

    self.backgroundColor = WYUISTYLE.colorBWhite;
    
    self.cell_chooseMarket = [[CommonListCell alloc] init];
    [self addSubview:self.cell_chooseMarket];
    self.cell_chooseMarket.title.text = @"选择市场";
    
    self.yiwuDetailcell = [[yiwuDetailCell alloc] init];
    [self addSubview:self.yiwuDetailcell];
    
    self.cell_chooseDistrict = [[CommonListCell alloc] init];
    [self addSubview:self.cell_chooseDistrict];
    self.cell_chooseDistrict.title.text = @"所在地区";
    self.cell_chooseDistrict.hidden = YES;
    
    self.detailAdr = [[UITextField alloc] init];
    [self addSubview:self.detailAdr];
    self.detailAdr.font = WYUISTYLE.fontWith28;
    self.detailAdr.placeholder = @"输入具体位置，精确到商位号";;
//    [self.detailAdr setValue:WYUISTYLE.colorBTgrey forKeyPath:@"_placeholderLabel.textColor"];
//    [self.detailAdr setValue:WYUISTYLE.fontWith28 forKeyPath:@"_placeholderLabel.font"];
    self.detailAdr.hidden = YES;
    
    self.line3 = [[UIView alloc] init];
    [self addSubview:self.line3];
    
    self.line3.backgroundColor =  WYUISTYLE.colorLinegrey;
    
    [self.cell_chooseMarket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.yiwuDetailcell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cell_chooseMarket.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@88);
    }];
    
    [self.cell_chooseDistrict mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cell_chooseMarket.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@0);
    }];
    
    [self.detailAdr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cell_chooseDistrict.mas_bottom);
        make.left.equalTo(@14);
        make.width.equalTo(@(SCREEN_WIDTH-28));
        make.height.equalTo(@0);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailAdr.mas_bottom).offset(-0.5);
        make.left.equalTo(@14);
        make.width.equalTo(@(SCREEN_WIDTH-14));
        make.height.equalTo(@0.5);
    }];
    return self;
}

@end
