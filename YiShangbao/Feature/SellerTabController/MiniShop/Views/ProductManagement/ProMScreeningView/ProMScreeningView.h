//
//  ProMScreeningView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProMScreeningView;
@protocol ProMScreeningViewDelegate <NSObject>
@optional

-(BOOL)wy_proMScreeningView:(ProMScreeningView*)view shouldChangeSelected:(UIButton *)sender;
-(void)wy_proMScreeningView:(ProMScreeningView*)view didChangeTimeBtnSelected:(BOOL)time mainSelBtnSelected:(BOOL)mainSel changeTime:(BOOL)ischangeTime;

@end
@interface ProMScreeningView : UIView
@property(nonatomic,strong)UIButton *timeBtn;
@property(nonatomic,strong)UIButton *mainSelBtn;
@property(nonatomic,weak)id<ProMScreeningViewDelegate>delegate;

@end
