//
//  BillShareView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/17.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareBlock)(SSDKPlatformType shareType);
@interface BillShareView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottonContentView;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;

-(instancetype)initWithXib;
-(void)showSuperview:(UIView *)superview animated:(BOOL)animated;
-(void)dismiss:(BOOL)animated;

@property(nonatomic,copy)ShareBlock shareBlock;
@end
