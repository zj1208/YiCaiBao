//
//  ProductSearchCell.h
//  YiShangbao
//
//  Created by simon on 2017/11/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProductSearchCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
//主营
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//产品类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *supplyOfGoodsLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;



@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *promotionBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
