//
//  FenLeiTitleCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/8/29.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "FenLeiTitleCell.h"

@implementation FenLeiTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.layer.cornerRadius = LCDScale_5Equal6_To6plus(25.f)/2.f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = [WYUISTYLE colorWithHexString:@"828282"].CGColor;

}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
     if(selected)
     {
        self.contentView.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"F58F23"].CGColor;
        self.contentView.backgroundColor = [[WYUIStyle style] colorWithHexString:@"FEF7EF"];
        self.titleLabel.textColor = [[WYUIStyle style] colorWithHexString:@"F58F23"];
     }
     else
     {
         self.contentView.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"828282"].CGColor;
         self.contentView.backgroundColor = [UIColor whiteColor];
         self.titleLabel.textColor = [[WYUIStyle style] colorWithHexString:@"535353"];
    }
}
@end
