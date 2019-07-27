//
//  ClientLegendCollectionCell.h
//  YiShangbao
//
//  Created by simon on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ZXCustomCollectionVCell.h"

@interface ClientLegendCollectionCell : ZXCustomCollectionVCell

@property (weak, nonatomic) IBOutlet UILabel *colorLab;

@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end
