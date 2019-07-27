//
//  ProductClassSecondSectionCollectionViewCell.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ProductClassSecondSectionCollectionViewCell.h"
#import "WYUIStyle.h"
@implementation ProductClassSecondSectionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"828282"].CGColor;
    self.layer.cornerRadius = self.frame.size.height/2;
    
}
-(void)setCurryState:(WYClassCellType)curryState
{
    _curryState = curryState;
    if (_curryState == 0) {
        self.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"828282"].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.textLabelWY.textColor = [[WYUIStyle style] colorWithHexString:@"535353"];
        
    }else if(_curryState == 1){
        self.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"FE744A"].CGColor;
        self.backgroundColor = [[WYUIStyle style] colorWithHexString:@"FFF5F1"];
        self.textLabelWY.textColor = [[WYUIStyle style] colorWithHexString:@"FF6935"];
    }
}
@end
