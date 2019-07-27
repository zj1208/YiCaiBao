//
//  WYMainViewController.h
//  YiShangbao
//
//  Created by Lance on 16/12/5.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLMoveTitleButton.h"
#import "ZXBadgeIconButton.h"


@interface WYMainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//自定义UIView导航栏
@property (weak, nonatomic) IBOutlet UIView *customNavigationBarView;
@property (weak, nonatomic) IBOutlet UIImageView *customNavigationBarImageView;//背景图
@property (weak, nonatomic) IBOutlet UIButton *backBtn; //返回
@property (weak, nonatomic) IBOutlet UIButton *tradeLeftBarbutton; //已接
@property (weak, nonatomic) IBOutlet UIButton *businessSetBtn; //接生意设置
@property (weak, nonatomic) IBOutlet UIImageView *businessRedPointIMV;//设置接生意引导红点

@property (weak, nonatomic) IBOutlet UIButton *businessSearchBtn; //生意搜索

//流动广告
@property (weak, nonatomic) IBOutlet UIView *topbackview;
@property (weak, nonatomic) IBOutlet JLMoveTitleButton *trademoveButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

//筛选
@property (weak, nonatomic) IBOutlet UIView *shaixuanContentView;
@property (weak, nonatomic) IBOutlet UIButton *newsBtn; //最新发布
@property (weak, nonatomic) IBOutlet UIButton *stockBtn;  //库存专区
@property (weak, nonatomic) IBOutlet UIButton *relatedToMeBtn; //系统推荐
@property (weak, nonatomic) IBOutlet UILabel *numsLabel;
@property (weak, nonatomic) IBOutlet UIView *moveline;


@end
