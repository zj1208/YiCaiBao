//
//  TradeDetailForeignInfoController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/5/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeDetailForeignInfoController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *messageContentView;

@property (weak, nonatomic) IBOutlet UIView *firstMessView;
@property (weak, nonatomic) IBOutlet UIButton *firstMessBtn;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UIView *secondMessView;
@property (weak, nonatomic) IBOutlet UIButton *secondMessBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *mobile;

+(void)presentBy:(UIViewController *)presenting email:(NSString *)email  mobile:(NSString *)mobile;
@end
