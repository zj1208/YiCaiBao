//
//  WYLoginView.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryCell.h"

@interface WYLoginView : UIView

@property(nonatomic, strong) UIScrollView *scroll_bg;

@property(nonatomic, strong) UIButton *btn_colse;
@property(nonatomic, strong) UIButton *btn_register;

@property(nonatomic, strong) UIImageView *image_logo;

@property(nonatomic, strong) CountryCell *codeCell;
@property(nonatomic, strong) UITextField *txtField_phoneNumber;
@property(nonatomic, strong) UIView *linephone;
@property(nonatomic, strong) UIButton *historyPhoneBtn;

@property(nonatomic, strong) UITextField *txtField_password;
@property(nonatomic, strong) UIView *linepswd;

@property(nonatomic, strong) UIButton *btn_forgetPswd;
@property(nonatomic, strong) UIButton *btn_fastPhoneLogin;

@property(nonatomic, strong) UIButton *btn_confirm;

@property(nonatomic, strong) UIView *lineleft;
@property(nonatomic, strong) UIView *lineright;
@property(nonatomic, strong) UILabel *lbl_wx;
@property(nonatomic, strong) UIButton *btn_wx;

@property(nonatomic, strong) UIButton *btn_changeEnv;

@end
