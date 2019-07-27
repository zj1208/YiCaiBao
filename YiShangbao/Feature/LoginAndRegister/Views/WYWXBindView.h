//
//  WYWXBindView.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryCell.h"
#import "YYText.h"

@interface WYWXBindView : UIView
@property (nonatomic, strong)UIScrollView *scroll_bg;

@property (nonatomic, strong)UIView *viewPhonebg;
@property(nonatomic, strong) CountryCell *codeCell;
@property (nonatomic, strong)UITextField *txtField_phoneNumber;
@property (nonatomic, strong)UIButton *btn_send;
@property (nonatomic, strong)UIView *linephone;

@property (nonatomic, strong)UIView *linesend;
@property (nonatomic, strong)UITextField *txtField_smsNumber;
@property (nonatomic, strong)UIView *linesms;

@property (nonatomic, strong)UIView *viewpwdbg;
@property (nonatomic, strong)UITextField *txtField_name;
@property (nonatomic, strong)UIView *linename;
@property (nonatomic, strong)UITextField *txtField_pswd;
@property (nonatomic, strong)UIButton *btn_hide;
@property (nonatomic, strong)UIView *linepswd;

@property (nonatomic, strong)UITextField *txtField_inviteNumber;
@property (nonatomic, strong)UIView *lineinvite;

@property (nonatomic, strong) UIButton *btn_agree;
@property (nonatomic, strong) UILabel *label_agree;
@property (nonatomic, strong) UIButton *btn_read;

@property (nonatomic, strong) UIButton *btn_confirm;

@property (nonatomic, strong) YYLabel *label_agreement;

@end
