//
//  SODProductsRefundDetailCollectionViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SODProductsRefundDetailCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *IMV;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *productSizeLabel;

-(void)setData:(id)data;

@end
