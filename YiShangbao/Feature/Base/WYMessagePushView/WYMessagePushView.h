//
//  WYMessagePushView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/11/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Completion)(void);
@interface WYMessagePushView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iocnImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mesLabel;

@property (weak, nonatomic) IBOutlet UIView *xiayuanjiaoContentView;
@property (weak, nonatomic) IBOutlet UIView *huifuContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *huifuHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateTop;

@property (weak, nonatomic) IBOutlet UIButton *btn;

-(instancetype)initWithData:(id)data;
-(void)showToWindowAfterCompletion:(Completion)completion;
-(void)dismissWithAnimated:(BOOL)animated completion:(Completion)completion;
@property(nonatomic, readonly) CGFloat mHeight;


//默认NO,移除后会立即恢复dele.Window.windowLevel优先级为系统默认值
@property(nonatomic, assign) BOOL isIgnoreSetWindowLevelNormal; //多条消息弹出时,状态栏“隐藏”失败(弹出时修改为高优先级、移除时修改为默认值，但由于动画因素、可能还没完全弹出上一条变移除了，然后修改优先级状态栏又出来了),所以设置不恢复Window默认优先级

@end
