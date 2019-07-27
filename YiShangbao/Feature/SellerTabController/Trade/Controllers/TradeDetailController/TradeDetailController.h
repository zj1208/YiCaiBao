//
//  TradeDetailController.h
//  YiShangbao
//
//  Created by simon on 17/1/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  详情页


#import <UIKit/UIKit.h>


@interface TradeDetailController : UIViewController

@property (nonatomic,copy)NSString *nTitle;
@property (nonatomic,copy)NSString *postId;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

//底部容器视图
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

//打电话按钮
@property (weak, nonatomic) IBOutlet UIButton *bottomCallBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hozEdgeLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hozEdgeLeftLayout;
//马上接单
@property (weak, nonatomic) IBOutlet UIView *bottomOrderingView;
//倒计时
@property (weak, nonatomic) IBOutlet UILabel *countTimeLab;
//立即抢单按钮
@property (weak, nonatomic) IBOutlet UIButton *takeOrdingBtn;

- (IBAction)takeOrderingAction:(UIButton *)sender forEvent:(UIEvent *)event;

- (IBAction)callIphoneAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIView *tableFooterView;



@end
