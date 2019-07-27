//
//  ChangePasswordView.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordView : UIView
@property (nonatomic, strong)UIScrollView *scroll_bg;

@property (nonatomic, strong)UITextField *txtField_oldPswd;
@property (nonatomic, strong)UIButton *btn_oldHide;
@property (nonatomic, strong)UIView *lineoldpswd;

@property (nonatomic, strong)UITextField *txtField_newPswd;
@property (nonatomic, strong)UIButton *btn_newHide;
@property (nonatomic, strong)UIView *linepswd;

@property (nonatomic, strong)UITextField *txtField_againPswd;
@property (nonatomic, strong)UIButton *btn_againHide;
@property (nonatomic, strong)UIView *lineagainpswd;

@property (nonatomic, strong)UILabel *lbl_notice;

@property (nonatomic, strong)UIButton *btn_confirm;
@end
