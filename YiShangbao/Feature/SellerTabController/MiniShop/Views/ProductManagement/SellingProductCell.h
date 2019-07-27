//
//  SellingProductCell.h
//  YiShangbao
//
//  Created by simon on 17/2/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SellingProductCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
//主营
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *supplyOfGoodsLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;


@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *promotionBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
