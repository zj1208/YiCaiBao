//
//  SendProductCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SendProductCell : BaseTableViewCell

//用imageView，在自动布局中图片会放大；
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;

@property (weak, nonatomic) IBOutlet UILabel *numProLab;
@property (weak, nonatomic) IBOutlet UIButton *picBtn;

@end
