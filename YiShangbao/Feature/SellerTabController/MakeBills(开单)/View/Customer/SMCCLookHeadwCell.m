//
//  SMCCLookHeadwCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/5/16.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SMCCLookHeadwCell.h"

@implementation SMCCLookHeadwCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.infoContentView.layer.masksToBounds  =YES;//X
    
    //shadowColor阴影颜色
    self.infoContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    //shadowOffset阴影偏移,x向右偏移，y向下偏移（00四周偏移）
    self.infoContentView.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    self.infoContentView.layer.shadowOpacity = 0.12;
    //阴影半径，默认3
    self.infoContentView.layer.shadowRadius = 4.0;
    self.infoContentView.layer.cornerRadius = 6.0;
    self.infoContentView.clipsToBounds = NO; //不能切超出父视图

}

@end
