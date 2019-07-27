//
//  SaleClientsCell.h
//  YiShangbao
//
//  Created by simon on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SaleClientsCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *leftRankingBtn;

@property (weak, nonatomic) IBOutlet UILabel *productNameLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

- (void)setData:(id)data withIndexPath:(NSIndexPath *)indexPath;
@end
