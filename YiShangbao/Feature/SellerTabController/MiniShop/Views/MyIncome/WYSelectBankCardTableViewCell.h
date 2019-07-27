//
//  WYSelectBankCardTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYSelectBankCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankIMV;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectIMV;

-(void)setCellData:(id)data;
@end
