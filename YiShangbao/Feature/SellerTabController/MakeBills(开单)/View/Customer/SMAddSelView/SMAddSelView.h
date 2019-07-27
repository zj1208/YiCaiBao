//
//  SMAddSelView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClcikBlock)(NSInteger index);
@interface SMAddSelView : UIView
@property (weak, nonatomic) IBOutlet UIView *menuContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrain;
@property (weak, nonatomic) IBOutlet UIButton *mowBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBookBtn;

-(instancetype)initWithXib;
-(void)showSuperview:(UIView *)superview animated:(BOOL)animated;
@property(nonatomic,copy)ClcikBlock clickBlock;
@end
