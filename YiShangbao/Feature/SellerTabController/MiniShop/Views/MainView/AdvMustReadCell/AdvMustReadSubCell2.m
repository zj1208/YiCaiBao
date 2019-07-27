//
//  AdvMustReadSubCell2.m
//  YiShangbao
//
//  Created by simon on 2018/1/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "AdvMustReadSubCell2.h"

@implementation AdvMustReadSubCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
      self.titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(14)];
}

-(void)setJLCycSrollCellData:(id)data
{
    ShopMustReadAdvModel* model = (ShopMustReadAdvModel *)data;
    self.titleLab.text = model.title;
 
}
@end
