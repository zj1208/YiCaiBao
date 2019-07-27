//
//  WYODInformationTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYODInformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bizOrderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;


@property (weak, nonatomic) IBOutlet UIButton *ComplaintTelephoneBtn;
-(void)setCellData:(id)data;

- (CGFloat)getCellHeightWithContentData:(id)data;
@end
