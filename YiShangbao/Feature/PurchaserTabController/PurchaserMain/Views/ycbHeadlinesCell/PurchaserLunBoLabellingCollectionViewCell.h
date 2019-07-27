//
//  PurchaserLunBoLabellingCollectionViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLCycSrollCellDataProtocol.h"
@interface PurchaserLunBoLabellingCollectionViewCell : UICollectionViewCell<JLCycSrollCellDataProtocol>
@property (weak, nonatomic) IBOutlet UIButton *biaoqianBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
