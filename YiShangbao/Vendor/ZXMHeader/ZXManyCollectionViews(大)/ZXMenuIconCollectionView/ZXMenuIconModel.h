//
//  ZXMenuIconModel.h
//  YiShangbao
//
//  Created by simon on 2018/2/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//标记
typedef NS_ENUM(NSInteger, SideMarkType){
    
    //    无
    SideMarkType_none = 0,
    //    红点
    SideMarkType_redDot = 1,
    //    数字
    SideMarkType_number = 2,
    //    图片
    SideMarkType_image = 3,
    
};

@interface ZXMenuIconModel : NSObject


@property (nonatomic, copy) NSString *icon;


@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) SideMarkType sideMarkType;

@property (nonatomic, copy) NSString *sideMarkValue;

@end

NS_ASSUME_NONNULL_END

