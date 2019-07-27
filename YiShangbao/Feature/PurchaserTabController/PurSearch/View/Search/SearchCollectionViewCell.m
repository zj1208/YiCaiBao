//
//  SearchCollectionViewCell.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@implementation SearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = [WYUISTYLE colorWithHexString:@"828282"].CGColor;

}

//-(CGFloat)getCellWidthWithString:(NSString *)str
//{
//    UIFont *font = self.titleLabel.font;
//    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 35.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
//    if (rect.size.width >LCDW-40) {
//        return LCDW-40;
//    }
//    return rect.size.width;
//}
-(void)setCurryState:(SearchCollectionViewCellType)curryState
{
    _curryState = curryState;
    if (_curryState == 0) {
        self.contentView.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"828282"].CGColor;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [[WYUIStyle style] colorWithHexString:@"535353"];
        
    }else if(_curryState == 1){
        self.contentView.layer.borderColor = [[WYUIStyle style] colorWithHexString:@"F58F23"].CGColor;
        self.contentView.backgroundColor = [[WYUIStyle style] colorWithHexString:@"FEF7EF"];
        self.titleLabel.textColor = [[WYUIStyle style] colorWithHexString:@"F58F23"];
    }
}
@end
