//
//  SearchDetailDefaultCollViewCell.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchDetailDefaultCollViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *xianzuoImageView;

@property (weak, nonatomic) IBOutlet UIView *tuiguangContentView;
@property (weak, nonatomic) IBOutlet UILabel *tuiguangLabel;

-(void)setHalfLCDWCellData:(SearchModel *)data;
@end
