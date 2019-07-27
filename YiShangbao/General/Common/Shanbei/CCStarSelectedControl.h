//
//  CCStarSelectedControl.h
//  YiShangbao
//
//  Created by light on 2018/3/19.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IndexChangeBlock)(NSInteger index);

@interface CCStarSelectedControl : UIControl


/**
 以Block返回选中Index
 Provide a block to be executed when selected index is changed.
 
 Alternativly, you could use `addTarget:action:forControlEvents:`
 */
@property (nonatomic, copy) IndexChangeBlock indexChangeBlock;


/**
 Index of the currently selected control.
 
 Default is '5'
 */
@property (nonatomic, assign) NSInteger selectedControlIndex;


/**
 starCount of the star count.
 
 Default is '5'
 */
@property (nonatomic, assign) NSInteger starCount;

/**
 spaceWidth of the star's space width.
 
 Default is '10'
 */
@property (nonatomic, assign) CGFloat spaceWidth;


/**
 starWidth of the star's width.
 
 Default is '19'
 */
@property (nonatomic, assign) CGFloat starWidth;

/**
 selectedStarImage of the selected StarImage UIImage.
 */
@property (nonatomic, strong) UIImage *selectedStarImage;

@property (nonatomic, strong) UIImage *notSelectedStarImage;

/**
 selectedStarImageName of the selected StarImage name.
 */
@property (nonatomic, copy) NSString *selectedStarImageName;


@property (nonatomic, copy) NSString *notSelectedStarImageName;


@end
