//
//  WYSelectedTableViewCell.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSelectedTableViewCell.h"

@implementation WYSelectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
-(void)setCurrtTepe:(WYSelectedTableViewCellStyle)currtTepe
{
    _currtTepe = currtTepe;
    if (_currtTepe == 1) {
        self.myimageView.hidden = NO;
        self.myTitleLabel.textColor = [WYUISTYLE  colorWithHexString:@"F58F23"];
    }else{
        self.myimageView.hidden = YES;
        self.myTitleLabel.textColor = [WYUISTYLE  colorWithHexString:@"757575"];

    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
