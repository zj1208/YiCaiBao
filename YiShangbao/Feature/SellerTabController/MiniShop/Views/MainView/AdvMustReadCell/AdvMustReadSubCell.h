//
//  AdvMustReadSubCell.h
//  YiShangbao
//
//  Created by simon on 2017/12/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  弃用

#import <UIKit/UIKit.h>
#import "JLCycSrollCellDataProtocol.h"
#import "MessageModel.h"

@interface AdvMustReadSubCell : UICollectionViewCell<JLCycSrollCellDataProtocol>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detialLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
