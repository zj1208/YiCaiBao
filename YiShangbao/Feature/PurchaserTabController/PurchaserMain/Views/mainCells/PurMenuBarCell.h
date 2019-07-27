//
//  PurMenuBarCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurMenuBarCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *iconIMV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)setCellData:(id) data;

@end
