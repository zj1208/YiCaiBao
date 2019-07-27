//
//  SMSelectProductCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSelectProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView;
@property (weak, nonatomic) IBOutlet UILabel *proTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *proSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *proPriceLabel;

-(void)setData:(id)data;
@end
