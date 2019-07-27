//
//  CCRightButton.h
//  YiShangbao
//
//  Created by light on 2018/4/2.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, CCRightButtonType) {
    CCRightButtonTypeDefault = 0,
    //------以下暂无配置-------
    CCRightButtonTypeBuyer = (1 << 0),
    CCRightButtonTypeSeller = (1 << 1),
    CCRightButtonTypeFirst = (1 << 2),
    CCRightButtonTypeSecond = (1 << 3)
};


@interface CCRightButton : UIControl

@property (nonatomic, strong) UIButton *button;

/**
 rightButtonType of the CCRightButton type
 
 Default is 'CCRightButtonTypeDefault'
 */
@property (nonatomic) CCRightButtonType rightButtonType;

/**
 titleColorHex of the CCRightButton title's color hex
 
 Default is '0xE23728'
 */
@property (nonatomic) NSInteger titleColorHex;

/**
 titleFontSize of the CCRightButton title's font size
 
 Default is '14.0'
 */
@property (nonatomic) CGFloat titleFontSize;

/**
 backgroundColorHex of the CCRightButton background's color hex
 
 Default is '0xFFF5F6'
 */
@property (nonatomic) NSInteger backgroundColorHex;

/**
 borderColorHex of the CCRightButton border's color hex
 
 Default is '0xE23728'
 */
@property (nonatomic) NSInteger borderColorHex;


/**
 borderColorWidth of the CCRightButton border's width
 
  Default is '0.5'
 */
@property (nonatomic) CGFloat borderColorWidth;

@property (nonatomic, readwrite) UIEdgeInsets buttonEdgeInset;


- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;

@end
