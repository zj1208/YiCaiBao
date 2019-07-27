//
//  WYODPlaceOrderFlowTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SODFlowView.h"

@interface WYODPlaceOrderFlowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SODFlowView *flowview;
@property (weak, nonatomic) IBOutlet UIImageView *headeView;
@property (weak, nonatomic) IBOutlet UILabel *firstDecLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondDecLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

-(void)setCellData:(id)data;

@end
