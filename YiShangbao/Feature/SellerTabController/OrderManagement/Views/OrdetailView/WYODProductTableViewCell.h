//
//  WYODProductTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SODProductsView.h"

@interface WYODProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopnameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;

@property (weak, nonatomic) IBOutlet SODProductsView *productsview;

@property (weak, nonatomic) IBOutlet UILabel *shangpinzongjiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *dingdanzongjiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *shijifukuanlabel;

@property (weak, nonatomic) IBOutlet UIView *commitContentView;

-(void)setCellData:(id)data;

@end
