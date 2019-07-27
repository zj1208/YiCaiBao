//
//  CCSelectedControl.h
//  YiShangbao
//
//  Created by light on 2018/4/13.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexSelectedBlock)(NSInteger index);

@interface CCSelectedControl : UIControl

@property (nonatomic, strong) NSArray<NSString *> *titles;


/**
 以Block返回选中Index
 Provide a block to be executed when selected index is changed.
 
 Alternativly, you could use `addTarget:action:forControlEvents:`
 */
@property (nonatomic, copy) IndexSelectedBlock indexChangeBlock;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, assign) CGFloat cellHeight;

/**
 spaceWidth of the star's space width.
 
 Default is '0.5'
 */
@property (nonatomic, assign) CGFloat spaceWidth;

@property (nonatomic, strong) UIColor *spaceColor;

@property (nonatomic, readwrite) UIEdgeInsets spaceEdgeInset;

/**
 Index of the currently selected control.
 
 Default is '5'
 */
@property (nonatomic, assign) NSInteger selectedControlIndex;

@property (nonatomic, readwrite) UIEdgeInsets backImageViewEdgeInset;

@end
