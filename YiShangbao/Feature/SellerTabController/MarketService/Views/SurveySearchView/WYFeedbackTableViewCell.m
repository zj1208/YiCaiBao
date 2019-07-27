//
//  WYFeedbackTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/26.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYFeedbackTableViewCell.h"

@implementation WYFeedbackTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        if(!self.icon){
            self.icon = [[UIImageView alloc] init];
            self.icon.image = [UIImage imageNamed:@"通报按钮"];
            [self.contentView addSubview:self.icon];
        }
        if(!self.content){
            self.content = [[UILabel alloc]init];
            [self.contentView addSubview:self.content];
            self.content.textColor = WYUISTYLE.colorMTblack;
            self.content.font = WYUISTYLE.fontWith24;
            self.content.numberOfLines = 0;
        }
        
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@12);
            make.width.equalTo(@20);
        }];
        
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(12);
            make.top.equalTo(self.icon.mas_top);
//            make.width.lessThanOrEqualTo(@311);
            make.right.equalTo(self.mas_right).offset(-12);
        }];
    }
    return self;
}

- (float)getAutoCellHeight {
    [self layoutIfNeeded];
    /**
     *    self.最底部的控件.frame.origin.y      为自适应cell中的最后一个控件的Y坐标
     *    self.最底部的空间.frame.size.height   为自适应cell中的最后一个控件的高
     *    marginHeight    为自适应cell中的最后一个控件的距离cell底部的间隙
     */
    return  self.content.frame.origin.y + self.content.frame.size.height + 10;
          
}


@end
