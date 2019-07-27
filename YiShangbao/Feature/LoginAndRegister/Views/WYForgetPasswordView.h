//
//  WYForgetPasswordView.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryCell.h"

@interface WYForgetPasswordView : UIView
@property (nonatomic, strong)UIScrollView *scroll_bg;

@property (nonatomic, strong)UIView *viewbg;
@property(nonatomic, strong) CountryCell *codeCell;
@property (nonatomic, strong)UITextField *txtField_phoneNumber;
@property (nonatomic, strong)UIButton *btn_send;
@property (nonatomic, strong)UIView *linephone;

@property (nonatomic, strong)UIView *linesend;
@property (nonatomic, strong)UITextField *txtField_smsNumber;
@property (nonatomic, strong)UIView *linesms;

@property (nonatomic, strong)UIButton *btn_confirm;

@end
