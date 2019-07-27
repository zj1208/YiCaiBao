//
//  PurchaserLunBoLabellingCollectionViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchaserLunBoLabellingCollectionViewCell.h"
#import "PurchaserModel.h"
@implementation PurchaserLunBoLabellingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

/**
 JLCycSrollCellDataProtocol

 @param data <#data description#>
 */
-(void)setJLCycSrollCellData:(id)data
{
    NewsModel* model = (NewsModel*)data;
    
    [self.biaoqianBtn setTitle:model.label forState:UIControlStateNormal];

    self.titleLabel.text = model.title;
}
@end
