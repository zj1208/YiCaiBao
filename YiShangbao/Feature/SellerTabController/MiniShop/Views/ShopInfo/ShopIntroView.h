//
//  ShopIntroView.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ShopIntroView : UIView <UITextViewDelegate>

@property(nonatomic, strong)UIView *viewBg;
@property(nonatomic, strong)UITextView *textContent;
@property(nonatomic, strong)UILabel *lblChart;
@property(nonatomic, strong)UIButton *btn_confirm;

-(void)initUI:(id)data;
@end
