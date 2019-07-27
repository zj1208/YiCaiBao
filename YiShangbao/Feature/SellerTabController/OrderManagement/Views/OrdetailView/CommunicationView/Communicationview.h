//
//  CommunicationView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//-------联系买家／拨打电话

#import <UIKit/UIKit.h>

@interface CommunicationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *IMBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

//buttonUid		string	底部 联系人标识
//buttonCall		string	底部 联系人电话
-(void)setButtonUid:(NSString*)buttonUid buttonCall:(NSString*)buttonCall;
@end
