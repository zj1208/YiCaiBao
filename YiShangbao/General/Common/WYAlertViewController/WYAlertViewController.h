//
//  WYAlertViewController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/5/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WYAlertBlock)(void);
@interface WYAlertViewController : UIViewController
//提示信息
@property(nonatomic,copy)NSString *alertMessage;
//左边按钮标题
@property(nonatomic,copy)NSString *leftBtnTitle;
//右边按钮标题
@property(nonatomic,copy)NSString *rightBtnTitle;
//是否是单个按钮,单个时其实是rightBtn
@property(nonatomic,assign)BOOL singleBtn;
- (void)addLeftBlock:(WYAlertBlock)leftBlock rightBlock:(WYAlertBlock)rightBlock;

/**
 快速创建一个按钮的信息提示弹框

 @param presentingVC presenting
 @param message 提示消息
 @param bottonBtnTitle 按钮标题
 @param bottonBtnBlock 按钮点击回调
 */
+ (void)presentedBy:(UIViewController *)presentingVC message:(NSString *)message  bottonBtnTitle:(NSString *)bottonBtnTitle bottonBtnBlock:(WYAlertBlock)bottonBtnBlock;

/**
  快速创建两个按钮的信息提示弹框

 @param presentingVC presenting
 @param animated 警告动画
 @param message 提示消息
 @param leftBtnTitle 左边按钮标题
 @param leftBlock 左边按钮点击回调
 @param rightBtnTitle 右边按钮标题
 @param rightBlock 右边按钮点击回调
 */
+ (void)presentedBy:(UIViewController *)presentingVC animated:(BOOL)animated message:(NSString *)message  leftBtnTitle:(NSString *)leftBtnTitle leftBlock:(WYAlertBlock)leftBlock rightBtnTitle:(NSString *)rightBtnTitle rightBlock:(WYAlertBlock)rightBlock;

/**
 eg:
     [WYAlertViewController presentedBy:self message:@"阿呆发呆发呆发大发阿发发发地方发呆发呆发呆发呆发" bottonBtnTitle:@"呵呵" bottonBtnBlock:nil];

     [WYAlertViewController presentedBy:self animated:YES message:@"这个采购商没有留下联系方式噢～可以尝试与他进行在线沟通。" leftBtnTitle:@"取消" leftBlock:^{
 
     } rightBtnTitle:@"去认证" rightBlock:^{
 
     }];
 
 */
@end





