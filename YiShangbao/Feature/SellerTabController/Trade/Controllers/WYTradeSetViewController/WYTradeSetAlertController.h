//
//  WYTradeSetAlertController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClcikBlock)(UIButton *btn);
@interface WYTradeSetAlertController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic,copy)BtnClcikBlock btnClcikBlock;

@end
