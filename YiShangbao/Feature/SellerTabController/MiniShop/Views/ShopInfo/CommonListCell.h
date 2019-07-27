//
//  CommonListCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRadioButtonGroup.h"

@interface CommonListNoArrowCell : UIView
@property(nonatomic, strong)UILabel *title;
@property(nonatomic, strong)UITextField *input;
@property(nonatomic, strong)UIView *line;
@end


@interface CommonListCell : UIView
@property(nonatomic, strong)UILabel *title;
@property(nonatomic, strong)UILabel *subTitle;
@property(nonatomic, strong)UIImageView *arrow;
@property(nonatomic, strong)UIImageView *headImage;
@property(nonatomic, strong)UIButton *btn_cell;
@property(nonatomic, strong)UIView *line;
@end



@interface CommonRadioButtonCell : UIView
@property(nonatomic, strong)UILabel *title;
@property(nonatomic, strong)UIButton *button1;
@property(nonatomic, strong)UIButton *button2;
//@property(nonatomic, strong)MyRadioButtonGroup *RadioButton;
@end


@interface yiwuDetailCell : UIView
@property(nonatomic, strong) UIView *add_bg;
@property(nonatomic, strong) UITextField *txtfield_men;
@property(nonatomic, strong) UILabel *lblmen;
@property(nonatomic, strong) UIView *edge1;
@property(nonatomic, strong) UITextField *txtfield_lou;
@property(nonatomic, strong) UILabel *lbllou;
@property(nonatomic, strong) UIView *edge2;
@property(nonatomic, strong) UITextField *txtfield_jie;
@property(nonatomic, strong) UILabel *lbljie;
@property(nonatomic, strong) UILabel *lblnumber;
@property(nonatomic, strong) UITextField *txtfield_number;
@property(nonatomic, strong) UIView *num_bg;
@property(nonatomic, strong) UIView *line2;
@end



@interface CommonListChooseCell : UIView

@property(nonatomic, strong) CommonListCell *cell_chooseMarket;
@property(nonatomic, strong) yiwuDetailCell *yiwuDetailcell;
@property(nonatomic, strong)CommonListCell *cell_chooseDistrict;
@property(nonatomic, strong) UIView *line3;
@property(nonatomic, strong) UITextField *detailAdr;

@end

