//
//  RefundDetailWaitTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundDetailWaitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *decLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerSecondLabel;

@property (weak, nonatomic) IBOutlet UIButton *revocationBtn;

-(void)setCellData:(id)data;

@end
