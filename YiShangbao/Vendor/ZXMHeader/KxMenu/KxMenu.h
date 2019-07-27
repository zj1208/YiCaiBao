//
//  KxMenu.h
//  kxmenu project
//  https://github.com/kolyvan/kxmenu/
//
//  Created by Kolyvan on 17.05.13.
//

/*
 Copyright (c) 2013 Konstantin Bukreev. All rights reserved.
 
 */


typedef enum {
    KxMenuCellSeperateStyleNone,   //不设置 分割线；
    KxMenuCellSeperateStyleLine, // 有分割线；
} KxMenuCellSeperateStyle;



#import <Foundation/Foundation.h>

#import "KxMenuItem.h"
@interface KxMenu : NSObject

@property(nonatomic) BOOL  observing;


//overlay背景色，默认是透明的；
@property(nonatomic,strong)UIColor * kxMenuOverlayBackgroundColor;

//KxMenuView背景色
@property(nonatomic,strong)UIColor * tintColor;

/**
 *@brief 设置字体大小；
 */
@property(nonatomic,strong)UIFont *titleFont;

/**
 *@brief 分割线样式；
 */
@property(nonatomic)KxMenuCellSeperateStyle kxMenuCellSeperateStyle;



/**
 *@brief set 内容按钮边缘距离；
 */
@property(nonatomic)UIEdgeInsets contentViewEdge;

/**
 *@brief 设置选中背景状态；
 */

@property(nonatomic,strong)UIColor *kxMenuSelectionBackgoundColor;

+ (instancetype) sharedMenu;


/**
 *@brief 获取箭头大小－高度；
 */
//@property(nonatomic,readonly)CGFloat arrowHeight;


+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems;

+ (void)dismissMenu;

@end




/*************** eg**************
 
 - (IBAction)rightBarItemAction:(UIBarButtonItem *)sender
 {
    NSArray * menuItems =@[[KxMenuItem menuItem:@"发消息" image:nil target:self action:@selector(sendMessageTo:)],[KxMenuItem menuItem:@"找好友" image:nil target:self
    action:@selector(findFriends:)]];

    KxMenu *kxMenu = [KxMenu sharedMenu];
    kxMenu.tintColor =[UIColor colorWithWhite:0.2 alpha:0.7];
 //   kxMenu.selectionBackgroundImageStyle = KxMenuSelectionStyleSolidColorBackground;
    kxMenu.contentViewEdge = UIEdgeInsetsMake(5, 5, 5, 5);
    [KxMenu showMenuInView:APP_keyWindow fromRect:CGRectMake(LCDW-44-5, 20-10, 44, 44) menuItems:menuItems];
 }
 
 
 - (void)sendMessageTo:(KxMenuItem *)sender
 {
 
 }
 
 
 - (void)findFriends:(KxMenuItem *)sender
 {
 
 }
 */
