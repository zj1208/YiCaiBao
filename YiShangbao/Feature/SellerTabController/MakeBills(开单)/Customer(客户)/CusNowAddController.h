//
//  CusNowAddController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CusNowAddControllerType) {
    CusNowAdd_add  = 0,
    CusNowAdd_look = 1,  //改为SMCCLookViewController替换展示（v3.5.0）
    CusNowAdd_edit = 2,
    
};
@interface CusNowAddController : UIViewController
@property(nonatomic)CusNowAddControllerType type;
@property(nonatomic,copy)NSString *contactId; //查看，编辑需要
@end
