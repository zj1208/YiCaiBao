//
//  TradeOrderSuccessViewController.h
//  YiShangbao
//
//  Created by 海狮 on 17/5/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeOrderSuccessViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *callPhonebtn;
@property (weak, nonatomic) IBOutlet UIButton *messagebtn;

//是否是外商直采
@property (assign, nonatomic) BOOL isForeign;
//外商发求购填写的email、mobile
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *mobile;

//电话号码
@property (nonatomic, copy) NSString *telString;
//IM
@property (nonatomic, copy) NSString *tradeId;

@property (weak, nonatomic) IBOutlet UILabel *miaoshuLabel;
//提示
@property (weak, nonatomic) IBOutlet UILabel *promptTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *promptImgView;

@property (weak, nonatomic) IBOutlet UIImageView *advImgView;
- (IBAction)tapAdvImgViewAction:(UITapGestureRecognizer *)sender;
@end
