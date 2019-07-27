//
//  WYODAddressAndMessageTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYODAddressAndMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *addressContentview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *liuyanContentview;
@property (weak, nonatomic) IBOutlet UILabel *liuyanLabel;

-(void)setCellData:(id)data;

-(CGFloat)getCellHeightWithContentData:(id)data;
@end
