//
//  WYUIStyle.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/6.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

/**
 *  使用范例
 *  self.button.color = WYUISTYLE.colorMred;
 *  self.label.font = WYUISTYLE.fontWith30;
 *
 */

#define WYUISTYLE [WYUIStyle style]


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYUIStyle : NSObject

+ (WYUIStyle *)style;
//---------------------hex色值处理----------------------
- (UIColor *) colorWithHexString:(NSString *) hexString;
//－－－－－－－－－－－－根据hex色值绘制水平渐变色图片－－－－－－－－－－－
-(UIImage*)imageWithStartColorHexString:(NSString*)startHexString EndColorHexString:(NSString*)endHexString WithSize:(CGSize)size;
//－－－－－－－－－－－－垂直方向渐变－－－－－－－－－－－
- (UIImage *)hk_getGradientImageWithSize:(CGSize)size locations:(const CGFloat[])locations components:(const CGFloat[])components count:(NSInteger)count;


//---------------------规范颜色
-(UIColor *)colorF3F3F3;          //self.view背景色

-(UIColor *)colorMred;          //主色红色
//-(UIColor *)colorBtnred;        //按钮红
-(UIColor *)colorPink;          //粉色
-(UIColor *)colorSorange;       //辅色橙色
-(UIColor *)colorSblue;         //辅色蓝色
-(UIColor *)colorMTblack;       //文字主要黑色
-(UIColor *)colorLTgrey;        //文字次要灰色
-(UIColor *)colorSTgrey;        //文字辅助灰色
-(UIColor *)colorBTgrey;         //文字背景灰
-(UIColor *)colorBWhite;        //背景白
-(UIColor *)colorBGgrey;        //背景灰
-(UIColor *)colorLinegrey;        //线条灰
-(UIColor *)colorBGyellow;     //背景黄
- (UIColor *)colorLineBGgrey;  //分割线灰－新


//---------------------规范字体
-(UIFont *)fontWith36;
-(UIFont *)fontWith32;
-(UIFont *)fontWith30;
-(UIFont *)fontWith28;
-(UIFont *)fontWith24;


//输入框快速设置占位符、字体颜色、leftView--主要应用在海豚注册登录相关模块
+ (void)setTextFieldWithPl:(NSString *)pl imageName:(NSString *)imName LblColor:(UIColor *)lblcolor  withField:(UITextField*)field;
+ (void)setTextFieldWithNoImagePl:(NSString *)pl LblColor:(UIColor *)lblcolor withField:(UITextField*)field;


//按钮背景（注册登录某种渐变图）
+ (UIImage *)ButtonBackgroundWithSize:(CGSize)size;
//UIcolor转UIimage
+ (UIImage*)imageWithColor: (UIColor*)color;



//-------------------------------------------------
//--------------UI改版设置(V3.0.0+)------------------
//-------------------------------------------------
#pragma mark - ---------商家端------------
#pragma mark 渐变图
+ (UIImage *)imageBF352D_BD2B23:(CGSize)size; //导航栏
+ (UIImage *)imageE23728_CF2218:(CGSize)size;//我要接、订单列表

+ (UIImage *)imageFDAB53_FD7953:(CGSize)size;//开单预览<保存到相册>、接生意详情
+ (UIImage *)imageFD7953_FE5147:(CGSize)size;//开单预览<发送给客户>、开单预览设置<保存设置>

+ (UIImage *)imageFF8848_FF5535:(CGSize)size;//选择产品

#pragma mark 字体
+ (UIColor *)colorBD2F26;
+ (UIColor *)colorFF5434;



#pragma mark - ---------买家端------------
#pragma mark 渐变图
//+ (UIImage *)imageFE4D37_FD7953:(CGSize)size;





@end
