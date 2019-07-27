//
//  ApplyRefundsProductsTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyRefundsProductsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productIMG;

-(void)setCellData:(id)data;
@end
