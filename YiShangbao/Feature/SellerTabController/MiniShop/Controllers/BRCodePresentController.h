//
//  BRCodePresentController.h
//  YiShangbao
//
//  Created by simon on 2018/2/2.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRCodePresentController : UIViewController

@property (nonatomic, copy) void (^doActionHandleBlock)(void);


- (IBAction)doBtnAction:(UIButton *)sender;

@property (nonatomic, copy) void (^cancleActionHandleBlock)(void);


- (IBAction)cancleBtnAction:(UIButton *)sender;

@end
