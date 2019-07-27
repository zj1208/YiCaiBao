//
//  PurchaserTuiJianCollectionViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaserTuiJianCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xianhuoimageView;

-(void)settData:(id)data;
@end
