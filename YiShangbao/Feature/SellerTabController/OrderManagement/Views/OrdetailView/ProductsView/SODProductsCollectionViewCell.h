//
//  SODProductsCollectionViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SODProductsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *IMV;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *productSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *finalPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numsLabel;

-(void)setData:(id)data;
@end
