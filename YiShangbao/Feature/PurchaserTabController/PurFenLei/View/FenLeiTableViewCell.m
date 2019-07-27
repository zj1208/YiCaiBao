//
//  FenLeiTableViewCell.m
//  YiShangbao
//
//  Created by 海狮 on 17/7/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "FenLeiTableViewCell.h"

@implementation FenLeiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCurryType:(FenLeiTableViewCellType)curryType
{
    _curryType = curryType;
    
    if (_curryType == 1) {
        self.myimageView.hidden = NO;
        self.myTitlelabel.backgroundColor = [UIColor whiteColor];
        self.myTitlelabel.textColor = [WYUISTYLE colorWithHexString:@"F58F23"];

    }else{
        self.myimageView.hidden = YES;
        self.myTitlelabel.backgroundColor = [WYUISTYLE colorWithHexString:@"F8F8F8"];
        self.myTitlelabel.textColor = [WYUISTYLE colorWithHexString:@"535353"];

    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
