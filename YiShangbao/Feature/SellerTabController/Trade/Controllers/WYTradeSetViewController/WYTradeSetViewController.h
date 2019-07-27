//
//  WYTradeSetViewController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"
@interface WYTradeSetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *contentView; //scrollerview容器

@property (weak, nonatomic) IBOutlet UILabel *classHadSelectedLabel;
@property (weak, nonatomic) IBOutlet UIView *textViewContentView;

@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *zxTextView;
@property (weak, nonatomic) IBOutlet UILabel *numWordsOfcountLabel;

@property (weak, nonatomic) IBOutlet UISwitch *messageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stockSwitch;

@property (weak, nonatomic) IBOutlet UIView *notiContentView;
@property (weak, nonatomic) IBOutlet UIButton *gotoOpenBtn;


@end
